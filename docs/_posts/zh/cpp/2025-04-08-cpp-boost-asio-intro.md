---
layout:     post
title:      "Boost.Asio 简介"
subtitle:   "Boost.Asio 简介"
date:       2025-04-08
author:     "vxiaozhi"
catalog: true
tags:
    - cpp
---

## 简介

Boost.Asio是一个跨平台的、主要用于网络和其他一些底层输入/输出编程的C++库。

Boost.Asio中最核心的类——io_service。io_service是这个库里面最重要的类；它负责和操作系统打交道，等待所有异步操作的结束，然后为每一个异步操作调用其完成处理程序。

io_service:io_service是线程安全的。几个线程可以同时调用io_service::run()。大多数情况下你可能在一个单线程函数中调用io_service::run()，这个函数必须等待所有异步操作完成之后才能继续执行。然而，事实上你可以在多个线程中调用io_service::run()。这会阻塞所有调用io_service::run()的线程。只要当中任何一个线程调用了io_service::run()，所有的回调都会同时被调用；这也就意味着，当你在一个线程中调用io_service::run()时，所有的回调都被调用了。

但socket:socket类不是线程安全的。所以，你要避免在某个线程里读一个socket时，同时在另外一个线程里面对其进行写入操作。（通常来说这种操作都是不推荐的，更别说Boost.Asio）。

## 异步run(), runone(), poll(), poll one()

为了实现监听循环，io_service类提供了4个方法，比如：run(), run_one(), poll()和poll_one()。虽然大多数时候使用service.run()就可以，但是你还是需要在这里学习其他方法实现的功能。

- run()会一直执行，直到你手动调用io_service::stop()。
- run_one()方法最多执行和分发一个异步操作：如果没有等待的操作，方法立即返回0，如果有等待操作，方法在第一个操作执行之前处于阻塞状态，然后返回1
- poll_one()方法以非阻塞的方式最多运行一个准备好的等待操作：如果至少有一个等待的操作，而且准备好以非阻塞的方式运行，poll_one方法会运行它并且返回1; 否则，方法立即返回0
- poll()方法会以非阻塞的方式运行所有等待的操作。

## 基于 boost.asio 的应用

- [C++ Websocket header only ](https://github.com/zaphoyd/websocketpp)


## 参考

- [Boost.Asio C++ 网络编程](https://mmoaay.gitbooks.io/boost-asio-cpp-network-programming-chinese/content/)