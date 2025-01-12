---
layout:     post
title:      "云原生 API 网关"
subtitle:   "云原生 API 网关"
date:       2025-01-12
author:     "vxiaozhi"
catalog: true
tags:
    - k8s
---

# 云原生 API 网关

市面上的云原生API网关大多基于 Nginx 和 Envoy

## Nginx

### blueking-apigateway

蓝鲸 API 网关（API Gateway），是一种高性能、高可用的 API 托管服务，可以帮助开发者创建、发布、维护、监控和保护 API， 以快速、低成本、低风险地对外开放蓝鲸应用或其他系统的数据或服务。

蓝鲸 API 网关分为控制面和数据面，控制面负责 API 的配置、发布、监控、权限管理等功能，数据面负责 API 的流量转发、安全防护等功能。其中数据面是基于 Apache APISIX 增加一系列插件以支持蓝鲸 API 网关的特性。得益于 Apache APISIX 动态、实时、高性能等特点，蓝鲸 API 网关能够支持高并发、低延迟的 API 托管服务。


蓝鲸 API 网关核心服务开源项目

- 蓝鲸 API 网关 - 控制面
  - dashboard：API 网关的控制面
  - dashboard-front: API 网关控制面前端
  - core-api: 网关高性能核心 API
  - esb: ESB 组件服务
- 蓝鲸 API 网关 - 数据面
- 蓝鲸 API 网关 - Operator

- [blueking-apigateway](https://github.com/TencentBlueKing/blueking-apigateway)

## Envoy

### 阿里 Higress

Higress 是一款云原生 API 网关，内核基于 Istio 和 Envoy，可以用 Go/Rust/JS 等编写 Wasm 插件，提供了数十个现成的通用插件，以及开箱即用的控制台

- [higress](https://github.com/alibaba/higress)
- [higress-console](https://github.com/higress-group/higress-console)
