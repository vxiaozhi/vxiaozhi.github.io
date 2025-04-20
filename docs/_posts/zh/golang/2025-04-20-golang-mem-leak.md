---
layout:     post
title:      "golang 内存泄露定位"
subtitle:   "golang 内存泄露定位"
date:       2025-04-20
author:     "vxiaozhi"
catalog: true
tags:
    - golang
    - 内存泄露
---

Golang 作为自带垃圾回收（Garbage Collection，GC）机制的语言，可以自动管理内存。但在实际开发中代码编写不当的话也会出现内存泄漏的情况。

内存泄漏并不是指物理上的内存消失，而是指程序在申请内存后，未能及时释放不再使用的内存空间，导致这部分内存无法被再次使用，随着时间的推移，程序占用的内存不断增长，最终导致系统资源耗尽或程序崩溃。；短期内的内存泄漏可能看不出什么影响，但是当时间长了之后，日积月累，浪费的内存越来越多，导致可用的内存空间减少，轻则影响程序性能，严重可导致正在运行的程序突然崩溃。

## 内存泄漏场景


常见的内存泄露场景，[go101](https://go101.org/article/memory-leaking.html) 进行了讨论，总结了如下几种：

- Kind of memory leaking caused by substrings
- Kind of memory leaking caused by subslices
- Kind of memory leaking caused by not resetting pointers in lost slice elements
- Real memory leaking caused by hanging goroutines
- real memory leadking caused by not stopping time.Ticker values which are not used any more
- Real memory leaking caused by using finalizers improperly
- Kind of resource leaking by deferring function calls

[详解 Golang 内存泄露](https://zhuanlan.zhihu.com/p/679290686) 这篇文章也详细分析了常见的几种 内存泄露场景， 包括：

- 全局变量
- 不恰当的内存池使用
- slice 引起的内存泄漏
- select阻塞
- channel阻塞
- goroutine导致的内存泄漏

简单归纳一下：

- 临时性泄露，指的是该释放的内存资源没有及时释放，对应的内存资源仍然有机会在更晚些时候被释放，即便如此在内存资源紧张情况下，也会是个问题。这类主要是string、slice底层buffer的错误共享，导致无用数据对象无法及时释放，或者defer函数导致的资源没有及时释放。
- 永久性泄露，指的是在进程后续生命周期内，泄露的内存都没有机会回收，如goroutine内部预期之外的for-loop或者chan select-case导致的无法退出的情况，导致协程栈及引用内存永久泄露问题。

## 内存泄露排查

### 借助pprof排查 

go提供了pprof工具方便对运行中的go程序进行采样分析，支持对多种类型的采样分析：

集成pprof非常简单，只需要在工程中引入如下代码即可：

```
import _ "net/http/pprof"

go func() {
	log.Println(http.ListenAndServe("localhost:6060", nil))
}()
```

打开：

```
http://localhost:6060/debug/pprof/
```