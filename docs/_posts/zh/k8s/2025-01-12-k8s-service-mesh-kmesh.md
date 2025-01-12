---
layout:     post
title:      "Kmesh 技术"
subtitle:   "Kmesh 技术"
date:       2025-01-12
author:     "vxiaozhi"
catalog: true
tags:
    - k8s
---

# Kmesh 技术

## 背景

像 Istio 这样的服务网格已成为管理复杂微服务架构的核心，提供流量管理、安全性和可观测性等功能。Sidecar 模型，即在每个服务实例旁运行一个代理，已成为主要方法。虽然功能有效，但这种架构引入了显著的延迟和资源开销。

传统 Sidecar 架构的局限性

- 延迟开销：增加 Sidecar 代理会导致网络跳数和上下文切换增加，每次服务调用引入额外 2 至 3 毫秒 的延迟。对于对延迟敏感的应用，这种延迟是不可接受的。
- 资源消耗：每个 Sidecar 都会消耗 CPU 和内存资源。在拥有数千个服务的大规模部署中，累积的资源开销巨大，虽然可以通过一定的技术手段进行优化，但依然降低了部署密度并增加了运营成本。

Istio 的性能测量显示，即使没有流量分发，仍存在约 3 毫秒的固有延迟开销。随着连接数量的增长，延迟相应增加，这突显了 Sidecar 模型在高性能应用中的低效。

[kmesh](https://github.com/kmesh-net/kmesh)  通过将流量治理直接集成到操作系统内核，定义了一种新的服务网格数据平面。利用 eBPF（扩展伯克利数据包过滤器）和内核增强，Kmesh 提供高性能、低延迟和资源高效的服务网格能力。




## 参考

- [介绍 Kmesh：用内核原生技术革新服务网格数据平面](https://jimmysong.io/blog/introducing-kmesh-kernel-native-service-mesh/)
