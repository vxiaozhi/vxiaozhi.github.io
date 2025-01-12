---
layout:     post
title:      "k8s 网络插件 Cilium"
subtitle:   "k8s 网络插件 Cilium"
date:       2025-01-12
author:     "vxiaozhi"
catalog: true
tags:
    - k8s
---

# k8s 网络插件 Cilium

## 简介

Cilium 是一个基于 eBPF 和 XDP 的高性能容器网络方案，代码开源在 https://github.com/cilium/cilium。其主要功能特性包括

安全上，支持 L3/L4/L7 安全策略，这些策略按照使用方法又可以分为

- 基于身份的安全策略（security identity）
- 基于 CIDR 的安全策略
- 基于标签的安全策略

网络上，支持三层平面网络（flat layer 3 network），如

- 覆盖网络（Overlay），包括 VXLAN 和 Geneve 等
- Linux 路由网络，包括原生的 Linux 路由和云服务商的高级网络路由等

提供基于 BPF 的负载均衡

提供便利的监控和排错能力

## eBPF 和 XDP

eBPF（extended Berkeley Packet Filter）起源于BPF，它提供了内核的数据包过滤机制。
BPF的基本思想是对用户提供两种SOCKET选项：SO_ATTACH_FILTER和SO_ATTACH_BPF，允许用户在sokcet上添加自定义的filter，只有满足该filter指定条件的数据包才会上发到用户空间。
SO_ATTACH_FILTER插入的是cBPF代码，SO_ATTACH_BPF插入的是eBPF代码。eBPF是对cBPF的增强，目前用户端的tcpdump等程序还是用的cBPF版本，其加载到内核中后会被内核自动的转变为eBPF。
Linux 3.15 开始引入 eBPF。其扩充了 BPF 的功能，丰富了指令集。它在内核提供了一个虚拟机，用户态将过滤规则以虚拟机指令的形式传递到内核，由内核根据这些指令来过滤网络数据包。


## 参考

- [网络插件 cilium](https://kubernetes.feisky.xyz/extension/network/cilium)
- [腾讯云 Cilium-Overlay 模式介绍](https://cloud.tencent.com/document/product/457/77964)
