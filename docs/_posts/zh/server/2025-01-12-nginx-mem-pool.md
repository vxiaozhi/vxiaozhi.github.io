---
layout:     post
title:      "Nginx 内存池机制"
subtitle:   "Nginx 内存池机制"
date:       2025-01-12
author:     "vxiaozhi"
catalog: true
tags:
    - server
    - nginx
---

# Nginx 内存池机制

nginx 的内存池设计得非常精妙，它在满足小块内存申请的同时，也处理大块内存的申请请求，同时还允许挂载自己的数据区域及对应的数据清楚操作。

nginx 内存池实现主要是在 core/ngx_palloc.{h,c}中，一些支持函数位于 os/unix/ngx_alloc.{h,c}中，支持函数主要是对原有的 malloc/free/memalign 等函数的封装。

nginx 内存池中有两个非常重要的结构，一个是 ngx_pool_s,主要是作为整个内存池的头部，管理内存池结点链表，大内存链表，cleanup 链表等，具体结构如下：

```
//该结构维护整个内存池的头部信息

struct ngx_pool_s {
ngx_pool_data_t d; //数据块
size_t max; //数据块大小，即小块内存的最大值
ngx_pool_t *current; //保存当前内存值
ngx_chain_t *chain; //可以挂一个chain结构
ngx_pool_large_t *large; //分配大块内存用，即超过max的内存请求
ngx_pool_cleanup_t *cleanup; //挂载一些内存池释放的时候，同时释放的资源
ngx_log_t *log;
};

```

另一重要的结构为 ngx_pool_data_s,这个是用来连接具体的内存池结点的，具体如下：

```
//大内存结构
struct ngx_pool_large_s {
ngx_pool_large_t *next; //下一个大块内存
void *alloc;//nginx分配的大块内存空间
};

struct ngx_pool_cleanup_s {
ngx_pool_cleanup_pt handler; //数据清理的函数句柄
void *data; //要清理的数据
ngx_pool_cleanup_t *next; //连接至下一个
};

```

## 特点

总结起来具有如下特点：

- 原理：内存池是在真正使用内存之前，预先申请分配一定数量的、大小相等(一般情况下)的内存块留作备用。当有新的内存需求时，就从内存池中分出一部分内存块，若内存块不够用时，再继续申请新的内存。
- 好处：减少向系统申请和释放内存的时间开销，解决内存频繁分配产生的碎片，提升程序性能。
- nginx为每一个层级都会创建一个内存池，进行内存的管理，比如一个模板，tcp连接，http请求等，在对应的生命周期结束的时候会摧毁整个内存池，把分配的内存一次性归还给操作系统。
- 在分配的内存上，nginx有小块内存和大块内存的概念，小块内存 nginx在分配的时候会尝试在当前的内存池节点中分配，而大块内存会调用系统函数malloc向操作系统申请
- 在释放内存的时候，nginx没有专门提供针对释放小块内存的函数，小块内存会在ngx_destory_pool 和 ngx_reset_pool的时候一并释放
- 针对大块内存，提供了单独的释放函数
- 大块内存与小块内存的界限是一页内存（p->max = (size < NGX_MAX_ALLOC_FROM_POOL) ? size : NGX_MAX_ALLOC_FROM_POOL
- NGX_MAX_ALLOC_FROM_POOL的值通过调用getpagesize()获得），大于一页的内存在物理上不一定是连续的，所以如果分配的内存大于一页的话，从内存池中使用，和向操作系统重新申请效率差不多是等价的


## 参考

- [初识nginx——内存池篇](https://www.cnblogs.com/magicsoar/p/6040238.html)
- [这是我见过最详细的 Nginx 内存池分析](https://xie.infoq.cn/article/7da75d942a40970e0538f734d)