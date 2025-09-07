---
layout:     post
title:      "Python asyncio 的事件循环机制"
subtitle:   "Python asyncio 的事件循环机制"
date:       2025-09-07
author:     "vxiaozhi"
catalog: true
tags:
    - python
    - asyncio
---

在使用 Python 的 asyncio 库实现异步编程的过程中，协程与事件循环这两个概念可以说有着千丝万缕的联系，常常是形影不离的出现，如胶似漆般的存在。 

## Asyncio 事件循环的理解

- [FastAPI 文档中对 async 的介绍](https://fastapi.tiangolo.com/async/)
- [以定时器为例研究一手 Python asyncio 的协程事件循环调度](https://www.lipijin.com/python-asyncio-eventloop)
- [《asyncio 系列》1. 什么是 asyncio？如何基于单线程实现并发？事件循环又是怎么工作的？](https://www.cnblogs.com/traditional/p/17357782.html)
- [《asyncio 系列》2. 详解 asyncio 的协程、任务、future，以及事件循环 ](https://www.cnblogs.com/traditional/p/17363960.html)
- [《asyncio 系列》3. 详解 Socket（阻塞、非阻塞），以及和 asyncio 的搭配](https://www.cnblogs.com/traditional/p/17364391.html)

## 事件循环第三方实现

Python 的 EventLoop 是一个抽象类，它定义了事件循环的基本方法，如创建、运行、停止、注册回调函数等等。除了Python 自带的 asyncio 库，还有其他第三方库，它们都实现了 EventLoop 的功能，如：

- [uvloop](https://github.com/MagicStack/uvloop): uvloop is a fast, drop-in replacement of the built-in asyncio event loop. uvloop is implemented in Cython and uses libuv under the hood.
- [trio](https://github.com/python-trio/trio): a friendly Python library for async concurrency and I/O

其中 vuloop 是一个基于 libuv 的事件循环，它比 Python 内置的 asyncio 库更快，因此 被[web框架sanic](https://github.com/sanic-org/sanic) 使用。
sanic 速度非常快，号称是最快的 Python Web 框架之一。




