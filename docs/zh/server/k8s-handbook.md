# Kubernetes 中文指南

## 术语解释

- Istio: Istio 是由 Google、IBM 和 Lyft 开源的微服务管理、保护和监控框架. Istio 并不是首字母缩写，但如果一定要说它代表着什么，也许会是 “I Secure, Then I Observe”（我保护，我观察），或者 "I’m Sexy To Infrastructure Operators."（我对基础设施运营商富有吸引力）。

## k8s 与 云原生的关系

### 云原生定义

云原生是一种行为方式和设计理念，究其本质，凡是能够提高云上资源利用率和应用交付效率的行为或方式都是云原生的。

### k8s

Kubernetes 最初源于谷歌内部的 Borg，提供了面向应用的容器集群部署和管理系统。
Kubernetes 提供的能力包括：多层次的安全防护和准入机制、多租户应用支撑能力、透明的服务注册和服务发现机制、内建负载均衡器、故障发现和自我修复能力、服务滚动升级和在线扩容、可扩展的资源自动调度机制、多粒度的资源配额管理能力。
Kubernetes 还提供完善的管理工具，涵盖开发、部署测试、运维监控等各个环节。


## k8s 架构

- Master 节点
- Node 节点

### 核心基础组件

- Etcd 保存了整个集群的状态
- APIServer 供了资源操作的唯一入口，并提供认证、授权、访问控制、API 注册和发现等机制。
- ControllerManager 负责维护集群的状态，比如故障检测、自动扩展、滚动更新等。
- Scheduler 负责资源的调度，按照预定的调度策略将 Pod 调度到相应的机器上。
- Kubelet 负责维护容器的生命周期，同时也负责 Volume（CSI）和网络（CNI）的管理。
- ContainerRuntime 负责镜像管理以及 Pod 和容器的真正运行（CRI）。
- kubeProxy 负责为 Service 提供 cluster 内部的服务发现和负载均衡。

### 推荐插件【可选】

- CoreDNS 负责为整个集群提供 DNS 服务
- Ingress Controller 为服务提供外网入口
- Prometheus 提供资源监控
- Dashboard 提供 GUI
- Federation 提供跨可用区的集群


## 工作负载（workload）

## 服务、负载均衡和联网

外面服务访问进来，那么需要 支持负载均衡， 通过网关实现。
里面服务访问外面， 那么需要联网，通过 ？ 实现

## 配置

## 存储

## k8s中的网关
## 参考

- [The Kubernetes Book, 2021 Edition](https://github.com/rohitg00/DevOps_Books/blob/main/The%20Kubernetes%20Book%20(Nigel%20Poulton)%20(z-lib.org).pdf)
- [The Kubernetes Book, 2024 Edition](https://github.com/vxiaozhi/DevOps_Books/blob/main/The.Kubernetes.Book.2024.Edition.pdf)
- [Kubernetes 中文文档](https://kubernetes.io/zh-cn/docs/home/)
- [Kubernetes 中文指南/云原生应用架构实践手册](https://hezhiqiang.gitbook.io/kubernetes-handbook)
- [K8s 指南](https://kubernetes.feisky.xyz/)
- [Kubernetes Handbook （Kubernetes指南）](https://github.com/feiskyer/kubernetes-handbook)
- [Kubernetes 基础教程](https://jimmysong.io/book/kubernetes-handbook/)
- [kubernetes-handbook](https://github.com/rootsongjc/kubernetes-handbook)
- [etcd-问题-调优-监控](https://github.com/yangpeng14/DevOps/blob/master/kubernetes/etcd-%E9%97%AE%E9%A2%98-%E8%B0%83%E4%BC%98-%E7%9B%91%E6%8E%A7.md)
- [Istio](https://jimmysong.io/kubernetes-handbook/usecases/istio.html)
- [Envoy](https://jimmysong.io/kubernetes-handbook/usecases/envoy.html)
