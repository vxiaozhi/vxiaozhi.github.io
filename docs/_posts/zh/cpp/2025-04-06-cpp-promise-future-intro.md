---
layout:     post
title:      "c++ Promise/Future模型"
subtitle:   "c++ Promise/Future模型"
date:       2025-04-06
author:     "vxiaozhi"
catalog: true
tags:
    - cpp
---

Promise/Future是一种经典的异步抽象，由于其“标准化”的概念，提供了很多可能性。这就如同工业史的集装箱、软件界的docker，由于其“标准化”，不同组件可以简单地自由组合，从而提升了整体效率。

## C++11 中 Promise/Future 模型

C++11 标准中 <future> 头文件里面的类和相关函数。

<future> 头文件中包含了以下几个类和函数：

- Providers 类：std::promise, std::package_task
- Futures 类：std::future, shared_future.
- Providers 函数：std::async()
- 其他类型：std::future_error, std::future_errc, std::future_status, std::launch.
  
### std::promise 类介绍

promise 对象可以保存某一类型 T 的值，该值可被 future 对象读取（可能在另外一个线程中），因此 promise 也提供了一种线程同步的手段。在 promise 对象构造时可以和一个共享状态（通常是std::future）相关联，并可以在相关联的共享状态(std::future)上保存一个类型为 T 的值。

可以通过 get_future 来获取与该 promise 对象相关联的 future 对象，调用该函数之后，两个对象共享相同的共享状态(shared state)

- promise 对象是异步 Provider，它可以在某一时刻设置共享状态的值。
- future 对象可以异步返回共享状态的值，或者在必要的情况下阻塞调用者并等待共享状态标志变为 ready，然后才能获取共享状态的值。
- 
下面以一个简单的例子来说明上述关系

```
#include <iostream>       // std::cout
#include <functional>     // std::ref
#include <thread>         // std::thread
#include <future>         // std::promise, std::future

void print_int(std::future<int>& fut) {
    int x = fut.get(); // 获取共享状态的值.
    std::cout << "value: " << x << '\n'; // 打印 value: 10.
}

int main ()
{
    std::promise<int> prom; // 生成一个 std::promise<int> 对象.
    std::future<int> fut = prom.get_future(); // 和 future 关联.
    std::thread t(print_int, std::ref(fut)); // 将 future 交给另外一个线程t.
    prom.set_value(10); // 设置共享状态的值, 此处和线程t保持同步.
    t.join();
    return 0;
}
```

## 扩展 Promise/Future 模型

C++11中STL提供的std::future，没有提供注册回调的接口，导致其使用受限，通常只用来跨线程传值同步。

业界多种异步编程框架也支持了 Promise/Future 机制，如：

- [RPC-Cpp自行设计Promise/Future](https://github.com/trpc-group/trpc-cpp/blob/main/docs/zh/future_promise_guide.md)
- [Seastar源码阅读 future/promise链式调用的实现](https://bobhan1.github.io/post/seastar-future-promise/)
- [Tencent flare Promise/Future模型](https://github.com/Tencent/flare/blob/master/flare/doc/future.md)

