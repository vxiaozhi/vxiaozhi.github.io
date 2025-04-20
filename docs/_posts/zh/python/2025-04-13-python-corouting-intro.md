---
layout:     post
title:      "Python 协程简介"
subtitle:   "Python 协程简介"
date:       2025-04-13
author:     "vxiaozhi"
catalog: true
tags:
    - python
    - coroutine
---

Python 在 3.5 版本中引入了关于协程的语法糖 async 和 await, 在 python3.7 版本可以通过 asyncio.run() 运行一个协程。
所以建议大家学习协程的时候使用 python3.7+ 版本。

Python 官方提供了各个版本的 Pyothon 协程的文档，[协程官方文档](https://docs.python.org/zh-cn/3.13/library/asyncio-task.html)

## 协程概念

网上有个关于洗衣机的例子，写的挺好的，借用下：

```
假设有1个洗衣房，里面有10台洗衣机，有一个洗衣工在负责这10台洗衣机。
那么洗衣房就相当于1个进程，洗衣工就相当1个线程。
如果有10个洗衣工，就相当于10个线程，1个进程是可以开多线程的。这就是多线程！
```

**那么协程呢？**

```
先不急。大家都知道，洗衣机洗衣服是需要等待时间的，如果10个洗衣工，1人负责1台洗衣机，这样效率肯定会提高，但是不觉得浪费资源吗？
明明1 个人能做的事，却要10个人来做。只是把衣服放进去，打开开关，就没事做了，等衣服洗好再拿出来就可以了。
就算很多人来洗衣服，1个人也足以应付了，开好第一台洗衣机，在等待的时候去开第二台洗衣机，再开第三台，……直到有衣服洗好了，就回来把衣服取出来，
接着再取另一台的（哪台洗好先就取哪台，所以协程是无序的）。这就是计算机的协程！洗衣机就是执行的方法。
```

协程，又称微线程。

协程的作用是在执行函数A时可以随时中断去执行函数B，然后中断函数B继续执行函数A（可以自由切换）。

但这一过程并不是函数调用，这一整个过程看似像多线程，然而协程只有一个线程执行。

协程很适合处理IO密集型程序的效率问题。协程的本质是个单线程，它不能同时将 单个CPU 的多个核用上,因此对于CPU密集型程序协程需要和多进程配合。

## 可等待对象 await 的使用

可等待对象： 如果一个对象可以在 await 语句中使用，那么它就是 可等待 对象。许多 asyncio API 都被设计为接受可等待对象。

可等待 对象有三种主要类型: 协程, 任务 和 Future .

- 协程：python中的协程属于 可等待 对象，所以可以在其他协程中被等待
- time.sleep()：python中的sleep不是可等待对象，如果在协程中睡眠，需要使用asyncio.sleep()
- 同理 socket 读写也会导致协程阻塞，需要使用 asyncio.open_connection() 创建socket。
- asyncio提供了完善的异步IO支持，用asyncio.run()调度一个coroutine；
- 在一个async函数内部，通过await可以调用另一个async函数，这个调用看起来是串行执行的，但实际上是由asyncio内部的消息循环控制；
- 在一个async函数内部，通过await asyncio.gather()可以并发执行若干个async函数。

## Python VS 其它语言 协程对比

go的协程最大的优势在于它是语言内置的。从内存管理，gc到网络库, syscall以及对应的runtime实现的M:N的调度，都有很深的优化。同时经过多年的积淀，社区也基于内置的协程贡献了很多优秀的开源库，大家走遵照这同一个并发模型，也即是go推荐的模型来编写代码，使用起来很舒服。

js基于回调的特性真的是目前语言协程化做的最好的，因为没有阻塞调用，可以无痛把一个回调风格的API（如readFile）包装成 Promise，然后供async/await使用。任何回调风格的第三方库 API 都可以简单的 util.promisify 变成可供 await 的 Promise，不需要从底层添加API并且要求所有第三方库更改。而且一个API可以同时以回调风格和await被使用，可以说无缝升级。再借助babel，现在的js项目已经async/await用得飞起。

再反过来看很多语言的协程化进程，python为所有阻塞API在asyncio这个包里重新实现了一遍，但是社区所有数据库驱动、网络请求库、http server 库都需要为它重写，这个生态能不能火起来还是未知数。

现在唯一的期待就是rust尽快从语言标准层面拥抱协程，这玩意语言官方越晚接受，社区就越伤筋动骨。
  
## 相关协程库

- [web框架sanic](https://github.com/sanic-org/sanic) Python http 异步框架。
- [aiohttp](https://github.com/aio-libs/aiohttp)
- [FastAPI](https://fastapi.tiangolo.com/zh/async/)
- [httpx](https://github.com/encode/httpx) 同时支持http同步、http异步API。
- [数据库驱动的asyncpg](https://github.com/MagicStack/asyncpg) A fast PostgreSQL Database Client Library for Python/asyncio.
- [协程库trio](https://github.com/python-trio/trio) a friendly Python library for async concurrency and I/O
- [Python redis 异步调用](https://redis-py.readthedocs.io/en/stable/examples/asyncio_examples.html)

