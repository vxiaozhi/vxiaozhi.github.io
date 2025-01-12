---
layout:     post
title:      "C/C++ 实现的服务器和服务器相关的库"
subtitle:   "C/C++ 实现的服务器和服务器相关的库"
date:       2025-01-12
author:     "vxiaozhi"
catalog: true
tags:
    - server
    - cpp
---

# C/C++ 实现的服务器和服务器相关的库


## NGINX

## HAProxy

## Envoy

## Apache HTTP Server

## Apache Traffic Server

- [Apache Traffic Server](https://github.com/apache/trafficserver)

Apache Traffic Server™ 是一种高性能 Web 代理缓存，它通过在网络边缘缓存经常访问的信息来提高网络效率和性能。这使内容在物理上更接近最终用户，同时实现更快的交付并减少带宽使用。Traffic Server 旨在通过最大化现有和可用带宽来改善企业、互联网服务提供商 (ISP)、骨干提供商和大型 Intranet 的内容交付。

Apache Traffic Server（ATS或TS）是一个高性能的、模块化的HTTP代理和缓存服务器，与 Nginx 和 Squid 类似。Traffic Server最初是 Inktomi 公司的商业产品，该公司在2003 年被 Yahoo 收购， 2009 年 8月 Yahoo 向 Apache 软件基金会（ASF）贡献了源代码，并于 2010 年 4月成为了 ASF的顶级项目（Top-LevelProject）。 Apache TrafficServer 现在是一个开源项目，开发语言为C++。

## Squid

- [Squid Web Proxy Cache](https://github.com/squid-cache/squid)
- 注意： github上并没有提供代码的发行版本，直接编译会失败。需要到其[官网](https://www.squid-cache.org/Versions/v6/)下载代码编译。

Squid：是一个高性能的代理缓存服务器，Squid 支持 FTP、gopher、HTTPS 和 HTTP协议。和一般的代理缓存软件不同，Squid用一个单独的、非模块化的、I/O驱动的进程来处理所有的客户端请求，作为应用层的代理服务软件，Squid 主要提供缓存加速、应用层过滤控制的功能。

## lighttpd2

- [lighttpd2](https://github.com/lighttpd/lighttpd2)

## Boa

- [ Boa web server](https://github.com/gpg/boa)

## TinyWebServer

- [TinyWebServer -- Linux下C++轻量级WebServer服务器 助力初学者快速实践网络编程，搭建属于自己的服务器](https://github.com/qinguoyi/TinyWebServer)

## Proxygen

- [Proxygen: Facebook's C++ HTTP Libraries](https://github.com/facebook/proxygen)

Proxygen 是 Facebook 开发的一个 C++ 的 HTTP 库，包含一个易用的 HTTP 服务器。支持 HTTP/1.1、SPDY 3 和 SPDY 3.1，同时也开始在为 HTTP/2 做开发。

Proxygen 并非为了替换 Apache 或者 Nginx，该项目主要是侧重于用 C 语言构建超级灵活的 HTTP 服务器，提供非常好的性能和灵活的配置。此外也是为了构建一个高性能的 C++ HTTP 框架。

Proxygen是一个Facebook发布的C++ HTTP框架Proxygen， 其中包括了一个HTTP server。Proxygen是oxygen的谐音，支持SPDY/3和SPDY/3.1，未来还将支持HTTP/2。Facebook工程师 称，Proxygen不是设计替代流行的HTTP server Apache或nginx，而是致力于构建一个很容易整合到现有应用程序的高性能C++ HTTP框架，帮助更多人构建和部署高性能C++ HTTP服务。

## muduo

- [muduo -- Event-driven network library for multi-threaded Linux server in C++11](https://github.com/chenshuo/muduo)


## POCO

- [POCO (Portable Components) C++ Librarie](https://github.com/pocoproject/poco)

## Seastar

- [Seastar -- High performance server-side application framework](https://github.com/scylladb/seastar)

## 参考

- [小白视角：一文读懂社长的TinyWebServer](https://huixxi.github.io/2020/06/02/%E5%B0%8F%E7%99%BD%E8%A7%86%E8%A7%92%EF%BC%9A%E4%B8%80%E6%96%87%E8%AF%BB%E6%87%82%E7%A4%BE%E9%95%BF%E7%9A%84TinyWebServer/#more)

