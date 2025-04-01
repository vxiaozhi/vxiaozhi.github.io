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

## 参考

- [trpc-cpp客户端流式协议](https://github.com/trpc-group/trpc-cpp/blob/main/docs/zh/trpc_protocol_streaming_client.md)
- [trpc-cpp服务端流式协议](https://github.com/trpc-group/trpc-cpp/blob/main/docs/zh/trpc_protocol_streaming_service.md)
