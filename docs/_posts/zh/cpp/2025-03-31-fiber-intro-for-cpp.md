---
layout:     post
title:      "C++协程介绍"
subtitle:   "C++协程介绍"
date:       2025-03-31
author:     "vxiaozhi"
catalog: true
tags:
    - cpp
    - fiber
---

## 协程(corouting)与纤程(fiber)区别

### 协程（Coroutine）​

N:1协程

协程是语言级别的特性（C++20原生支持），由编译器生成状态机逻辑，通过co_await、co_yield等关键字实现隐式挂起和恢复，无需直接操作底层上下文。

n:1协程也即在多个协程协作运行在一个系统线程上，当然系统线程可以有多个。基于封装层次，分为：非hook、部分hook、全面hook。

n:1协程很大的优点是，可以完全无锁编写同步风格代码，对于普通的互联网后台业务（IO-Bound型）编程是很友好的。

但是也有一个明显的缺点，各个线程之间无法均衡任务，导致一个线程中的某个协程运行过久，会影响到本线程的其他协程，也即不适合CPU-Bound型业务。

业界方案：

- [boost.context](https://github.com/boostorg/context)
- [Tencent Libco](https://github.com/Tencent/libco)
- [C++20 corouting](/2025/04/06/cpp20-corouting-intro/)

### 纤程(Fiber)

通常指M：N协程（也称作纤程），其实现是支持在多个系统原生线程（std::thread）上调度运行多个用户态线程（fiber）；主要特性如下：

- 多个线程间竞争共享fiber队列，在精心设计下可以达到较低的调度延迟。目前调度组大小（组内线程数）限定为8~15之间。
- 为了减少竞争，提升多核扩展性，设计了多调度组机制，调度组个数以及大小可以配置。
- 与pthread良好的互操作性

业界实现方案：

- google: marl https://github.com/google/marl
- baidu: brpc/bthread  https://github.com/apache/brpc
- tencent: flare/fiber https://github.com/Tencent/flare/tree/master/flare/fiber
- boost：fiber https://github.com/boostorg/fiber
- 魅族：libgo https://github.com/yyzybb537/libgo



## Runtime类型

参考： [trpc-cpp Runtime文档](https://github.com/trpc-group/trpc-cpp/blob/main/docs/zh/runtime.md)

### fiber m:n 协程

优点：

- 采用协程同步编程方式，方便编写逻辑复杂的业务代码；
- 网络IO和业务处理逻辑可多核并行化，能充分利用多核，做到很低的长尾延时。

缺点：

- 为了不阻塞线程，可能需要使用特定的协程同步原语进行同步，代码侵入性较强；
- 由于协程数受系统限制，且协程调度存在额外的开销，在QPS或连接数较大场景下性能表现不够好。

### default-separate：reactors + thread pool

优点：

- 各个Handle线程很自然地达到负载均衡。
- 各个任务天然隔离，适应任意类型的业务：IO-Bound(I/O密集型)、CPU-Bound（计算密集型）等。

缺点：

- 一个请求/回复，至少经过2个线程，会引入额外的调度延迟，在低延迟业务中有所不足。IO/Handle之间的通知机制需要良好设计，避免过多唤醒的系统调用。
- 在高并发时，IO/Handle之间的全局队列需要良好的设计，否则可能成为系统瓶颈。
- 需要考虑到CPU-Bound或者阻塞逻辑对continuation的影响，否则业务编程困难。
- 在部分业务场景，合适的IO/Handle线程数量比例难以估算，配置困难。

### default-merge：reactors in threads

优点：

- 架构简洁可靠：全异步方案，逻辑统一，易于理解。
- 对于NUMA架构天然适配。
- 一个请求/回复，只在一个线程处理，对于低延迟业务友好。
- 可以做到无锁编程。

缺点：

- 不允许阻塞代码，否则可能引起问题，所以对于业务开发门槛稍高。对于CPU-Bound业务同样不合适。
- 同一个线程中的各个任务容易互相干扰。


## 判断是否使用m:n协程的依据或者场景

判断使用同步或异步基本原则：计算qps * latency(in seconds)（来源于brpc的文档），如果和cpu核数是同一数量级，就用同步，否则用异步。
比如：

qps = 2000，latency = 10ms，计算结果 = 2000 * 0.01s = 20。和常见的32核在同一个数量级，用同步。

qps = 100, latency = 5s, 计算结果 = 100 * 5s = 500。和核数不在同一个数量级，用异步。

qps = 500, latency = 100ms，计算结果 = 500 * 0.1s = 50。基本在同一个数量级，可用同步。如果未来延时继续增长，考虑异步。

这个公式计算的是同时进行的平均请求数（你可以尝试证明一下），和线程数，cpu核数是可比的。

- 当这个值远大于cpu核数时，说明大部分操作并不耗费cpu，而是让大量线程阻塞着，使用异步可以明显节省线程资源（栈占用的内存）。
- 当这个值小于或和cpu核数差不多时，异步能节省的线程资源就很有限了，这时候简单易懂的同步代码更重要。
- 除此之外，还要看具体的业务场景，如果业务服务的场景会面对大量的短/长连接，m:n协程实现性能通常比不上通用线程模型，不太适合。


## 参考文档

- [trpc fiber 介绍](https://github.com/trpc-group/trpc-cpp/blob/main/docs/zh/fiber.md)
- [trpc fiber 指南](https://github.com/trpc-group/trpc-cpp/blob/main/docs/zh/fiber_user_guide.md)
