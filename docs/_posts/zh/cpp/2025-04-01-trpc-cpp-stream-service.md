---
layout:     post
title:      "trpc-cpp流式服务"
subtitle:   "trpc-cpp流式服务"
date:       2025-04-01
author:     "vxiaozhi"
catalog: true
tags:
    - cpp
    - trpc
---

## 流式应用场景

- 大规模数据包。 比如，有一个大文件需要传输。 使用流式 RPC 时，客户端分片读出文件内容后直接写入到流中，服务端可以按客户端写入顺序读取到文件分片内容，然后执行业务逻辑。 如果使用单次 RPC，需要多次调用RPC方法，会遇到分包、组包、乱序、业务逻辑上下文切换等问题。
- 实时场景。 比如，股票行情走势，资讯 Feeds 流。 服务端接收到消息后，需要往多个客户端进行实时消息推送，流式 RPC 可以在一次 RPC 调用过程中，推送完整的消息列表。
- Istio、Envoy、Nacos 等项目，内部都是用 gRPC 作为通信协议来实现控制平面

## 三种流式 RPC 方法
tRPC 协议的流式 RPC 分为三种类型：

- 客户端流式 RPC：客户端发送一个或者多个请求消息，服务端发送一个响应消息。
- 服务端流式 RPC：客户端发送一个请求消息，服务端发送一个或多个响应消息。
- 双向流式 RPC：客户端发送一个或者多个请求消息，服务端发送一个或者多个响应消息。
  
## 流式协议和线程模型
tRPC 协议的流式服务支持两种线程模型：

- fiber 线程模型支持同步流式 RPC。
- merge 线程模型支持异步流式 RPC。

## 启动过程分析（以 fiber 模型为例）

**fiber 启动流程**

```
int InitFrameworkRuntime():trpc/common/runtime_manager.cc
  - void fiber::StartRuntime() :trpc/runtime/fiber_runtime.cc(这里会读取配置中的 fiber 线程模型，根据线程模型决定启动哪一种 ThreadModel)
    - void FiberThreadModel::Start()
      - void FiberWorker::Start():trpc/runtime/threadmodel/fiber/detail/fiber_worker.cc 创建线程，运行 WorkGroup
        - void FiberWorker::WorkerProc()
          - void SchedulingGroup::Schedule()
            - void SchedulingImpl::Schedule():trpc/runtime/threadmodel/fiber/detail/scheduling/v1/scheduling_impl.cc
              - FiberEntity* SchedulingImpl::AcquireFiber()

```

Schedule 循环调用 AcquireFiber 获取一个 fiber 进行运行：

```
void SchedulingImpl::Schedule() noexcept {
  while (true) {
    auto fiber = AcquireFiber();

    if (!fiber) {
      fiber = SpinningAcquireFiber();
      if (!fiber) {
        fiber = StealFiberFromForeignSchedulingGroup();
        TRPC_CHECK_NE(fiber, kSchedulingGroupShuttingDown);
        if (!fiber) {
          fiber = WaitForFiber();
          TRPC_CHECK_NE(fiber, static_cast<trpc::fiber::detail::FiberEntity*>(nullptr));
        }
      }
    }

    if (TRPC_UNLIKELY(fiber == kSchedulingGroupShuttingDown)) {
      break;
    }

    fiber->Resume();

    // HeartBeat(run_queue_.UnsafeSize());
  }
}
```

AcquireFiber 从 run_queue 中获取一个 fiber实体，代码如下：

```
FiberEntity* SchedulingImpl::AcquireFiber() noexcept {
  if (auto rc = GetOrInstantiateFiber(run_queue_.Pop())) {
    {
      // Acquiring the lock here guarantees us anyone who is working on this fiber
      // (with the lock held) has done its job before we returning it to the
      // caller (worker).
      std::scoped_lock _(rc->scheduler_lock);

      TRPC_CHECK(rc->state == FiberState::Ready);
      rc->state = FiberState::Running;
    }

    SchedulingVar::GetInstance()->ready_run_latency.Update(ReadTsc() - rc->last_ready_tsc);

    return rc;
  }

  return stopped_.load(std::memory_order_relaxed) ? kSchedulingGroupShuttingDown : nullptr;
}
```

总结： Fiber 启动后的终态是： 启动了n 个 thread， 每个thread 循环从队列中取出一个 fiber，然后执行。


**stream 任务调度**

先预测一下， stream 任务调度流程应该是：在一个合适的时机，比如流数据到来时，将其封装成 fiber 实体，然后放入到 fiber 队列中，等待被调度运行。
下面通过分析代码把该流程串起来：

从 trpc/stream/fiber_stream_job_scheduler.cc 开始， 这里定义了：

