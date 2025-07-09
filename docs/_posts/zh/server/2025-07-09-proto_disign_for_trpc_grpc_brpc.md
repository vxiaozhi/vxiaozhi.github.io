---
layout:     post
title:      "trpc/brpc/grpc协议设计"
subtitle:   "trpc/brpc/grpc协议设计"
date:       2025-07-09
author:     "vxiaozhi"
catalog: true
tags:
    - server
    - trpc
    - brpc
    - grpc
---

## trpc

- [tRPC协议设计](https://github.com/trpc-group/trpc/blob/main/docs/zh/trpc_protocol_design.md)
- [trpc.proto](https://github.com/trpc-group/trpc/blob/main/trpc/trpc.proto)

## grpc

四种通信模式实现​​:

​- ​Unary RPC​​：单一请求对应单一响应（类似传统 HTTP 请求）。
​​- Server Streaming​​：服务端通过同一流发送多个响应。
​​- Client Streaming​​：客户端通过同一流发送多个请求。
​​- Bidirectional Streaming​​：全双工通信，双方可异步发送消息（基于 HTTP/2 流控机制）。

协议设计参考：
- [GRPC底层传输协议](https://wbice.cn/article/GRPC%E5%BA%95%E5%B1%82%E4%BC%A0%E8%BE%93%E5%8D%8F%E8%AE%AE.html)
- [HTTP/2协议规范](https://httpwg.org/specs/rfc9113.html)

## brpc

bRPC是百度开源，用C++语言编写的工业级RPC框架，常用于搜索、存储、机器学习、广告、推荐等高性能系统。

"bRPC"的含义是"better RPC"

- [bRPC发展历史](https://gist.github.com/baymaxium/fe6b83bab082d3f640fd12f9c610cdf0)
- [baidu_std](https://github.com/apache/brpc/blob/master/docs/cn/baidu_std.md)
- [wireshark_baidu_std](https://github.com/apache/brpc/blob/master/docs/cn/wireshark_baidu_std.md)
- [streaming_rpc](https://github.com/apache/brpc/blob/master/docs/cn/streaming_rpc.md)

