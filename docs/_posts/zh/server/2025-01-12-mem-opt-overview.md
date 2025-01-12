---
layout:     post
title:      "内存优化综述"
subtitle:   "内存优化综述"
date:       2025-01-12
author:     "vxiaozhi"
catalog: true
tags:
    - server
---

# 内存优化综述

任何一个复杂的系统内存分配释放的最佳策略一定是： 按照其特性进行内存分类管理。 一般来说可将其特性分为以下几类：

- 对象池（Object Pools）
- 延迟销毁（Lazy Deletion）
- 动态生成（Dynamic Generation）

为什么说这种策略是最优的呢， 举例来说：

如果有大量相同大小的对象需要分配存储空间， 那么通过 空闲链 的算法（即预先创建一定数量的对象并存储在池中，通过两个双向链表快速分配和回收对象），这种方式一定比任何通用的内存分配算法要快。

如果内存特性具有层级特点，比如tcp连接，http请求等，那么采用内存池算法（层生命周期开始时，分配一个内存池，在对应的生命周期结束的时候会摧毁整个内存池，把分配的内存一次性归还给操作系统），这种方式也一定比其它任何通用的内存分配算法要快。


## 参考

- [Linux内存之Slab](https://fivezh.github.io/2017/06/25/Linux-slab-info/)
- [Linux 内核 | 内存管理——Slab 分配器](https://www.dingmos.com/index.php/archives/23/)
- [细节拉满，80 张图带你一步一步推演 slab 内存池的设计与实现 ](https://www.cnblogs.com/binlovetech/p/17288990.html)
- [Linux内存管理slub分配器 ](https://www.cnblogs.com/LoyenWang/p/11922887.html)
- [高性能内存分配库Libhaisqlmalloc的设计思路](https://zhuanlan.zhihu.com/p/352938740)