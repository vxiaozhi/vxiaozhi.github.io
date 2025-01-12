---
layout:     post
title:      "k8s 网络插件 Calico"
subtitle:   "k8s 网络插件 Calico"
date:       2025-01-12
author:     "vxiaozhi"
catalog: true
tags:
    - k8s
---

# k8s 网络插件 Calico

## 简介

Calico 是一个纯三层的数据中心网络方案（不需要 Overlay），并且与 OpenStack、Kubernetes、AWS、GCE 等 IaaS 和容器平台都有良好的集成。

Calico 在每一个计算节点利用 Linux Kernel 实现了一个高效的 vRouter 来负责数据转发，而每个 vRouter 通过 BGP 协议负责把自己上运行的 workload 的路由信息像整个 Calico 网络内传播——小规模部署可以直接互联，大规模下可通过指定的 BGP route reflector 来完成。 这样保证最终所有的 workload 之间的数据流量都是通过 IP 路由的方式完成互联的。Calico 节点组网可以直接利用数据中心的网络结构（无论是 L2 或者 L3），不需要额外的 NAT，隧道或者 Overlay Network。

此外，Calico 基于 iptables 还提供了丰富而灵活的网络 Policy，保证通过各个节点上的 ACLs 来提供 Workload 的多租户隔离、安全组以及其他可达性限制等功能。


Calico 主要由 Felix、etcd、BGP client 以及 BGP Route Reflector 组成

- Felix，Calico Agent，跑在每台需要运行 Workload 的节点上，主要负责配置路由及 ACLs 等信息来确保 Endpoint 的连通状态；

- etcd，分布式键值存储，主要负责网络元数据一致性，确保 Calico 网络状态的准确性；

- BGP Client（BIRD）, 主要负责把 Felix 写入 Kernel 的路由信息分发到当前 Calico 网络，确保 Workload 间的通信的有效性；

- BGP Route Reflector（BIRD），大规模部署时使用，摒弃所有节点互联的 mesh 模式，通过一个或者多个 BGP Route Reflector 来完成集中式的路由分发。

- calico/calico-ipam，主要用作 Kubernetes 的 CNI 插件

## Calico 模式

### IPIP模式

IPIP模式是calico的默认网络架构，其实这也是一种overlay的网络架构，但是比overlay更常用的vxlan模式相比更加轻量化。IPinIP就是把一个IP数据包又套在一个IP包里，即把 IP 层封装到 IP 层的一个 tunnel它的作用其实基本上就相当于一个基于IP层的网桥！一般来说，普通的网桥是基于mac层的，根本不需 IP，而这个 ipip 则是通过两端的路由做一个 tunnel，把两个本来不通的网络通过点对点连接起来.

Calico 控制平面的设计要求物理网络得是 L2 Fabric，这样 vRouter 间都是直接可达的，路由不需要把物理设备当做下一跳。为了支持 L3 Fabric，Calico 推出了 IPinIP 的选项。

### BGP模式

Calico常用的模式也是它的王牌模式BGP模式，虽然说calico有BGP模式和IPIP模式但是并不是说IPIP模式就不用建立BGP连接了，IPIP模式也是需要建立BGP连接的(可以通过抓取179端口的报文验证)，只不过建立BGP链接的目标比较清晰，就是对端的tunl0对应的网卡。BGP模式对于IPIP模式的优点也并不是简单的描述为“可以跨节点通信”，IPIP模式也是可以跨节点通信的，只要两个节点能互相连通就可以。而BGP的优点是可以通过指定BGP的对端Peer，一般是交换机，那么只要能接入这个交换机的host或者PC都能通过路由的方式连通calico的其他节点上的容器。也就是说BGP的可扩展的网络拓扑更灵活。

BGP模式下数据包的路径单纯依靠路由进行转发，网络拓扑更自由，IPinIP模式则是有个封包的过程，因此也是一种overlay的方式，封好的包再按照路由进行转发，到达目的节点还有个解包的过程，因此比BGP模式稍微低效一些，但是封包比vxlan添加的字段少因此比vxlan高效一些。但IPinIP模式部署起来相对简单，各有利弊。


## Calico 的不足

既然是三层实现，当然不支持 VRF
不支持多租户网络的隔离功能，在多租户场景下会有网络安全问题

## 参考

- [网络插件 Calico](https://kubernetes.feisky.xyz/extension/network/calico)
- [calico配置步骤--IPIP模式vsBGP模式](https://www.cnblogs.com/janeysj/p/14804986.html)