- void FiberStreamJobScheduler::Run()
- void FiberStreamJobScheduler::PushRecvMessage(StreamRecvMessage&& msg)
- RetCode FiberStreamJobScheduler::PushSendMessage(StreamSendMessage&& msg, bool push_front)

流调度器的初始化在这里：

```
CommonStream::CommonStream(StreamOptions&& options) : options_(std::move(options)) {
  if (options_.fiber_mode) {
    fiber_entity_ = MakeRefCounted<FiberStreamJobScheduler>(
        GetId(), this, [this](StreamRecvMessage&& msg) { return HandleRecvMessage(std::move(msg)); },
        [this](StreamSendMessage&& msg) { return HandleSendMessage(std::move(msg)); });
  }
  reader_writer_options_.simple_state = ReaderWriterOptions::NotReady;
  StreamVarHelper::GetInstance()->IncrementActiveStreamCount();
}
```


处理接收流消息的入口函数：

```
RetCode CommonStream::HandleRecvMessage(StreamRecvMessage&& msg) {
  TRPC_FMT_TRACE("stream, handle recv message, stream id: {}, message category: {}", GetId(),
                 StreamMessageCategoryToString(StreamMessageCategory{msg.metadata.stream_frame_type}));

  RetCode ret{RetCode::kSuccess};

  // 收到期望的流式帧，开始分类处理
  switch (static_cast<StreamMessageCategory>(msg.metadata.stream_frame_type)) {
    case StreamMessageCategory::kStreamData: {
      ret = HandleData(std::move(msg));
      break;
    }
    case StreamMessageCategory::kStreamInit: {
      ret = HandleInit(std::move(msg));
      break;
    }
    case StreamMessageCategory::kStreamClose: {
      ret = HandleClose(std::move(msg));
      break;
    }
    case StreamMessageCategory::kStreamFeedback: {
      ret = HandleFeedback(std::move(msg));
      break;
    }
    case StreamMessageCategory::kStreamReset: {
      ret = HandleReset(std::move(msg));
      break;
    }
    default: {
      Status status{GetDecodeErrorCode(), 0, "unsupported trpc stream frame type."};
      OnError(status);
      Reset(status);
      TRPC_LOG_ERROR(status.ErrorMessage());
    }
  }

  if (ret == RetCode::kSuccess) {
    SetStreamActiveTime(GetMilliSeconds());
  }

  return ret;
}
```

从这里开始，将进入收包流程，如下：

```
- RetCode TrpcServerStream::HandleInit(StreamRecvMessage&& msg) 
  - RetCode CommonStream::PushSendMessage(StreamSendMessage&& msg, bool push_front)
    - RetCode FiberStreamJobScheduler::PushSendMessage(StreamSendMessage&& msg, bool push_front)
      - bool StartFiberDetached(Function<void()>&& start_proc):trpc/coroutine/fiber.cc
        - bool SchedulingGroup::StartFiber(FiberDesc* fiber):trpc/runtime/threadmodel/fiber/detail/scheduling_group.cc
          - bool SchedulingImpl::StartFiber(FiberDesc* desc):trpc/runtime/threadmodel/fiber/detail/scheduling/v1/scheduling_impl.cc
            - bool SchedulingImpl::QueueRunnableEntity(RunnableEntity* entity, bool sg_local, bool wait)
```

QueueRunnableEntity 最终把包放入到 running_queue_ 中，与上面的fiber启动流程刚好对接上。

```
bool SchedulingImpl::QueueRunnableEntity(RunnableEntity* entity,
                                         bool sg_local, bool wait) noexcept {
  TRPC_DCHECK(!stopped_.load(std::memory_order_relaxed), "The scheduling group has been stopped.");

  // Push the fiber into run queue and (optionally) wake up a worker.
  if (TRPC_UNLIKELY(!run_queue_.Push(entity, sg_local))) {
    auto since = ReadSteadyClock();

    while (!run_queue_.Push(entity, sg_local)) {
      TRPC_FMT_INFO_EVERY_SECOND(
          "Run queue overflow. Too many ready fibers to run. If you're still "
          "not overloaded, consider increasing `trpc_fiber_run_queue_size`.");
      if (TRPC_UNLIKELY(ReadSteadyClock() - since > 2s)) {
        TRPC_FMT_INFO_EVERY_SECOND(
            "Failed to push fiber into ready queue after retrying for 2s. Retry again.");
        if (!wait) {
          return false;
        }
      }
      std::this_thread::sleep_for(100us);
    }
  }

  WakeUpOneWorker();

  return true;
}
```

## 参考

- [trpc-cpp客户端流式协议](https://github.com/trpc-group/trpc-cpp/blob/main/docs/zh/trpc_protocol_streaming_client.md)
- [trpc-cpp服务端流式协议](https://github.com/trpc-group/trpc-cpp/blob/main/docs/zh/trpc_protocol_streaming_service.md)
