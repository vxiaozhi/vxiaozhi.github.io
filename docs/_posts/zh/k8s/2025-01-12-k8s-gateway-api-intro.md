---
layout:     post
title:      "Kubernetes Gateway API 简介"
subtitle:   "Kubernetes Gateway API 简介"
date:       2025-01-12
author:     "vxiaozhi"
catalog: true
tags:
    - k8s
---

# Kubernetes Gateway API 简介

## 背景

Kubernetes Gateway API 是 Kubernetes 1.18 版本引入的一种新的 API 规范，是 Kubernetes 官方正在开发的新的 API，Ingress 是 Kubernetes 已有的 API。Gateway API 会成为 Ingress 的下一代替代方案。Gateway API 提供更丰富的功能，支持 TCP、UDP、TLS 等，不仅仅是 HTTP。Ingress 主要面向 HTTP 流量。Gateway API 具有更强的扩展性，通过 CRD 可以轻易新增特定的 Gateway 类型，比如 AWS Gateway 等。Ingress 的扩展相对较难。Gateway API 支持更细粒度的流量路由规则，可以精确到服务级别。Ingress 的最小路由单元是路径。

Gateway API 的意义和价值：

- 作为 Kubernetes 官方项目，Gateway API 能够更好地与 Kubernetes 本身集成，有更强的可靠性和稳定性。
- 支持更丰富的流量协议，适用于服务网格等更复杂的场景，不仅限于 HTTP。可以作为 Kubernetes 的流量入口 API 进行统一。
- 具有更好的扩展性，通过 CRD 可以轻松地支持各种 Gateway 的自定义类型，更灵活。
- 可以实现细粒度的流量控制，精确到服务级别的路由，提供更强大的流量管理能力。

综上，Gateway API 作为新一代的 Kubernetes 入口 API，有更广泛的应用场景、更强大的功能、以及更好的可靠性和扩展性。对于生产级的 Kubernetes 环境，Gateway API 是一个更好的选择。本篇文章将深入解读 Kubernetes Gateway API 的概念、特性和用法，帮助读者深入理解并实际应用 Kubernetes Gateway API，发挥其在 Kubernetes 网络流量管理中的优势。


## 版本现状

Gateway API 目前还处于开发阶段，尚未发布正式版本。其版本发展现状如下：

- v1beta1: 当前的主要迭代版本，Gateway API 进入了 beta 版本，这意味着我们可以在生产中使用 Gateway API 能力了，目前 beta 版本仅支持 HTTP 协议，TCP 协议、UDP 协议、gRPC 协议、TLS 协议均为 alpha 版本。

- v1.0: 首个正式 GA 版本，API 稳定，可以用于生产环境。但功能还会持续完善。

## 可用场景

下面简单整理了一下 HTTPRoute 的一些可用场景：

- 多版本部署：如果您的应用程序有多个版本，您可以使用 HTTPRoute 来将流量路由到不同的版本，以便测试和逐步升级。例如，您可以将一部分流量路由到新版本进行测试，同时保持旧版本的运行。

- A/B 测试：HTTPRoute 可以通过权重分配来实现 A/B 测试。您可以将流量路由到不同的后端服务，并为每个服务指定一个权重，以便测试不同版本的功能和性能。

- 动态路由：HTTPRoute 支持基于路径、请求头、请求参数和请求体等条件的动态路由。这使得您可以根据请求的不同属性将流量路由到不同的后端服务，以满足不同的需求。

- 重定向：HTTPRoute 支持重定向，您可以将某些请求重定向到另一个 URL 上，例如将旧的 URL 重定向到新的 URL。


## 参考

- [Kubernetes Gateway API 深入解读和落地指南](https://cloudnative.to/blog/kubernetes-gateway-api-explained/)
- [Kubernetes Gateway API](https://github.com/kubernetes-sigs/gateway-api)
- [Kubernetes Gateway API 进入 Beta 阶段](https://kubernetes.io/zh-cn/blog/2022/07/13/gateway-api-graduates-to-beta/)
- [Migrating from Ingress](https://gateway-api.sigs.k8s.io/guides/migrating-from-ingress/#migrating-from-ingress)