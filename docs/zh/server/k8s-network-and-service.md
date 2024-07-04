# 云原生网络技术与服务通信 (Exploring Network Technologies and Service Communication)

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

## 参考

- [iptables 及 docker 容器网络分析](https://thiscute.world/posts/iptables-and-container-networks/)
- [Linux 网络工具中的瑞士军刀 - socat & netcat](https://thiscute.world/posts/socat-netcat/)