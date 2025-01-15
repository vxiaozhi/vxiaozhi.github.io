---
layout:     post
title:      "Python Http 客户端库"
subtitle:   "Python Http 客户端库"
date:       2025-01-15
author:     "vxiaozhi"
catalog: true
tags:
    - 编程语言
    - python
    - http
---

## urllib、urllib2

Python2中早期使用的http库 urllib、urllib2 ，给我们提供了许多方便的功能。

## requests

requests 是使用率非常高的 HTTP 库

## Httpx

但是自从 Python 3.6 之后的内置 asyncio 模块的兴起，异步方式 更加符合大众或业务上的需求。所以新一代 HTTP库 Httpx 应运而生。

它可以同时使用异步和同步方式来发送 HTTP 请求，并且比 requests 更快。它也支持许多 HTTP/2 特性，比如多路复用和服务端推送。

官方API：https://www.python-httpx.org/

该库的特性：

- • 广泛兼容请求的 API。
- • 标准同步接口，但如果需要，可以支持异步。
- • HTTP/1.1和 HTTP/2 支持。
- • 能够直接向WSGI 应用程序或ASGI 应用程序发出请求。
- • 到处都是严格的超时。
- • 完全类型注释。
- • 100% 的测试覆盖率。
