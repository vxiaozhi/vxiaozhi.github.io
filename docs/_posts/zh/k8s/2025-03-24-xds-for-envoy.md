---
layout:     post
title:      "Envoy XDS 介绍"
subtitle:   "Envoy XDS 介绍"
date:       2025-03-24
author:     "vxiaozhi"
catalog: true
tags:
    - k8s
    - envoy
---

# Envoy XDS 介绍

xDS（Extensible Discovery Service）是一种通信协议，用于在微服务架构中管理服务发现和动态配置。这种机制被广泛用于 Envoy 代理和 Istio 服务网格中，以管理各种类型的资源配置，如路由、服务发现、负载均衡设置等。

参考：

- [Envoy - xDS 实现动态配置](https://github.com/xujiyou/my-xds) 介绍了如何自己实现一个 xDS server，来为 Envoy 提供动态配置更新。
- [Envoy XDS 及 Istio 中的配置分发流程介绍](https://jimmysong.io/blog/istio-delta-xds-for-envoy/)

## XDS 具体实现

有哪些服务实现了 XDS 协议呢？

最典型的就是 Istio 的 Controller， [Istio Pilot-Discovery](https://github.com/istio/istio/tree/master/pilot/cmd)

该部分的代码解析可参考：[Istio Pilot代码深度解析](https://www.zhaohuabing.com/post/2019-10-21-pilot-discovery-code-analysis/)

### Istio Pilot-Discovery

Pilot-Discovery 是 Istio 的核心组件之一，它负责管理 Istio 的配置，包括服务发现、路由规则、负载均衡设置等。默认情况下，其只能从 K8s 中获取配置，为了能够扩展， Pilot 提出了 [MCP协议](https://docs.google.com/document/d/1o2-V4TLJ8fJACXdlsnxKxDv2Luryo48bAhR8ShxE5-k/edit?tab=t.0)

Higress 网关的 控制面 同时实现 包括了 XDS 和 MCP 两种协议的实现，参考其架构：

- [Higress 核心组件和原理](https://github.com/alibaba/higress/blob/main/docs/architecture.md)

