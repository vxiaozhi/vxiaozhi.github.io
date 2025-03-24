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
