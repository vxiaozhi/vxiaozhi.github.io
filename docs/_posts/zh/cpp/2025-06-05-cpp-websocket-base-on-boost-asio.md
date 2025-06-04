---
layout:     post
title:      "基于boost.asio的WebSocket类库"
subtitle:   "基于boost.asio的WebSocket类库"
date:       2025-06-05
author:     "vxiaozhi"
catalog: true
tags:
    - cpp
    - websocket
    - boost.asio
---

## zaphoyd/websocketpp

[WebSocket++ github ](https://github.com/zaphoyd/websocketpp)

具有以下特点：

- Header Only的跨平台 WebSocket 库
- 网络 IO 基于 Boost::asio 实现
- 由于boost::asio 的 io_context 使用了线程存储,所以在 M:N 的协程模式(fiber) 下调用需格外小心。最好是采用 1:N 的协程。
  
当服务作为客户端管理多个 Connection 时， 如果每个Connection 对象都使用一个 Client 对象， 由于 Client 在Connect（无论Url中使用IP还是域名） 时都会创建一个独立线程来进行域名解析，导致线程数过多，从而性能地下。

所以建议使用 一个Client 对象来管理多个 Connection可参考以下两个例子：

- [scratch_client](https://github.com/zaphoyd/websocketpp/tree/master/examples/scratch_client)
- [utility_client](https://github.com/zaphoyd/websocketpp/tree/master/examples/utility_client)