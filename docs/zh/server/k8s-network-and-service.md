# kubernetes 网络技术与服务通信 (Exploring Network Technologies and Service Communication)

副标题--K8s网络通信技术

云原生是。。。


## 目录

- 网桥 docker网络 K8s 网络插件
- DSN hosts resolv.conf 
- Service/Ingress/Lb 及通信原理
- NameService Polaris
- 服务网格 istio

## K8s 基础知识

- **Kubernetes API server** 在 Kubernetes 中，一切都是由 Kubernetes API 服务器（kube-apiserver）提供的 API 调用。API 服务器是 etcd 数据存储的网关，它维护应用程序集群的所需状态。要更新 Kubernetes 集群的状态，您可以对描述所需状态的 API 服务器进行 API 调用。

- **Controllers** 控制器是用于构建 Kubernetes 的核心抽象。一旦您使用 API 服务器声明了集群的所需状态，控制器就会通过持续观察 API 服务器的状态并对任何更改做出反应来确保集群的当前状态与所需状态相匹配。控制器内部实现了一个循环，该循环不断检查集群的当前状态与集群的期望状态。如果有任何差异，控制器将执行任务以使当前状态与所需状态匹配。例如，当您使用 API 服务器创建新 Pod 时，Kubernetes 调度程序（控制器）会注意到更改并决定将 Pod 放置在集群中的哪个位置。然后它使用 API 服务器（由 etcd 支持）写入状态更改。kubelet（一个控制器）然后会注意到新的变化并设置所需的网络功能以使 Pod 在集群内可访问。在这里，两个独立的控制器对两个独立的状态变化做出反应，以使集群的现实与用户的意图相匹配。

- **Pods** Pod 是 Kubernetes 的原子——用于构建应用程序的最小可部署对象。单个 Pod 代表集群中正在运行的工作负载，并封装了一个或多个 Docker 容器、任何所需的存储和唯一的 IP 地址，组成 pod 的容器被设计为在同一台机器上共同定位和调度。

- **Nodes** 节点是运行 Kubernetes 集群的机器。这些可以是裸机、虚拟机或其他任何东西。主机一词通常与节点互换使用。我将尝试一致地使用术语节点，但有时会根据上下文使用虚拟机这个词来指代节点。

## K8s通信原理

**网络架构图**

![](images/k8s-network-arch.png)

**基础原则**
   
- 每个Pod都拥有一个独立的IP地址，而且假定所有Pod都在一个可以直接连通的、扁平的网络空间中，不管是否运行在同一Node上都可以通过Pod的IP来访问。
- k8s中Pod的IP是最小粒度IP。同一个Pod内所有的容器共享一个网络堆栈，该模型称为IP-per-Pod模型。
- Pod由docker0实际分配的IP，Pod内部看到的IP地址和端口与外部保持一致。同一个Pod内的不同容器共享网络，可以通过localhost来访问对方的端口，类似同一个VM内的不同进程。
- IP-per-Pod模型从端口分配、域名解析、服务发现、负载均衡、应用配置等角度看，Pod可以看作是一台独立的VM或物理机。

## 1.4. k8s集群IP概念汇总

由集群外部到集群内部：

| IP类型                | 说明                                    |
| ------------------- | ------------------------------------- |
| Proxy-IP            | 代理层公网地址IP，外部访问应用的网关服务器。[实际需要关注的IP]    |
| Service-IP          | Service的固定虚拟IP，Service-IP是内部，外部无法寻址到。 |
| Node-IP             | 容器宿主机的主机IP。                           |
| Container-Bridge-IP | 容器网桥（docker0）IP，容器的网络都需要通过容器网桥转发。     |
| Pod-IP              | Pod的IP，等效于Pod中网络容器的Container-IP。      |
| Container-IP        | 容器的IP，容器的网络是个隔离的网络空间。                 |

### 1. 容器间通信

- 在 Linux 中，每个正在运行的进程都在一个网络命名空间内进行通信，该命名空间为逻辑网络堆栈提供了自己的路由、防火墙规则和网络设备。
- 默认情况下，Linux 将每个进程分配给根网络命名空间以提供对外部世界的访问
- 就 Docker 结构而言，Pod 被建模为一组共享网络命名空间的 Docker 容器。
- Pod 中的容器都具有相同的 IP 地址和端口空间，这些 IP 地址和端口空间是通过分配给 Pod 的网络命名空间分配的，并且可以通过 localhost 找到彼此
- 通过 Docker 的 –net=container: 函数加入该命名空间

