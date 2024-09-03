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
