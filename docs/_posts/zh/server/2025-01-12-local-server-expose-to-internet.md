---
layout:     post
title:      "内网穿透工具"
subtitle:   "内网穿透工具"
date:       2025-01-12
author:     "vxiaozhi"
catalog: true
tags:
    - server
---

# 内网穿透工具

如果希望自己二次开发（有API可以调用）或者有多个租户（每个客户端一个单独的key），建议使用nps。
如果希望简单上手，没有多个租户的要求，建议使用[frp](https://github.com/fatedier/frp)。

通过在具有公网 IP 的节点上部署 frp 服务端，可以轻松地将内网服务穿透到公网，同时提供诸多专业的功能特性，这包括：

* 客户端服务端通信支持 TCP、QUIC、KCP 以及 Websocket 等多种协议。
* 采用 TCP 连接流式复用，在单个连接间承载更多请求，节省连接建立时间，降低请求延迟。
* 代理组间的负载均衡。
* 端口复用，多个服务通过同一个服务端端口暴露。
* 支持 P2P 通信，流量不经过服务器中转，充分利用带宽资源。
* 多个原生支持的客户端插件（静态文件查看，HTTPS/HTTP 协议转换，HTTP、SOCK5 代理等），便于独立使用 frp 客户端完成某些工作。
* 高度扩展性的服务端插件系统，易于结合自身需求进行功能扩展。
* 服务端和客户端 UI 页面。


## 参考

- [frp vs ngrok vs ssh 隧道](https://wiki.kpromise.top/project-1/doc-6/)
- [内网穿透工具比较(ngrok,frp,lanproxy,goproxy,nps)](https://blog.csdn.net/a1035434631/article/details/108010819)