【实验】

1、 主机和 netspace 之间
```
ip netns add neta
ip netns add netb

ip netns exec test ip link set lo  up
ip netns exec test ip a add 127.0.0.1/8 dev lo

sudo ip netns exec test python3 -m http.server 9000

sudo ip netns exec test2 telnet 127.0.0.1 9000


```
2、 netspace 和 netspace 之间  

### 2. Pod 间通信

#### 1. 同节点Pod通信

- 给定将每个 Pod 与自己的网络堆栈隔离的网络命名空间
- 将每个命名空间连接到根命名空间的虚拟以太网设备以及将命名空间连接在一起的网桥

如下图：

![](https://sookocheff.com/post/kubernetes/understanding-kubernetes-networking-model/pod-to-pod-same-node.gif)

在图 6 中，

- Pod 1 将数据包发送到它自己的以太网设备 eth0，该设备可用作 Pod 的默认设备。
- 对于 Pod 1，eth0 通过虚拟以太网设备连接到根命名空间 veth0 (1)。
- 网桥 cbr0 配置有 veth0 连接到它的网段。一旦数据包到达网桥，网桥会解析正确的网段以使用 ARP 协议将数据包发送到 veth1 (3)。
- 当数据包到达虚拟设备 veth1 时，它被直接转发到 Pod 2 的命名空间和该命名空间内的 eth0 设备 (4)。
- 在整个流量流中，每个 Pod 仅与 localhost 上的 eth0 通信，并且流量被路由到正确的 Pod。
- 使用网络的开发体验是开发人员所期望的默认行为。


【注：】 Pod1 和 Pod2 为什么要通过一对 Veth 连接到cbr0，而不是直接连接到 cbr0呢？

个人理解， Pod1 Pod2 和主机网络（根网络）属于不同子网， 不能直接连接到网桥上，因为网桥属于2层转发设备。所以这里需要借助 Veth 进行连接。

#### 2. 跨节点Pod通信

我们现在转向不同节点上的 Pod .

- 集群中的每个节点都分配有一个 CIDR 块，指定该节点上运行的 Pod 可用的 IP 地址。
- 一旦流向 CIDR 块的流量到达节点，节点就有责任将流量转发到正确的 Pod。

下图说明了两个节点之间的流量流，假设网络可以将 CIDR 块中的流量路由到正确的节点。

![](https://s8.51cto.com/oss/202207/19/88506e4076e8872e26a869b778365926d00f2c.gif)

- 目标 Pod（以绿色突出显示）与源 Pod（以蓝色突出显示）位于不同的节点上。
- 数据包首先通过 Pod 1 的以太网设备发送，该设备与根命名空间 (1) 中的虚拟以太网设备配对。最终，数据包最终到达根命名空间的网桥 (2)。
- ARP 将在网桥上失败，因为没有设备连接到网桥并具有正确的数据包 MAC 地址。失败时，网桥将数据包发送到默认路由——根命名空间的 eth0 设备。此时路由离开节点并进入网络 (3)。
- 我们现在假设网络可以根据分配给节点的 CIDR 块将数据包路由到正确的节点 (4)。数据包进入目标节点的根命名空间（VM 2 上的 eth0），在那里它通过网桥路由到正确的虚拟以太网设备 (5)。
- 最后，路由通过位于 Pod 4 的命名空间 (6) 中的虚拟以太网设备对来完成。
- 一般来说，每个节点都知道如何将数据包传递给在其中运行的 Pod。一旦数据包到达目标节点，数据包的流动方式与在同一节点上的 Pod 之间路由流量的方式相同。

这里存在的问题：
1、让集群中的不同节点主机创建的 Pod 都具有全集群唯一的虚拟IP地址
2、Pod怎么跨越节点将数据发送到另外的Pod。 当然一种办法是： 数据从节点发出去之前，进行SNAT（即将容器ip转换为Node IP），但是这样就违背了上面的基础原则（即Pod IP内外一致）。

解决方案： CNI 插件

- flannel
- 。。。

flannel 解决了如下两个问题：

1、 规划ip地址即路由： 保存在etcd
2、 实现 overlay 网络

其中 2 可以通过不同的backend 来实现：

- UDP
- vxlan
- host-gw
- TencentCloud VPC
  


### 3. Pod 与 Service 之间通信
### 4. Service 与 Internet 之间通信
### 5. 跨集群通信

- vpc
- random hostport

## 名字服务

- DSN
- Polaris

## 服务网格

## 网络术语

## 参考

- [iptables 及 docker 容器网络分析](https://thiscute.world/posts/iptables-and-container-networks/)
- [Linux 网络工具中的瑞士军刀 - socat & netcat](https://thiscute.world/posts/socat-netcat/)
- [Docker在雪球的技术实践](https://github.com/vxiaozhi/architecture.of.internet-product/blob/master/B.%E5%9F%BA%E7%A1%80%E6%9E%B6%E6%9E%84-Docker-%E5%AE%B9%E5%99%A8%E6%9E%B6%E6%9E%84/Docker%E5%9C%A8%E9%9B%AA%E7%90%83%E7%9A%84%E6%8A%80%E6%9C%AF%E5%AE%9E%E8%B7%B5.pdf)
- [深入理解Docker架构与实现 Sunhongliang.pptx](https://github.com/vxiaozhi/architecture.of.internet-product/blob/master/B.%E5%9F%BA%E7%A1%80%E6%9E%B6%E6%9E%84-Docker-%E5%AE%B9%E5%99%A8%E6%9E%B6%E6%9E%84/%E6%B7%B1%E5%85%A5%E7%90%86%E8%A7%A3Docker%E6%9E%B6%E6%9E%84%E4%B8%8E%E5%AE%9E%E7%8E%B0%20Sunhongliang.pptx)
- [高可用架构·Docker实战-第1期.pdf](https://github.com/vxiaozhi/architecture.of.internet-product/blob/master/B.%E5%9F%BA%E7%A1%80%E6%9E%B6%E6%9E%84-Docker-%E5%AE%B9%E5%99%A8%E6%9E%B6%E6%9E%84/%E9%AB%98%E5%8F%AF%E7%94%A8%E6%9E%B6%E6%9E%84%C2%B7Docker%E5%AE%9E%E6%88%98-%E7%AC%AC1%E6%9C%9F.pdf)
- [Docker的网络基础](https://github.com/huweihuang/kubernetes-notes/blob/master/network/docker-network.md)
- [A Guide to the Kubernetes Networking Model](https://sookocheff.com/post/kubernetes/understanding-kubernetes-networking-model/)
- [kubernetes网络模型](https://github.com/huweihuang/kubernetes-notes/blob/master/network/kubernetes-network.md)
- [Kubernetes网络模型](https://kuboard.cn/learning/k8s-intermediate/service/network.html#kubernetes%E5%9F%BA%E6%9C%AC%E6%A6%82%E5%BF%B5)
- [万字长文，带你搞懂 Kubernetes 网络模型](https://www.51cto.com/article/714336.html)
- [Kubernetes网络原理及方案](https://www.kubernetes.org.cn/2059.html)
- [【K8S系列 | 12】深入解析k8s网络](https://open.alipay.com/portal/forum/post/125801225)
- [bcs randomhostport Merge Request](https://github.com/TencentBlueKing/bk-bcs/commit/465d67aad900a230bf17116b4ebc3d7761c943b2)
- [Random host port插件设计方案](https://github.com/TencentBlueKing/bk-bcs/blob/master/docs/features/bcs-webhook-server/plugins/randhostport/design.md)
- [Random host port插件实现](https://github.com/TencentBlueKing/bk-bcs/tree/master/bcs-runtime/bcs-k8s/bcs-component/bcs-webhook-server/internal/plugin/randhostport)
- [聊聊k8s的hostport和NodePort](https://cloud.tencent.com/developer/article/1894185)
- [Kubernetes hostPort 使用](https://www.cnblogs.com/zhangmingcheng/p/17640118.html)
- [hostPort选项](https://knowledge.zhaoweiguo.com/build/html/cloudnative/k8s/yamls/option_hostport)
- [腾讯云 VPC](https://cloud.tencent.com/document/product/215/20046)
