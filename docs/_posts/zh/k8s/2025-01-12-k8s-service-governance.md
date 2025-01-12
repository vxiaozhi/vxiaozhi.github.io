---
layout:     post
title:      "K8s 服务治理"
subtitle:   "K8s 服务治理"
date:       2025-01-12
author:     "vxiaozhi"
catalog: true
tags:
    - k8s
---

# K8s 服务治理

微服务治理的手段

- [Apache Dubbo](https://github.com/apache/dubbo) 在早期的微服务框架中，很多用户会选择 Dubbo，国内成熟案例也很多。然而 Dubbo 自身的服务治理能力是很弱的，需要自行整合多种服务治理插件
- [Spring Cloud](https://github.com/spring-cloud) 尽管 Spring Cloud 全家桶功能多可以全套搞定，社区也活跃，文档也丰富，但是 Spring Cloud 最大的问题是 Java 语言绑定和业务侵入性强
- Istio 新型的服务网格代表 Istio 巧妙地解决了 Dubbo 和 Spring Cloud 的缺点问题，它通过 Sidecar 来进行流量的劫持代理，做到了无侵入和语言无关。但正是因为这种代理模式，导致了其流量性能损耗问题，同时也缺乏了内部 SDK 支持与精细化的方法级治理。
- [Polaris Mesh](https://github.com/polarismesh/polaris) 北极星是一个支持多语言和多框架的服务发现和治理平台，致力于解决分布式和微服务架构中的服务管理、流量管理、故障容错、配置管理和可观测性问题，针对不同的技术栈和环境提供服务治理的标准方案和最佳实践。

两者虽然都支持： 路由、熔断、重试 等服务治理手段， 但两者的实现原理完全不同。 区别在于：

Istio 相当于时网关/代理 模式。
Polaris 则是旁路模式。

## 参考

- [万字长文分享腾讯云原生微服务治理实践及企业落地建议](https://mp.weixin.qq.com/s/BCK8WdzUVtJjfqLbAFJLMg)
- [springcloud-learning Spring Cloud组件、微服务项目实战、Kubernetes容器化部署全方位解析](https://github.com/macrozheng/springcloud-learning)
