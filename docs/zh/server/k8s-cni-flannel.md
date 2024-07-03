# K8s 网络插件 Flannel

## cni（Container Network Interface）

CNI 全称为 Container Network Interface，是用来定义容器网络的一个 规范。[containernetworking/cni](https://github.com/containernetworking/cni) 是一个 CNCF 的 CNI 实现项目，包括基本的 bridge,macvlan等基本网络插件。

一般将cni各种网络插件的可执行文件二进制放到 /usr/libexec/cni/ ，在 /etc/cni/net.d/ 下创建配置文件，剩下的就交给 K8s 或者 containerd 了，我们不关心也不了解其实现。

比如：

```
# ls -lh /usr/libexec/cni/
总用量 133M
-rwxr-xr-x 1 root root 4.4M  8月 18 11:51 bandwidth
-rwxr-xr-x 1 root root 4.3M  3月  6  2021 bridge
-rwxr-x--- 1 root root  31M  8月 18 11:51 calico
-rwxr-x--- 1 root root  30M  8月 18 11:51 calico-ipam
-rwxr-xr-x 1 root root  12M  3月  6  2021 dhcp
-rwxr-xr-x 1 root root 5.6M  3月  6  2021 firewall
-rwxr-xr-x 1 root root 3.1M  8月 18 11:51 flannel
-rwxr-xr-x 1 root root 3.8M  3月  6  2021 host-device
-rwxr-xr-x 1 root root 3.9M  8月 18 11:51 host-local
-rwxr-xr-x 1 root root 4.0M  3月  6  2021 ipvlan
-rwxr-xr-x 1 root root 3.6M  8月 18 11:51 loopback
-rwxr-xr-x 1 root root 4.0M  3月  6  2021 macvlan
-rwxr-xr-x 1 root root 4.2M  8月 18 11:51 portmap
-rwxr-xr-x 1 root root 4.2M  3月  6  2021 ptp
-rwxr-xr-x 1 root root 2.7M  3月  6  2021 sample
-rwxr-xr-x 1 root root 3.2M  3月  6  2021 sbr
-rwxr-xr-x 1 root root 2.8M  3月  6  2021 static
-rwxr-xr-x 1 root root 3.7M  8月 18 11:51 tuning
-rwxr-xr-x 1 root root 4.0M  3月  6  2021 vlan

#ls -lh /etc/cni/net.d/
总用量 12K
-rw-r--r-- 1 root root  607 12月 23 09:39 10-calico.conflist
-rw-r----- 1 root root  292 12月 23 09:47 10-flannel.conflist
-rw------- 1 root root 2.6K 12月 23 09:39 calico-kubeconfig

```

**CNI 插件都是直接通过 exec 的方式调用，而不是通过 socket 这样 C/S 方式，所有参数都是通过环境变量、标准输入输出来实现的。**



## Flannel 简介

Flannel 是 k8s 的默认网络插件， 其内部实现了 CNI（Container Network Interface），主要用来解决容器跨主机网络通信问题。

Flannel的设计目的就是为集群中的所有节点重新规划IP地址的使用规则，从而使得不同节点上的容器能够获得“同属一个内网”且”不重复的”IP地址，并让属于不同节点上的容器能够直接通过内网IP通信。

Flannel实质上是一种“覆盖网络(overlaynetwork)”，也就是将TCP数据包装在另一种网络包里面进行路由转发和通信，目前已经支持udp、vxlan、host-gw、aws-vpc、gce和alloc路由等数据转发方式，默认的节点间数据通信方式是UDP转发。



控制平面上host本地的flanneld负责从远端的ETCD集群同步本地和其它host上的subnet信息，并为POD分配IP地址。数据平面flannel通过Backend（比如UDP封装）来实现L3 Overlay，既可以选择一般的TUN设备又可以选择VxLAN设备。



## Flannel 特点

- Flannel通过给每台宿主机分配一个子网的方式为容器提供虚拟网络，该虚拟网络可基于不同的 Backend 实现，并借助etcd维护网络的分配情况。
- 集群中的不同Node主机创建的Docker容器都具有全集群唯一的虚拟IP地址。
- 建立一个覆盖网络（overlay network），通过这个覆盖网络，将数据包原封不动的传递到目标容器。
- 覆盖网络是建立在另一个网络之上并由其基础设施支持的虚拟网络。覆盖网络通过将一个分组封装在另一个分组内来将网络服务与底层基础设施分离。在将封装的数据包转发到端点后，将其解封装。
- 创建一个新的虚拟网卡flannel0接收docker网桥的数据，通过维护路由表，对接收到的数据进行封包和转发（vxlan）。
- etcd保证了所有node上flanned所看到的配置是一致的。同时每个node上的flanned监听etcd上的数据变化，实时感知集群中node的变化。
- flannel利用各种backend mechanism，例如udp，vxlan等等，跨主机转发容器间的网络流量，完成容器间的跨主机通信。


## Flannel backend

- UDP  基于Linux TUN/TAP， 主要是利用 tun 设备来模拟一个虚拟网络进行通信， 使用UDP封装IP包来创建overlay网络
- VXLAN 利用 vxlan 实现一个三层的覆盖网络，利用 flannel1 这个 vtep 设备来进行封拆包，然后进行路由转发实现通信。 vxlan，这个是在内核实现的，如果用 UDP 封装就是在用户态实现的，用户态实现的等于把包从内核过了两遍，没有直接用 vxlan 封装的直接走内核效率高，所以基本上不会使用 UDP 封装。
- host-gw 直接，直接改变二层网络的路由信息，实现数据包的转发，从而省去中间层，通信效率更高. 但要求各个节点之间是二层连通的。

## 与 Calico 对比

- Flannel 英文释义： 法兰绒布
- Calico 英文释义： 印花棉布

为什么要用布来为该插件起名呢？ 猜测因为布是由一根根丝线织成的，秘密麻麻犹如网状。 这跟网络通信由一条条看不见的虚拟链路组成结构很相似， 所以由代表布的单词来命名。

## 参考

- [flannel github](https://github.com/flannel-io/flannel)
- [flannel backends](https://github.com/flannel-io/flannel/blob/master/Documentation/backends.md)
- [白话 OSI 七层网络模型](https://www.freecodecamp.org/chinese/news/osi-model-networking-layers/)
- [云原生虚拟网络之 Flannel 工作原理](https://www.luozhiyun.com/archives/695)
- [云原生虚拟网络之 VXLAN 协议](https://www.luozhiyun.com/archives/687)
- [k8s网络之Flannel网络](https://www.cnblogs.com/goldsunshine/p/10740928.html)
- [flannel 网络架构](https://ggaaooppeenngg.github.io/zh-CN/2017/09/21/flannel-%E7%BD%91%E7%BB%9C%E6%9E%B6%E6%9E%84/)
- [理解flannel的三种容器网络方案原理](https://www.zhengwenfeng.com/pages/d9d0ce/)
- [kubernetes Flannel网络剖析](https://plantegg.github.io/2022/01/19/kubernetes_Flannel%E7%BD%91%E7%BB%9C%E5%89%96%E6%9E%90/)
- [Linux 下 VxLAN 实践](https://github.com/xujiyou/blog-data/blob/master/Linux/%E7%BD%91%E7%BB%9C/Linux%E4%B8%8BVxLAN%E5%AE%9E%E8%B7%B5.md)
- [Linux虚拟网络设备之Bridge](https://github.com/xujiyou/blog-data/blob/master/Linux/%E7%BD%91%E7%BB%9C/Linux%E8%99%9A%E6%8B%9F%E7%BD%91%E7%BB%9C%E8%AE%BE%E5%A4%87%E4%B9%8BBridge.md)
- [Linux 虚拟网络设备 veth-pair 详解，看这一篇就够了](https://www.cnblogs.com/bakari/p/10613710.html)