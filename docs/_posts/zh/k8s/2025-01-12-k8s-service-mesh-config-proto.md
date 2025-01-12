---
layout:     post
title:      "K8s 服务网格配置发现协议"
subtitle:   "K8s 服务网格配置发现协议"
date:       2025-01-12
author:     "vxiaozhi"
catalog: true
tags:
    - k8s
---

# K8s 服务网格配置发现协议

## MCP

- MCP是基于订阅的配置分发API。
- 配置使用者(即sink)从配置生产者(即source)请求更新资源集合.添加,更新或删除资源时,source会将资源更新推送到sink.
- sink积极确认资源更新,如果sink接受,则返回ACK,如果被拒绝则返回NACK,例如: 因为资源无效。
- 一旦对先前的更新进行了ACK/NACK,则源可以推送其他更新.该源一次只能运行一个未完成的更新(每个集合).
- MCP是一对双向流gRPC API服务(ResourceSource和ResourceSink)。

## xDS

xDS REST和gRPC协议 Envoy通过文件系统或查询一台或多台管理服务器发现其各种动态资源。这些发现服务及其相应的API统称为xDS。通过预订,指定要监视的文件系统路径,启动gRPC流或轮询REST-JSON URL来请求资源。后两种方法涉及发送带有DiscoveryRequest 原型有效负载的请求.在所有方法中,资源都是通过DiscoveryResponse原型有效负载交付的 。我们在下面讨论每种订阅类型。

xDS API中的每个配置资源都有与之关联的类型。资源类型遵循 版本控制方案。资源类型的版本与下面描述的传输无关。

支持以下v3 xdS资源类型:

- envoy.config.listener.v3.Listener

- envoy.config.route.v3.RouteConfiguration

- envoy.config.route.v3.ScopedRouteConfiguration

- envoy.config.route.v3.VirtualHost

- envoy.config.cluster.v3.Cluster

- envoy.config.endpoint.v3.ClusterLoadAssignment

- envoy.extensions.transport_sockets.tls.v3.Secret

- envoy.service.runtime.v3.Runtime

## mcp-over-xds

## 参考

- [mcp protocol](https://github.com/istio/api/tree/master/mcp)
- [mcp](https://rocdu.gitbook.io/deep-understanding-of-istio/7/1)
- [mcp-over-xds](https://rocdu.gitbook.io/deep-understanding-of-istio/7/4)
- [Istio 与 Mcp Server 服务器讲解与搭建演示](https://xie.infoq.cn/article/d6fda55bca526128a5bce617f)
- [ XDS-OVER-MCP设计](https://docs.google.com/document/d/1lHjUzDY-4hxElWN7g6pz-_Ws7yIPt62tmX3iGs_uLyI/edit#heading=h.xw1gqgyqs5b)
- [Pilot MCP协议介绍](https://nacos.io/en-us/blog/pilot%20mcp.html)
- [【Service Mesh基础】Envoy-入门介绍与xDS协议](https://dun.163.com/news/p/eb1a80e497f14947b033f17b53e8869e)
- [xDS概述](https://skyao.io/learning-xds/docs/introduction/overview.html)
