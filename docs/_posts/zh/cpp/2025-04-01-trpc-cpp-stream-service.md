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

fiber 启动：
```
int InitFrameworkRuntime():trpc/common/runtime_manager.cc
  - void fiber::StartRuntime() :trpc/runtime/fiber_runtime.cc(这里会读取配置中的 fiber 线程模型，根据线程模型决定启动哪一种 ThreadModel)
    - void FiberThreadModel::Start()
      - void FiberWorker::Start():trpc/runtime/threadmodel/fiber/detail/fiber_worker.cc
```

stream 任务调度

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
``


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

## 参考

- [trpc-cpp客户端流式协议](https://github.com/trpc-group/trpc-cpp/blob/main/docs/zh/trpc_protocol_streaming_client.md)
- [trpc-cpp服务端流式协议](https://github.com/trpc-group/trpc-cpp/blob/main/docs/zh/trpc_protocol_streaming_service.md)
