---
layout:     post
title:      "kubernetes 网络模型"
subtitle:   "kubernetes 网络模型"
date:       2025-01-12
author:     "vxiaozhi"
catalog: true
tags:
    - k8s
---

# kubernetes 网络模型

## K8s通信原理

这是一张由外向内的典型的容器网络架构图。

![](https://wmxiaozhi.github.io/picx-images-hosting/picx-imgs/k8s-net/k8s-network-arch.png)


为了能够正常通信，图中每个参与通信的实体都需要有一个 IP 地址，由集群外部到集群内部：

| IP类型                | 说明                                    |
| ------------------- | ------------------------------------- |
| Proxy-IP            | 代理层公网地址IP，外部访问应用的网关服务器。[实际需要关注的IP]    |
| Service-IP          | Service的固定虚拟IP，Service-IP是内部，外部无法寻址到。 |
| Node-IP             | 容器宿主机的主机IP。                           |
| Container-Bridge-IP | 容器网桥（docker0）IP，容器的网络都需要通过容器网桥转发。     |
| Pod-IP              | Pod的IP，等效于Pod中网络容器的Container-IP。      |
| Container-IP        | 容器的IP，容器的网络是个隔离的网络空间。                 |

### 容器间通信

先来看最简单的情况， 即同一个Pod内部容器之间的通信：

- 在 Linux 中，每个正在运行的进程都在一个网络命名空间内进行通信，该命名空间为逻辑网络堆栈提供了自己的路由、防火墙规则和网络设备。
- 默认情况下，Linux 将每个进程分配给根网络命名空间以提供对外部世界的访问
- 就 Docker 结构而言，Pod 被建模为一组共享网络命名空间的 Docker 容器。
- Pod 中的容器都具有相同的 IP 地址和端口空间，这些 IP 地址和端口空间是通过分配给 Pod 的网络命名空间分配的，并且可以通过 localhost 找到彼此
- 通过 Docker 的 –net=container: 

![](https://wmxiaozhi.github.io/picx-images-hosting/picx-imgs/k8s-net/pod-namespace.png)



**【实验】**
参考 [Container-to-Container-Networking](https://github.com/vxiaozhi/k8s-experiment-code/tree/main/network/Container-to-Container-Networking)


### Pod 间通信

#### 同节点Pod通信

- 给定将每个 Pod 与自己的网络堆栈隔离的网络命名空间
- 将每个命名空间连接到根命名空间的虚拟以太网设备以及将命名空间连接在一起的网桥

如下图：

![](https://wmxiaozhi.github.io/picx-images-hosting/picx-imgs/k8s-net/pod-to-pod-same-node.gif)

在图 6 中，

- Pod 1 将数据包发送到它自己的以太网设备 eth0，该设备可用作 Pod 的默认设备。
- 对于 Pod 1，eth0 通过虚拟以太网设备连接到根命名空间 veth0 (1)。
- 网桥 cbr0 配置有 veth0 连接到它的网段。一旦数据包到达网桥，网桥会解析正确的网段以使用 ARP 协议将数据包发送到 veth1 (3)。
- 当数据包到达虚拟设备 veth1 时，它被直接转发到 Pod 2 的命名空间和该命名空间内的 eth0 设备 (4)。
- 在整个流量流中，每个 Pod 仅与 localhost 上的 eth0 通信，并且流量被路由到正确的 Pod。
- 使用网络的开发体验是开发人员所期望的默认行为。


【注：】 Pod1 和 Pod2 为什么要通过一对 Veth 连接到cbr0，而不是直接连接到 cbr0呢？

个人理解， Pod1 Pod2 和主机网络（根网络）属于不同子网， 不能直接连接到网桥上，因为网桥属于2层转发设备。所以这里需要借助 Veth 进行连接。

#### 跨节点Pod通信

我们现在转向不同节点上的 Pod .

- 集群中的每个节点都分配有一个 CIDR 块，指定该节点上运行的 Pod 可用的 IP 地址。
- 一旦流向 CIDR 块的流量到达节点，节点就有责任将流量转发到正确的 Pod。

下图说明了两个节点之间的流量流，假设网络可以将 CIDR 块中的流量路由到正确的节点。


![](https://wmxiaozhi.github.io/picx-images-hosting/picx-imgs/k8s-net/pod-to-pod-different-nodes.gif)


- 目标 Pod（以绿色突出显示）与源 Pod（以蓝色突出显示）位于不同的节点上。
- 数据包首先通过 Pod 1 的以太网设备发送，该设备与根命名空间 (1) 中的虚拟以太网设备配对。最终，数据包最终到达根命名空间的网桥 (2)。
- ARP 将在网桥上失败，因为没有设备连接到网桥并具有正确的数据包 MAC 地址。失败时，网桥将数据包发送到默认路由——根命名空间的 eth0 设备。此时路由离开节点并进入网络 (3)。
- 我们现在假设网络可以根据分配给节点的 CIDR 块将数据包路由到正确的节点 (4)。数据包进入目标节点的根命名空间（VM 2 上的 eth0），在那里它通过网桥路由到正确的虚拟以太网设备 (5)。
- 最后，路由通过位于 Pod 4 的命名空间 (6) 中的虚拟以太网设备对来完成。
- 一般来说，每个节点都知道如何将数据包传递给在其中运行的 Pod。一旦数据包到达目标节点，数据包的流动方式与在同一节点上的 Pod 之间路由流量的方式相同。

这里存在的问题：
1、让集群中的不同节点主机创建的 Pod 都具有全集群唯一的虚拟IP地址
2、Pod怎么跨越节点将数据发送到另外的Pod。 当然一种办法是： 数据从节点发出去之前，进行SNAT（即将容器ip转换为Node IP），但是这样就违背了上面的基础原则（即Pod IP内外一致）。

##### CNI 网络插件

- [flannel](https://github.com/flannel-io/flannel)
- [calico](https://github.com/projectcalico/calico)
- [amazon-vpc-cni-k8s](https://github.com/aws/amazon-vpc-cni-k8s)
- [阿里云 Terway CNI Network Plugin](https://github.com/AliyunContainerService/terway)
- contiv
- weave net
- kube-router
- [cilium](https://github.com/cilium/cilium)
- canal

##### flannel

**What**

-  CoreOS 公司主推的容器网络方案
-  原理其实相当于在原来的网络上加了一层 Overlay 网络，该网络中的结点可以看作通过虚拟或逻辑链路而连接起来的
-  Flannel 会在每一个宿主机上运行名为 flanneld 代理，其负责为宿主机预先分配一个Subnet 子网，并为 Pod 分配ip地址。
-  Flannel 使用 Kubernetes 或 etcd 来存储网络配置、分配的子网和主机公共 ip 等信息
-  数据包则通过 VXLAN、UDP 或 host-gw 这些类型的后端机制进行转发。

flannel 解决了如下两个问题：

1. 规划ip地址即路由： 保存在etcd
2. 实现 overlay 网络

其中 2 可以通过不同的backend 来实现：

- UDP  基于Linux TUN/TAP， 主要是利用 tun 设备来模拟一个虚拟网络进行通信， 使用UDP封装IP包来创建overlay网络 【性能较低，已废弃】
- VXLAN 利用 vxlan 实现一个三层的覆盖网络，利用 flannel1 这个 vtep 设备来进行封拆包，然后进行路由转发实现通信。 vxlan，这个是在内核实现的，如果用 UDP 封装就是在用户态实现的，用户态实现的等于把包从内核过了两遍，没有直接用 vxlan 封装的直接走内核效率高，所以基本上不会使用 UDP 封装。
- host-gw 直接改变二层网络的路由信息，实现数据包的转发，从而省去中间层，通信效率更高. 但要求各个节点之间是二层连通的。
- TencentCloud VPC: 通过弹性公网 IP 和 NAT 网关等，实现 VPC 内的云服务器连接公网。通过对等连接和云联网，实现不同 VPC 间的通信。通过 VPN 连接、专线接入和云联网，实现 VPC 与本地数据中心的互联。[VPC-CNI 模式介绍
](https://www.tencentcloud.com/zh/document/product/457/38970) [cni-bridge-networking](https://github.com/TencentCloud/cni-bridge-networking)


**总结**

为了解决 跨节点间Pod的通信， 引入了 CNI 网络插件。 来进行 IP地址、路由的分配，以及通过主流 vxlan 技术来实现overlay网络。


### Pod 与 Service 之间通信

**Why？**

- Pod IP 地址不是持久的，并且会随着扩展或缩减、应用程序崩溃或节点重启而出现和消失。这些事件中的每一个都可以使 Pod IP 地址在没有警告的情况下更改。Service被内置到 Kubernetes 中来解决这个问题。

**What**

- Kubernetes Service 管理一组 Pod 的状态，允许您跟踪一组随时间动态变化的 Pod IP 地址。
- Service充当对 Pod 的抽象，并将单个虚拟 IP 地址分配给一组 Pod IP 地址。
- 任何发往 Service 虚拟 IP 的流量都将被转发到与虚拟 IP 关联的 Pod 集。
- 这允许与 Service 关联的 Pod 集随时更改——客户端只需要知道 Service 的虚拟 IP即可，它不会更改。
- 在集群中的任何地方，发往虚拟 IP 的流量都将负载均衡到与服务关联的一组支持 Pod。

**How - 三种模式**

- userspace、 userspace模式是通过用户态程序实现转发，因性能问题基本被弃用
- iptables、 默认模式，可以通过修改kube-system命名空间下名称为kube-proxy的configMap资源的mode字段来选择kube-proxy的模式
- ipvs

netfilter 和 iptables

- Netfilter 是 Linux 提供的一个框架，它允许以自定义处理程序的形式实现各种与网络相关的操作。
- Netfilter 为数据包过滤、网络地址转换和端口转换提供了各种功能和操作，它们提供了引导数据包通过网络所需的功能，以及提供禁止数据包到达计算机网络中敏感位置的能力。
- iptables 是一个用户空间程序，它提供了一个基于表的系统，用于定义使用 netfilter 框架操作和转换数据包的规则。
- 在 Kubernetes 中，iptables 规则由 kube-proxy 控制器配置，该控制器监视 Kubernetes API 服务器的更改。
- 当对 Service 或 Pod 的更改更新 Service 的虚拟 IP 地址或 Pod 的 IP 地址时，iptables 规则会更新以正确地将指向 Service 的流量转发到正确的Pod。
- iptables 规则监视发往 Service 的虚拟 IP 的流量，并且在匹配时，从可用 Pod 集中选择一个随机 Pod IP 地址，并且 iptables 规则将数据包的目标 IP 地址从 Service 的虚拟 IP 更改为选定的 Pod。
- 当 Pod 启动或关闭时，iptables 规则集会更新以反映集群不断变化的状态。换句话说，iptables 已经在机器上进行了负载平衡，以将定向到服务 IP 的流量转移到实际 pod 的 IP。
- 在返回路径上，IP 地址来自目标 Pod。在这种情况下，iptables 再次重写 IP 标头以将 Pod IP 替换为 Service 的 IP，以便 Pod 认为它一直只与 Service 的 IP 通信。

IPVS

- Kubernetes 的最新版本 (1.11) 包括用于集群内负载平衡的第二个选项：IPVS。
- IPVS（IP 虚拟服务器）也构建在 netfilter 之上，并将传输层负载平衡作为 Linux 内核的一部分实现。IPVS 被合并到 LVS（Linux虚拟服务器）中，它在主机上运行并充当真实服务器集群前面的负载平衡器。
- IPVS 可以将基于 TCP 和 UDP 的服务的请求定向到真实服务器，并使真实服务器的服务在单个 IP 地址上表现为虚拟服务。这使得 IPVS 非常适合 Kubernetes 服务。
- IPVS 专为负载平衡而设计，并使用更高效的数据结构（哈希表），与 iptables 相比允许几乎无限的规模。
- 在使用 IPVS 创建负载均衡的 Service 时，会发生三件事：在 Node 上创建一个虚拟 IPVS 接口，将 Service 的 IP 地址绑定到虚拟 IPVS 接口，并为每个 Service IP 地址创建 IPVS 服务器。

Pod和Service通信

![](https://wmxiaozhi.github.io/picx-images-hosting/picx-imgs/k8s-net/pod-to-service.gif)

- 数据包首先通过连接到 Pod 的网络命名空间 (1) 的 eth0 接口离开 Pod。
- 然后它通过虚拟以太网设备到达网桥 (2)。网桥上运行的 ARP 协议不知道 Service，因此它通过默认路由 eth0 (3) 将数据包传输出去。在这里，发生了一些不同的事情。在 eth0 接受之前，数据包会通过 iptables 过滤。
- iptables 收到数据包后，使用 kube-proxy 安装在 Node 上的规则响应 Service 或 Pod 事件，将数据包的目的地从 Service IP 重写为特定的 Pod IP（4）。
- 数据包现在注定要到达 Pod 4，而不是服务的虚拟 IP。
- iptables 利用 Linux 内核的 conntrack 实用程序来记住所做的 Pod 选择，以便将来的流量路由到同一个 Pod（除非发生任何扩展事件）。
- 本质上，iptables 直接在 Node 上做了集群内负载均衡。然后流量使用我们已经检查过的 Pod 到 Pod 路由流向 Pod (5)。

Service和Pod通信

![](https://wmxiaozhi.github.io/picx-images-hosting/picx-imgs/k8s-net/service-to-pod.gif)

- 收到此数据包的 Pod 将响应，将源 IP 识别为自己的 IP，将目标 IP 识别为最初发送数据包的 Pod (1)。
- 进入节点后，数据包流经 iptables，它使用 conntrack 记住它之前所做的选择，并将数据包的源重写为服务的 IP 而不是 Pod 的 IP (2)。
- 从这里开始，数据包通过网桥流向与 Pod 的命名空间配对的虚拟以太网设备 (3)，然后流向我们之前看到的 Pod 的以太网设备 (4)。


### Service 与 Internet 之间通信

#### 1. 出流量[Egress]


一般来说，企业作为提供服务的一方，业务中会比较少使用出流量。

原理

- 每个节点都分配有一个私有 IP 地址，该地址可从 Kubernetes 集群内访问。
- 要从集群外部访问流量，您需要将 Internet 网关连接到您的 VPC。
- Internet 网关有两个用途：在您的 VPC 路由表中为可路由到 Internet 的流量提供目标，以及为已分配公共 IP 地址的任何实例执行网络地址转换 (NAT)。
- NAT 转换负责将集群专用的节点内部 IP 地址更改为公共 Internet 中可用的外部 IP 地址。
- Pod 有自己的 IP 地址，与托管 Pod 的节点的 IP 地址不同，并且 Internet 网关的 NAT 转换仅适用于 VM IP 地址，因为它不知道 Pod 正在运行什么哪些虚拟机——网关不支持容器。

流程

![](https://wmxiaozhi.github.io/picx-images-hosting/picx-imgs/k8s-net/pod-to-internet.gif)


- 数据包源自 Pod 的命名空间 (1)，并经过连接到根命名空间 (2) 的 veth 对。
- 一旦进入根命名空间，数据包就会从网桥移动到默认设备，因为数据包上的 IP 与连接到网桥的任何网段都不匹配。
- 在到达根命名空间的以太网设备 (3) 之前，iptables 会破坏数据包 (3)。
- 在这种情况下，数据包的源 IP 地址是 Pod，如果我们将源保留为 Pod，Internet 网关将拒绝它，因为网关 NAT 只了解连接到 VM 的 IP 地址。解决方案是让 iptables 执行源 NAT——更改数据包源——使数据包看起来来自 VM 而不是 Pod。
- 有了正确的源 IP，数据包现在可以离开 VM (4) 并到达 Internet 网关 (5)。
- Internet 网关将执行另一个 NAT，将源 IP 从 VM 内部 IP 重写为外部 IP。最后，数据包将到达公共 Internet (6)。
- 在返回的路上，数据包遵循相同的路径，并且任何源 IP 修改都被撤消，以便系统的每一层都接收到它理解的 IP 地址：节点或 VM 级别的 VM 内部，以及 Pod 内的 Pod IP命名空间。



#### 2. 入流量[Ingress]

##### 四层

原理

- 当你创建一个 Kubernetes 服务时，你可以选择指定一个 LoadBalancer 来配合它。
- LoadBalancer 的实现由知道如何为您的服务创建负载均衡器的云控制器提供。创建服务后，它将公布负载均衡器的 IP 地址。作为最终用户，您可以开始将流量引导到负载均衡器以开始与您的服务通信。
- 负载均衡器可以了解其目标组中的节点，并将平衡集群中所有节点的流量。一旦流量到达一个节点，之前为您的服务在整个集群中安装的 iptables 规则将确保流量到达您感兴趣的服务的 Pod。

通信过程

![](https://wmxiaozhi.github.io/picx-images-hosting/picx-imgs/k8s-net/internet-to-service.gif)

- 部署服务后，您正在使用的云提供商将为您创建一个新的负载均衡器 (1)。因为负载均衡器不支持容器，所以一旦流量到达负载均衡器，它就会分布在组成集群的所有虚拟机中 (2)。
- 每个 VM 上的 iptables 规则会将来自负载均衡器的传入流量引导到正确的 Pod (3) — 这些是在服务创建期间实施并在前面讨论过的相同 IP 表规则。
- Pod 到客户端的响应将返回 Pod 的 IP，但客户端需要有负载均衡器的 IP 地址。正如我们之前看到的，iptables 和 conntrack 用于在返回路径上正确重写 IP。

VM 不存在pod时的流程：

下图显示了托管 Pod 的三个 VM 前面的网络负载均衡器。传入流量 (1) 指向您的服务的负载均衡器。一旦负载均衡器收到数据包 (2)，它就会随机选择一个 VM。在这种情况下，我们病态地选择了没有运行 Pod 的 VM：VM 2 (3)。在这里，运行在 VM 上的 iptables 规则将使用 kube-proxy 安装到集群中的内部负载平衡规则将数据包定向到正确的 Pod。iptables 执行正确的 NAT 并将数据包转发到正确的 Pod (4)。

##### 七层

七层转发-Ingress Controller 原理

- 7 层网络 Ingress 在网络协议栈的 HTTP/HTTPS 协议范围内运行，并构建在 Services 之上。
- 启用 Ingress 的第一步是使用 Kubernetes 中的 NodePort 服务类型在您的服务上打开一个端口。如果将 Service 的 type 字段设置为 NodePort，Kubernetes master 将从您指定的范围内分配一个端口，并且每个 Node 都会将该端口（每个 Node 上的相同端口号）代理到您的 Service 中。也就是说，任何指向节点端口的流量都将使用 iptables 规则转发到服务。这个 Service 到 Pod 的路由遵循我们在将流量从 Service 路由到 Pod 时已经讨论过的相同的内部集群负载平衡模式。
- 要向 Internet 公开节点的端口，您需要使用 Ingress 对象。Ingress 是一个更高级别的 HTTP 负载均衡器，它将 HTTP 请求映射到 Kubernetes 服务。Ingress 方法将根据 Kubernetes 云提供商控制器的实现方式而有所不同。HTTP 负载均衡器，如第 4 层网络负载均衡器，仅了解节点 IP（而不是 Pod IP），因此流量路由同样利用由 kube-proxy 安装在每个节点上的 iptables 规则提供的内部负载均衡。


在 AWS 环境中，ALB 入口控制器使用 Amazon 的第 7 层应用程序负载均衡器提供 Kubernetes 入口。下图详细介绍了此控制器创建的 AWS 组件。它还演示了 Ingress 流量从 ALB 到 Kubernetes 集群的路由。

![](https://wmxiaozhi.github.io/picx-images-hosting/picx-imgs/k8s-net/ingress-controller-design.png)



Ingress和Service通信 流程

- 流经 Ingress 的数据包的生命周期与 LoadBalancer 的生命周期非常相似。主要区别在于 Ingress 知道 URL 的路径（允许并可以根据路径将流量路由到服务），并且 Ingress 和 Node 之间的初始连接是通过 Node 上为每个服务公开的端口。
- 部署服务后，您正在使用的云提供商将为您创建一个新的 Ingress 负载均衡器 (1)。由于负载均衡器不支持容器，因此一旦流量到达负载均衡器，它就会通过为您的服务提供的广告端口分布在组成集群 (2) 的整个 VM 中。
- 每个 VM 上的 iptables 规则会将来自负载均衡器的传入流量引导到正确的 Pod (3) — 正如我们之前所见。Pod 到客户端的响应将返回 Pod 的 IP，但客户端需要有负载均衡器的 IP 地址。正如我们之前看到的，iptables 和 conntrack 用于在返回路径上正确重写 IP。
- 第 7 层负载均衡器的一个好处是它们可以识别 HTTP，因此它们知道 URL 和路径。这使您可以按 URL 路径对服务流量进行分段。它们通常还在 HTTP 请求的 X-Forwarded-For 标头中提供原始客户端的 IP 地址。

![](https://wmxiaozhi.github.io/picx-images-hosting/picx-imgs/k8s-net/ingress-to-service.gif)




## 参考

- [The Kubernetes Book, 2021 Edition](https://github.com/rohitg00/DevOps_Books/blob/main/The%20Kubernetes%20Book%20(Nigel%20Poulton)%20(z-lib.org).pdf)
- [The Kubernetes Book, 2024 Edition](https://github.com/vxiaozhi/DevOps_Books/blob/main/The.Kubernetes.Book.2024.Edition.pdf)
- [Kubernetes 中文文档](https://kubernetes.io/zh-cn/docs/home/)
- [Docker的网络基础](https://github.com/huweihuang/kubernetes-notes/blob/master/network/docker-network.md)
- [A Guide to the Kubernetes Networking Model](https://sookocheff.com/post/kubernetes/understanding-kubernetes-networking-model/)
- [kubernetes网络模型](https://github.com/huweihuang/kubernetes-notes/blob/master/network/kubernetes-network.md)
- [Kubernetes网络模型](https://kuboard.cn/learning/k8s-intermediate/service/network.html#kubernetes%E5%9F%BA%E6%9C%AC%E6%A6%82%E5%BF%B5)
- [万字长文，带你搞懂 Kubernetes 网络模型](https://www.51cto.com/article/714336.html)
- [揭秘 IPIP 隧道](https://morven.life/posts/networking-3-ipip/)
- [Infra container 容器](https://jimmysong.io/book/kubernetes-handbook/objects/pause-container/)
- [k8s那些事之万法之源Pod](https://github.com/chenzongshu/Kubernetes/blob/master/k8s%E9%82%A3%E4%BA%9B%E4%BA%8B%E5%84%BF/k8s%E9%82%A3%E4%BA%9B%E4%BA%8B%E4%B9%8B%E4%B8%87%E6%B3%95%E4%B9%8B%E6%BA%90Pod.md)
- [k8s那些事之容器网络](https://github.com/chenzongshu/Kubernetes/blob/master/k8s%E9%82%A3%E4%BA%9B%E4%BA%8B%E5%84%BF/k8s%E9%82%A3%E4%BA%9B%E4%BA%8B%E4%B9%8B%E5%AE%B9%E5%99%A8%E7%BD%91%E7%BB%9C.md)

**分享**

- [k8s 主流网络方案（OVS、Flannel、Calico）及原理](https://www.youtube.com/watch?v=cyKUaT0SEtU)
- [技术分享：Kubernetes Networking Model （赵锟）](https://www.youtube.com/watch?v=HxS4s11rmyA)
- [深入理解Kubernetes网络](https://www.bilibili.com/video/BV1Ft4y117Ch/?spm_id_from=333.337.search-card.all.click&vd_source=a9df3242be9eb413a269ab45ec32652e)
