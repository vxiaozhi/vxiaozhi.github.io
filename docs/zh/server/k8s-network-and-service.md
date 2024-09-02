# 云原生网络技术与服务通信 (Exploring Network Technologies and Service Communication)

副标题--K8s网络通信技术

云原生是。。。

Kubernetes作为云原生应用的基础调度平台，相当于云原生的操作系统，为了便于系统的扩展，Kubernetes中开放的以下接口，可以分别对接不同的后端，来实现自己的业务逻辑：

- CRI（Container Runtime Interface）：容器运行时接口，提供计算资源

- CNI（Container Network Interface）：容器网络接口，提供网络资源

- CSI（Container Storage Interface）：容器存储接口，提供存储资源


## 目录

- 网桥 docker网络 K8s 网络插件
- DSN hosts resolv.conf 
- Service/Ingress/Lb 及通信原理
- NameService Polaris
- 服务网格 istio

## K8s 基础知识

- Pod
- Node
- Controllers
- Kubernetes API server

## K8s通信原理

网络架构图

https://camo.githubusercontent.com/1aebd968bff43f7def3a57b9e03238ab5dc6a7aaa1e194ca2df40f09f481da9b/68747470733a2f2f7265732e636c6f7564696e6172792e636f6d2f647178746e3069636b2f696d6167652f75706c6f61642f76313531303537383935372f61727469636c652f6b756265726e657465732f6e6574776f726b2f6e6574776f726b2d617263682e706e67

### 1. 容器间通信
### 2. Pod 间通信
### 3. Pod 与 Service 之间通信
### 4. Service 与 Internet 之间通信
### 5. 集群间通信

## 名字服务

- DSN
- POlaris

## 服务网格

## 网络术语

## 参考

- [iptables 及 docker 容器网络分析](https://thiscute.world/posts/iptables-and-container-networks/)
- [Linux 网络工具中的瑞士军刀 - socat & netcat](https://thiscute.world/posts/socat-netcat/)
- [Docker在雪球的技术实践](https://github.com/vxiaozhi/architecture.of.internet-product/blob/master/B.%E5%9F%BA%E7%A1%80%E6%9E%B6%E6%9E%84-Docker-%E5%AE%B9%E5%99%A8%E6%9E%B6%E6%9E%84/Docker%E5%9C%A8%E9%9B%AA%E7%90%83%E7%9A%84%E6%8A%80%E6%9C%AF%E5%AE%9E%E8%B7%B5.pdf)
- [深入理解Docker架构与实现 Sunhongliang.pptx](https://github.com/vxiaozhi/architecture.of.internet-product/blob/master/B.%E5%9F%BA%E7%A1%80%E6%9E%B6%E6%9E%84-Docker-%E5%AE%B9%E5%99%A8%E6%9E%B6%E6%9E%84/%E6%B7%B1%E5%85%A5%E7%90%86%E8%A7%A3Docker%E6%9E%B6%E6%9E%84%E4%B8%8E%E5%AE%9E%E7%8E%B0%20Sunhongliang.pptx)
- [高可用架构·Docker实战-第1期.pdf](https://github.com/vxiaozhi/architecture.of.internet-product/blob/master/B.%E5%9F%BA%E7%A1%80%E6%9E%B6%E6%9E%84-Docker-%E5%AE%B9%E5%99%A8%E6%9E%B6%E6%9E%84/%E9%AB%98%E5%8F%AF%E7%94%A8%E6%9E%B6%E6%9E%84%C2%B7Docker%E5%AE%9E%E6%88%98-%E7%AC%AC1%E6%9C%9F.pdf)
- [Docker的网络基础](https://github.com/huweihuang/kubernetes-notes/blob/master/network/docker-network.md)
- [kubernetes网络模型](https://github.com/huweihuang/kubernetes-notes/blob/master/network/kubernetes-network.md)
- [Kubernetes网络模型](https://kuboard.cn/learning/k8s-intermediate/service/network.html#kubernetes%E5%9F%BA%E6%9C%AC%E6%A6%82%E5%BF%B5)
- [万字长文，带你搞懂 Kubernetes 网络模型](https://www.51cto.com/article/714336.html)
- [Kubernetes网络原理及方案](https://www.kubernetes.org.cn/2059.html)
- [【K8S系列 | 12】深入解析k8s网络](https://open.alipay.com/portal/forum/post/125801225)
- [bcs randomhostport Merge Request](https://github.com/TencentBlueKing/bk-bcs/commit/465d67aad900a230bf17116b4ebc3d7761c943b2)
- [Random host port插件设计方案](https://github.com/TencentBlueKing/bk-bcs/blob/master/docs/features/bcs-webhook-server/plugins/randhostport/design.md)
- [Random host port插件实现](https://github.com/TencentBlueKing/bk-bcs/tree/master/bcs-runtime/bcs-k8s/bcs-component/bcs-webhook-server/internal/plugin/randhostport)
