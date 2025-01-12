---
layout:     post
title:      "K8s 跨集群通信"
subtitle:   "K8s 跨集群通信"
date:       2025-01-12
author:     "vxiaozhi"
catalog: true
tags:
    - k8s
---


# K8s 跨集群通信

分两种情况讨论：

**不同集群间Node互通**  

- 如公司内部多个集群 或者
- 同一个云服务商如腾讯云下的多个集群。

**不同集群间Node不互通** 

- 如公司内集群 和 腾讯公有云集群。
- 不同云服务商之间的集群，如腾讯云、阿里云。

## 方案

**不同集群间Node互通**

- vpc
- hostport
- random hostport

**不同集群间Node不互通**

- [submariner](https://github.com/submariner-io/submariner)
- [Skupper](https://github.com/skupperproject/skupper)
- [Kubeslice ](https://github.com/kubeslice/kubeslice)
- [Istio]()
- [Cilium 多集群 Cluster Mesh](https://github.com/cilium/cilium)


## 参考

- [Kubernetes 多集群通信的五种方案](https://www.cnblogs.com/cheyunhua/p/18227292)
- [Kubernetes 多集群网络解决方案 Submariner 中文入门指南](https://www.modb.pro/db/623405)
- [Istio多集群实践](https://cloud.tencent.com/developer/article/2378172)
- [基于istio实现多集群流量治理 ](https://www.cnblogs.com/huaweiyun/p/18127975)
- [Istio多集群流量管理](https://istio.io/latest/zh/docs/ops/configuration/traffic-management/multicluster/)
- [多集群 Istio 服务网格的跨集群无缝访问指南](https://jimmysong.io/blog/seamless-cross-cluster-access-istio/)
- [Multi-cluster traffic failover with EastWest Gateways](https://docs.tetrate.io/service-bridge/howto/gateway/multi-cluster-traffic-routing-with-eastwest-gateway)
- [Setting up Cluster Mesh](https://docs.cilium.io/en/stable/network/clustermesh/clustermesh/)
- [Cilium 多集群 Cluster Mesh 介绍](https://cloud.tencent.com/developer/article/2029179)
