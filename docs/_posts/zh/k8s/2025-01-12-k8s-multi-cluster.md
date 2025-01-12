---
layout:     post
title:      "K8s 多集群"
subtitle:   "K8s 多集群"
date:       2025-01-12
author:     "vxiaozhi"
catalog: true
tags:
    - k8s
---

# K8s 多集群

## 1. 为什么需要 K8s 多集群？

在探讨为什么需要 K8s 多集群之前，我们首先定义一下什么是 K8s 多集群：

所谓 K8s 多集群，顾名思义就是多个 K8s 集群。企业或组织可能根据自身的需求，例如为了满足隔离性、可用性、合规性或使用成本等，将其应用程序运行在任意一个或多个集群中。此外，在更加成熟的 K8s 多集群中，应用程序实际运行的集群能够动态配置，不同集群间的应用程序也应该支持相互访问。

## 方案

- Federation v1
- Federation v2
- Karmada 是由华为开源的多云容器编排项目，这个项目是 Kubernetes Federation v1 和 v2 的延续，一些基本概念继承自这两个版本。 

## 参考

- [理解 K8s 多集群（上）：构建成熟可扩展云平台的核心要素](https://www.lenshood.dev/2023/03/09/k8s-multi-cluster-1/)
- [理解 K8s 多集群（下）：解决方案对比与演进趋势](https://www.lenshood.dev/2023/03/26/k8s-multi-cluster-2/)
- [初探几种常用的 Kubernetes 多集群方案](https://www.51cto.com/article/713672.html)