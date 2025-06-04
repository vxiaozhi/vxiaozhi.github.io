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

## 概述

Boost.Asio是一个跨平台的、主要用于网络和其他一些底层输入/输出编程的C++库。

Asio，即「异步 IO」（Asynchronous Input/Output），本是一个 [独立的 C++ 网络程序库](http://think-async.com/Asio)，似乎并不为人所知，后来因为被 Boost 相中，才声名鹊起。

从设计上来看，Asio 相似且重度依赖于 Boost，与 thread、bind、smart pointers 等结合时，体验顺滑。从使用上来看，依然是重组合而轻继承，一贯的 C++ 标准库风格。

**Boost.Asio代码风格**

Asio为了可读性将部分较复杂的类的声明和实现分成了两个头文件，在声明的头文件末尾include负责实现的头文件。impl文件夹包含这些实现的头文件。另外，还有一个常见的关键词是detail，不同操作系统下的各种具体的代码会放在detail文件夹下。

例如： shceduler.hpp 包含： scheduler.ipp
```
...
#include <boost/asio/detail/pop_options.hpp>

#if defined(BOOST_ASIO_HEADER_ONLY)
# include <boost/asio/detail/impl/scheduler.ipp>
#endif // defined(BOOST_ASIO_HEADER_ONLY)

#endif // BOOST_ASIO_DETAIL_SCHEDULER_HPP

```

## 关键类

### io_context/io_service

Boost.Asio中最核心的类——io_service。io_service是这个库里面最重要的类；它负责和操作系统打交道，等待所有异步操作的结束，然后为每一个异步操作调用其完成处理程序。

每个 Asio 程序都至少有一个 `io_context` 对象，它代表了操作系统的 I/O 服务（`io_context` 在 Boost 1.66 之前一直叫 `io_service`），把你的程序和这些服务链接起来。

io_service 其实就是 io_context, 其存在只是为了向后兼容：

```
#if !defined(BOOST_ASIO_NO_DEPRECATED)
/// Typedef for backwards compatibility.
typedef io_context io_service;
#endif // !defined(BOOST_ASIO_NO_DEPRECATED)
```

io_service:io_service是线程安全的。几个线程可以同时调用io_service::run()。大多数情况下你可能在一个单线程函数中调用io_service::run()，这个函数必须等待所有异步操作完成之后才能继续执行。然而，事实上你可以在多个线程中调用io_service::run()。这会阻塞所有调用io_service::run()的线程。只要当中任何一个线程调用了io_service::run()，所有的回调都会同时被调用；这也就意味着，当你在一个线程中调用io_service::run()时，所有的回调都被调用了。


### Timer

有了 `io_context` 还不足以完成 I/O 操作，用户一般也不跟 `io_context` 直接交互。

根据 I/O 操作的不同，Asio 提供了不同的 I/O 对象，比如 timer（定时器），socket，等等。
Timer 是最简单的一种 I/O 对象，可以用来实现异步调用的超时机制，下面是最简单的用法：

```cpp
void Print(boost::system::error_code ec) {
  std::cout << "Hello, world!" << std::endl;
}

int main() {
  boost::asio::io_context ioc;
  boost::asio::steady_timer timer(ioc, std::chrono::seconds(3));
  timer.async_wait(&Print);
  ioc.run();
  return 0;
}
```

### Socket

Socket 也是一种 I/O 对象，这一点前面已经提及。相比于 timer，socket 更为常用，毕竟 Asio 是一个网络程序库。

但socket:socket类不是线程安全的。所以，你要避免在某个线程里读一个socket时，同时在另外一个线程里面对其进行写入操作。（通常来说这种操作都是不推荐的，更别说Boost.Asio）。

## 异步run(), runone(), poll(), poll one()

为了实现监听循环，io_service类提供了4个方法，比如：run(), run_one(), poll()和poll_one()。虽然大多数时候使用service.run()就可以，但是你还是需要在这里学习其他方法实现的功能。

- run()会一直执行，直到你手动调用io_service::stop()。
- run_one()方法最多执行和分发一个异步操作：如果没有等待的操作，方法立即返回0，如果有等待操作，方法在第一个操作执行之前处于阻塞状态，然后返回1
- poll_one()方法以非阻塞的方式最多运行一个准备好的等待操作：如果至少有一个等待的操作，而且准备好以非阻塞的方式运行，poll_one方法会运行它并且返回1; 否则，方法立即返回0
- poll()方法会以非阻塞的方式运行所有等待的操作。

## 多线程

有两种思路：

### 思路 1：每个线程一个 I/O Context[

在多线程的场景下，每个线程都持有一个 io_context ，并且每个线程都调用各自的 io_context 的run()方法。

特点：

- 在多核的机器上，这种方案可以充分利用多个 CPU 核心。
- 某个 socket 描述符并不会在多个线程之间共享，所以不需要引入同步机制。
- 在 event handler 中不能执行阻塞的操作，否则将会阻塞掉 io_context 所在的线程。
  
### 思路 2：多个线程共享一个 I/O  Context

全局只分配一个io_context ，并且让这个 io_context 在多个线程之间共享，每个线程都调用全局的 io_context 的run()方法。

先分配一个全局 io_context，然后开启多个线程，每个线程都调用这个 io_context的run()方法。这样，当某个异步事件完成时，io_context 就会将相应的 event handler 交给任意一个线程去执行。

然而这种方案在实际使用中，需要注意一些问题：

- 在 event handler 中允许执行阻塞的操作 (例如数据库查询操作)。
- 线程数可以大于 CPU 核心数，譬如说，如果需要在 event handler 中执行阻塞的操作，为了提高程序的响应速度，这时就需要提高线程的数目。
- 由于多个线程同时运行事件循环(event loop)，所以会导致一个问题：即一个 socket 描述符可能会在多个线程之间共享，容易出现竞态条件 (race condition)。譬如说，如果某个 socket 的可读事件很快发生了两次，那么就会出现两个线程同时读同一个 socket 的问题 (可以使用strand解决这个问题)。
- 无锁的同步方式：Asio 提供了 io_context::strand：如果多个 event handler 通过同一个 strand 对象分发 (dispatch)，那么这些 event handler 就会保证顺序地执行。

## 基于 boost.asio 的应用

- [C++ Websocket header only ](https://github.com/zaphoyd/websocketpp)


## 参考

- [Boost.Asio C++ 网络编程](https://mmoaay.gitbooks.io/boost-asio-cpp-network-programming-chinese/content/)
