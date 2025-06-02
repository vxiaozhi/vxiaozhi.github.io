---
layout:     post
title:      "C/C++ 实现的服务器和服务器相关的库"
subtitle:   "C/C++ 实现的服务器和服务器相关的库"
date:       2025-01-12
author:     "vxiaozhi"
catalog: true
tags:
    - server
    - cpp
---

# C/C++ 实现的服务器和服务器相关的库

## Http Server 

### NGINX

### HAProxy

### Envoy

### Apache HTTP Server

### Apache Traffic Server

- [Apache Traffic Server](https://github.com/apache/trafficserver)

Apache Traffic Server™ 是一种高性能 Web 代理缓存，它通过在网络边缘缓存经常访问的信息来提高网络效率和性能。这使内容在物理上更接近最终用户，同时实现更快的交付并减少带宽使用。Traffic Server 旨在通过最大化现有和可用带宽来改善企业、互联网服务提供商 (ISP)、骨干提供商和大型 Intranet 的内容交付。

Apache Traffic Server（ATS或TS）是一个高性能的、模块化的HTTP代理和缓存服务器，与 Nginx 和 Squid 类似。Traffic Server最初是 Inktomi 公司的商业产品，该公司在2003 年被 Yahoo 收购， 2009 年 8月 Yahoo 向 Apache 软件基金会（ASF）贡献了源代码，并于 2010 年 4月成为了 ASF的顶级项目（Top-LevelProject）。 Apache TrafficServer 现在是一个开源项目，开发语言为C++。

### Squid

- [Squid Web Proxy Cache](https://github.com/squid-cache/squid)
- 注意： github上并没有提供代码的发行版本，直接编译会失败。需要到其[官网](https://www.squid-cache.org/Versions/v6/)下载代码编译。

Squid：是一个高性能的代理缓存服务器，Squid 支持 FTP、gopher、HTTPS 和 HTTP协议。和一般的代理缓存软件不同，Squid用一个单独的、非模块化的、I/O驱动的进程来处理所有的客户端请求，作为应用层的代理服务软件，Squid 主要提供缓存加速、应用层过滤控制的功能。

### lighttpd2

- [lighttpd2](https://github.com/lighttpd/lighttpd2)

### Boa

- [ Boa web server](https://github.com/gpg/boa)

### TinyWebServer

- [TinyWebServer -- Linux下C++轻量级WebServer服务器 助力初学者快速实践网络编程，搭建属于自己的服务器](https://github.com/qinguoyi/TinyWebServer)

------------------

## 类库

### 基础库

- [POCO (Portable Components) C++ Librarie](https://github.com/pocoproject/poco)
- [Abseil - C++ Common Libraries](https://github.com/abseil/abseil-cpp) Google内部的C++轮子库，各种基础能力都包含，值得学习
- [Folly: Facebook Open-source Library](https://github.com/facebook/folly) Facebook内部的轮子库，线程池、内存池、异步IO、executor等，应有尽有

### Proxygen

- [Proxygen: Facebook's C++ HTTP Libraries](https://github.com/facebook/proxygen)

Proxygen 是 Facebook 开发的一个 C++ 的 HTTP 库，包含一个易用的 HTTP 服务器。支持 HTTP/1.1、SPDY 3 和 SPDY 3.1，同时也开始在为 HTTP/2 做开发。

Proxygen 并非为了替换 Apache 或者 Nginx，该项目主要是侧重于用 C 语言构建超级灵活的 HTTP 服务器，提供非常好的性能和灵活的配置。此外也是为了构建一个高性能的 C++ HTTP 框架。

Proxygen是一个Facebook发布的C++ HTTP框架Proxygen， 其中包括了一个HTTP server。Proxygen是oxygen的谐音，支持SPDY/3和SPDY/3.1，未来还将支持HTTP/2。Facebook工程师 称，Proxygen不是设计替代流行的HTTP server Apache或nginx，而是致力于构建一个很容易整合到现有应用程序的高性能C++ HTTP框架，帮助更多人构建和部署高性能C++ HTTP服务。

### muduo

- [muduo -- Event-driven network library for multi-threaded Linux server in C++11](https://github.com/chenshuo/muduo)


### Seastar

- [Seastar -- High performance server-side application framework](https://github.com/scylladb/seastar)

### WebSocket

- [WebSocket++ ](https://github.com/zaphoyd/websocketpp)
  - Header Only的跨平台 WebSocket 库
  - 网络 IO 基于 Boost::asio 实现
- [uWebSockets](https://github.com/uNetworking/uWebSockets)
- [Libwebsockets](https://github.com/warmcat/libwebsockets) 纯C实现

更多CPP WebSocket 库参考:[C++ WebSocket 库](https://hanpfei.github.io/2019/10/25/cpp_websocket/)

### 无锁队列

- [moodycamel::ConcurrentQueue ](https://github.com/cameron314/concurrentqueue) C++11 实现的工业级的无锁队列
- [atomic_queue](https://github.com/max0x7ba/atomic_queue) C++14 lock-free queue.

### 可观测性

[**The OpenTelemetry C++ Client**](https://github.com/open-telemetry/opentelemetry-cpp) 提供 Server 侧接入 Opentelemetry 的类库

- 历史​​：由 OpenTracing 和 OpenCensus 合并而成（2019年），是​​CNCF孵化项目​​，旨在统一追踪、指标、日志的观测性标准。
- ​​状态​​：​​活跃开发​​，被视为未来观测性工具的​​事实标准​​。
​​- 核心目标​​：提供​​全功能的SDK​​（包括API、数据采集、导出等），支持多信号（Tracing、Metrics、Logs）。

该库是线程安全的， 可参考 demo:

- [http demp ](https://github.com/open-telemetry/opentelemetry-cpp/tree/main/examples/http)
- [multithreaded demp](https://github.com/open-telemetry/opentelemetry-cpp/tree/main/examples/multithreaded)

[**opentracing-cpp**](https://github.com/opentracing/opentracing-cpp)

​​- 历史​​：OpenTracing 是早期分布式追踪的标准（2016年提出），旨在提供​​统一的API规范​​，由第三方厂商实现具体库（如Jaeger、LightStep等）。
​​- 状态​​：已进入维护模式（​​不推荐新项目使用​​），其维护者已转向 OpenTelemetry。
​​- 核心目标​​：标准化追踪API，解耦应用代码与具体追踪后端。

在分布式系统的可观测性（Observability）中，​​Tracing（追踪）、Logging（日志）、Metrics（指标）​​ 是三大核心支柱，它们相互补充，共同帮助开发者理解系统行为、诊断问题并优化性能。

​​- Tracing​​是“纵向”分析（单个请求的生命周期），​​Metrics​​是“横向”统计（系统整体状态），​​Logging​​是“点状”记录（关键事件快照）。
- 三者结合能构建完整的可观测性体系: Metrics告诉你“有问题”​​ → ​​Tracing告诉你“哪里有问题”​​ → ​​Logging告诉你“为什么有问题”​​。

## 参考

- [小白视角：一文读懂社长的TinyWebServer](https://huixxi.github.io/2020/06/02/%E5%B0%8F%E7%99%BD%E8%A7%86%E8%A7%92%EF%BC%9A%E4%B8%80%E6%96%87%E8%AF%BB%E6%87%82%E7%A4%BE%E9%95%BF%E7%9A%84TinyWebServer/#more)

