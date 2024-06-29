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

### k8s中的网关

## 服务网格（Service Mesh）

服务网格是用于处理服务间通信的专用基础设施层。它负责通过包含现代云原生应用程序的复杂服务拓扑来可靠地传递请求。

实际上，服务网格通常通过一组轻量级网络代理来实现，这些代理与应用程序代码一起部署，而不需要感知应用程序本身。

如果用一句话来解释什么是服务网格，可以将它比作是应用程序或者说微服务间的 TCP/IP，负责服务之间的网络调用、限流、熔断和监控。对于编写应用程序来说一般无须关心 TCP/IP 这一层（比如通过 HTTP 协议的 RESTful 应用），同样使用服务网格也就无须关系服务之间的那些原来是通过应用程序或者其他框架实现的事情，比如 Spring Cloud、OSS，现在只要交给服务网格就可以了。

### 特点

- 应用程序间通讯的中间层
- 轻量级网络代理
- 应用程序无感知
- 解耦应用程序的重试 / 超时、监控、追踪和服务发现

### 实现了服务网格的软件由哪些

#### 1. Linkerd

#### 2. Istio 

Istio 是一个服务网格的开源实现。Istio 支持以下功能。

- 流量管理 利用配置，我们可以控制服务间的流量。设置断路器、超时或重试都可以通过简单的配置改变来完成。
- 可观测性 Istio 通过跟踪、监控和记录让我们更好地了解你的服务，它让我们能够快速发现和修复问题。
- 安全性 Istio 可以在代理层面上管理认证、授权和通信的加密。我们可以通过快速的配置变更在各个服务中执行政策。

** Istio 组件 **

Istio 服务网格有两个部分：数据平面和控制平面。

- 数据平面由 Envoy 代理组成，控制服务之间的通信。网格的控制平面部分负责管理和配置代理。
- 控制平面 Istiod 是控制平面组件，提供服务发现、配置和证书管理功能。Istiod 采用 YAML 编写的高级规则，并将其转换为 Envoy 的可操作配置。然后，它把这个配置传播给网格中的所有 sidecar。

**  Istio 缺点 **

- 无法做到完全对应用透明 服务通信和治理相关的功能迁移到 Sidecar 进程中后，应用中的 SDK 通常需要作出一些对应的改变。
- Istio 对非 Kubernetes 环境的支持有限
- 只有 HTTP 协议是一等公民
- Istio 在集群规模较大时的性能问题  Istio 默认的工作模式下，每个 Sidecar 都会收到全集群所有服务的信息。如果你部署过 Istio 官方的 Bookinfo 示例应用，并使用 Envoy 的 config dump 接口进行观察，你会发现，仅仅几个服务，Envoy 所收到的配置信息就有将近 20w 行。
- Isito 技术架构的成熟度还没有达到预期

## 配置

## 存储

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
