---
layout:     post
title:      "c++20协程简介"
subtitle:   "c++20协程简介"
date:       2025-04-06
author:     "vxiaozhi"
catalog: true
tags:
    - cpp
    - coroutine
---

## c++20协程简介

参考：
- [协程及c++ 20原生协程研究报告](https://github.com/0voice/cpp_backend_awsome_blog/blob/main/%E3%80%90NO.241%E3%80%91%E5%8D%8F%E7%A8%8B%E5%8F%8Ac%2B%2B%2020%E5%8E%9F%E7%94%9F%E5%8D%8F%E7%A8%8B%E7%A0%94%E7%A9%B6%E6%8A%A5%E5%91%8A.md)
- [2021K+ 全球软件研发行业创新峰会 深入解析C++20协程](https://0cch.com/uploads/2022/02/k+2021.pdf)

C++20协程通过Promise和Awaitable接口的15个以上的函数来提供给程序员定制协程的流程和功能，实现最简单的协程需要用到其中的8个（5个Promise的函数和3个Awaitable的函数），
先来看Awaitable的3个函数。

如果要实现形如co_await blabla;的协程调用格式, blabla就必须实现Awaitable。co_await是一个新的运算符。Awaitable主要有3个函数：

- 1. await_ready：返回Awaitable实例是否已经ready。协程开始会调用此函数，如果返回true，表示你想得到的结果已经得到了，协程不需要执行了。所以大部分情况这个函数的实现是要return false。
- 2. await_suspend：挂起awaitable。该函数会传入一个coroutine_handle类型的参数。这是一个由编译器生成的变量。在此函数中调用handle.resume()，就可以恢复协程。
- 3. await_resume：当协程重新运行时，会调用该函数。这个函数的返回值就是co_await运算符的返回值。

函数的返回值需要满足Promise的规范。最简单的Promise如下：

```
struct Task
{
    struct promise_type {
        auto get_return_object() { return Task{}; }
        auto initial_suspend() { return std::experimental::suspend_never{}; }
        auto final_suspend() { return std::experimental::suspend_never{}; }
        void unhandled_exception() { std::terminate(); }
        void return_void() {}
    };
};
```

## 无栈协程原理

参考某知乎答主的回答：

可以从应用倒推原理：

1. 无栈协程可以只开一个，也可以开几十万个，说明有依赖动态内存分配，协程的局部变量是分配在堆空间的。
2. 无栈协程没有运行时栈，说明每个协程必须知道自己是协程。举例：当协程a引用一个局部变量local_v时，需编译为 (*a_frame).local_v，就是从协程a占有的堆内存中取出local_v。同一种协程的多个实例的堆内存互不相干。
3. 当协程a调用一个普通函数b时，函数b不知道caller a是不是协程，也只需遵循普通的函数调用方式，即在栈上开辟空间。在概念上，除非函数b结束并返回到协程a，否则协程a将永远没有机会暂停。
4. 当普通函数b调用一个协程c时，函数b也不需要知道c是不是协程。在C++20中，普通函数b只需调用c.resume()，就好像这是一个普通函数。
5. 延续第4点，当c.resume()返回后，协程c可能是结束了，也可能只是暂停了，这不重要。然后你希望调用d.resume() ，e.resume() 等等。实际上普通函数b扮演了一个调度者的角色，决定着哪个协程应该运行，此时可将普通函数b看作“调度器”。这种“协程暂停->回到调度器->另一个协程运行->……”的循环模式叫做“非对称协程”。另一种循环模式是“协程暂停->另一个协程运行”，也就是c.resume()结束后并没有返回普通函数b，而是直接运行了另一个协程，叫做“对称协程”。“对称协程”和“非对称协程”可以互相模拟，本质区别不大。

那么，如何用普通函数实现非对称协程？

1. 首先定义一个struct Frame“协程帧”负责存放协程的局部变量。这样，每当新建一个协程时，只需整体分配一次堆空间。显然，因为不同协程内具有不同的局部变量，你需要对每一种协程都定义一个Frame ，于是你的代码里有很多A_Frame,B_Frame,……你会觉得太麻烦了，这种机械工作为什么不让编译器做呢？幸运的是，C++20的编译器能够帮你准确无误地完成这些工作，真心建议题主放弃C++11。
2.  堆空间有了，那么怎样实现“可暂停”呢？简单！在每个暂停点直接return;就行。
3.  暂停点return后，怎么做到“可重入”？题主应该已经知道了，就是用 switch case 手动模拟即可。所以“协程帧”不仅仅要存放局部变量，还要存放 switch case 用到的值，代表着“协程的当前状态”。
4.  协程最终结束后，如何返回值？同样地，写入协程帧即可。如果caller需要用到返回值，就到协程帧那里找就是了。由此看来，协程结束后不能直接回收协程帧的内存，毕竟caller还要读呢！
5.  如果协程要抛出异常，怎么办？还·是·协·程·帧！！！我们强制每个协程内都被一个try-catch包裹，当异常发生时，将异常写入协程帧，然后当作无事发生。当且仅当caller来查询协程帧时，才会发现并重新抛出这个异常。现在，你拥有了一个可暂停、可重入、可并发几十万个的普通函数（和它的协程帧结构体），你称之为“协程”。因为每次暂停都是直接return;，回到上层调度器，所以是“非对称的”。但是，协程帧的内存申请和释放时机都需要你非常小心的控制。
   
理解了以上原理，再去阅读C++20协程的相关文档，应该会比较容易了。

## 基于C++20协程封装的库

c++20的协程功能是给库的开发者使用的，所以看起来比较复杂，但是经过库的作者封装以后用起来是非常简单，以下是一些开源库：

- [async_simple](https://github.com/alibaba/async_simple) async_simple是阿里巴巴开源的轻量级C++异步框架。提供了基于C++20无栈协程（Lazy），有栈协程（Uthread）以及Future/Promise等异步组件。
- [CppCoro - A coroutine library for C++](https://github.com/lewissbaker/cppcoro)
- [Felspar Coro](https://github.com/Felspar/coro) Coroutine library and toolkit for C++20
- [librf - 协程库](https://github.com/tearshark/librf) 基于C++ Coroutines编写的无栈协程库
- [concurrencpp, the C++ concurrency library](https://github.com/David-Haim/concurrencpp) Modern concurrency for C++. Tasks, executors, timers and C++20 coroutines to rule them all
- [Coro](https://github.com/adinosaur/Coro) 用c语言setjmp和longjmp实现的一个最基本的协程
- [UE5Coro](https://github.com/landelare/ue5coro) A deeply-integrated C++20 coroutine plugin for Unreal Engine 5.

基于C++20实现的server:

- [co-uring-webserver](https://github.com/yunwei37/co-uring-WebServer)  C++20 编写的 Web 服务器，可处理静态资源, 同时也包含了一些学习 c++20 与 io_uring 的相关资料