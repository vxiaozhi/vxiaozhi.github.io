# K8s 网络插件 SRIOV-CNI

SRIOV-CNI最早由腾讯互娱计算资源团队开发， 后被 CNI 社区接纳，并被Intel关注和[Fork](https://github.com/Intel-Corp/sriov-cni)。

SRIOV-CNI 为K8s 提供一种 Underlay 网络。 其主要是 基于 网卡虚拟化技术 SR-IOV 实现的。

**SR-IOV** 

SR-IOV 技术是一种基于硬件的虚拟化解决方案，可提高性能和可伸缩性

- SR-IOV 标准允许在虚拟机之间高效共享 PCIe（Peripheral Component Interconnect Express，快速外设组件互连）设备，并且它是在硬件中实现的，可以获得能够与本机性能媲美的 I/O 性能。
- SR-IOV 规范定义了新的标准，根据该标准，创建的新设备可允许将虚拟机直接连接到 I/O 设备（SR-IOV 规范由 PCI-SIG 在 http://www.pcisig.com 上进行定义和维护）。
- 单个 I/O 资源可由许多虚拟机共享。共享的设备将提供专用的资源，并且还使用共享的通用资源。这样，每个虚拟机都可访问唯一的资源。因此，启用了 SR-IOV 并且具有适当的硬件和 OS 支持的 PCIe 设备（例如以太网端口）可以显示为多个单独的物理设备，每个都具有自己的 PCIe 配置空间。

SR-IOV主要用于虚拟化中，当然也可以用于容器。

[sriov-cni](https://github.com/hustcat/sriov-cni)最初是由Tencent IEG开源的，被CNI社区接纳后， Intel [fork](https://github.com/k8snetworkplumbingwg/sriov-cni)了项目后，并对其进行了扩展，增加了更多的网卡支持、VF的自动分配管理、支持DPDK等。


**Sriov-network-operator**

目前使用 sriov 的方式比较复杂繁琐，需要管理员完全手动配置，如手动确认网卡是否支持 SRIOV、配置 PF 和 VF 等，参考 sriov。社区开源[Sriov-network-operator](https://github.com/k8snetworkplumbingwg/sriov-network-operator) ， 旨在降低使用 sriov-cni 的难度。sriov-operator 整合 sriov-cni 和 sriov-device-plugin 两个项目， 完全使用 CRD 的方式统一使用和配置 sriov，包括组件本身和节点上的必要配置，极大地降低了使用难度。

**sriov-network-device-plugin**

sriov-cni通常以附加网络形式使用，需要使用multus这类CNI，与flannel结合使用。以multus为例，通常由三个组件组成：

- [Multus-CNI ](https://github.com/k8snetworkplumbingwg/multus-cni) 是为POD提供多网卡的能力，其采用CRD方式添加附加网卡到POD中，并为网卡分配IP，具有IPAM功能。华为的cni-genie、tkestack的galaxy都与此类似
- [sriov-cni](https://github.com/k8snetworkplumbingwg/sriov-cni)  为POD提供sriov功能
- [sriov-network-device-plugin](https://github.com/k8snetworkplumbingwg/sriov-network-device-plugin) 为sriov提供设备功能，将vf抽象为资源，管理vf的分配、释放等功能


## SR-IOV CNI 配置

### 1. 环境要求

使用 SR-IOV CNI 需要先确认节点是否为物理主机并且节点拥有支持 SR-IOV 的物理网卡。 如果节点为 VM 虚拟机或者没有支持 SR-IOV 的网卡，那么 SR-IOV 将无法工作。 可通过下面的方式检查节点是否存在支持 SR-IOV 功能的网卡。

检查是否支持 SR-IOV

通过 ip link show 获取所有网卡：

```
root@172-17-8-120:~# ip link show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
    link/ether b8:ca:3a:67:e5:fc brd ff:ff:ff:ff:ff:ff
    altname enp1s0f0
3: eno2: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN mode DEFAULT group default qlen 1000
    link/ether b8:ca:3a:67:e5:fd brd ff:ff:ff:ff:ff:ff
    altname enp1s0f1
4: eno3: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN mode DEFAULT group default qlen 1000
    link/ether b8:ca:3a:67:e5:fe brd ff:ff:ff:ff:ff:ff
    altname enp1s0f2
5: eno4: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN mode DEFAULT group default qlen 1000
    link/ether b8:ca:3a:67:e5:ff brd ff:ff:ff:ff:ff:ff
    altname enp1s0f3
6: enp4s0f0np0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
    link/ether 04:3f:72:d0:d2:86 brd ff:ff:ff:ff:ff:ff
7: enp4s0f1np1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
    link/ether 04:3f:72:d0:d2:87 brd ff:ff:ff:ff:ff:ff
8: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default
    link/ether 02:42:60:cb:04:10 brd ff:ff:ff:ff:ff:ff
```

过滤常见的虚拟网卡（如 docker0、cali*、vlan 子接口等），以 enp4s0f0np0 为例，确认其是否支持 SR-IOV：

```
root@172-17-8-120:~# ethtool -i enp4s0f0np0
driver: mlx5_core    # 网卡驱动
version: 5.15.0-52-generic
firmware-version: 16.27.6008 (LNV0000000033)
expansion-rom-version:
bus-info: 0000:04:00.0  # PCI 设备号
supports-statistics: yes
supports-test: yes
supports-eeprom-access: no
supports-register-dump: no
supports-priv-flags: yes
```

通过 bus-info 查询其 PCI 设备详细信息：

```
root@172-17-8-120:~# lspci -s 0000:04:00.0 -v | grep SR-IOV
    Capabilities: [180] Single Root I/O Virtualization (SR-IOV)
```

如果输出有上面此行，说明此网卡支持 SR-IOV。获取此网卡的 vendor 和 device：

```
root@172-17-8-120:~# lspci -s 0000:04:00.0 -n
04:00.0 0200: 15b3:1017
```

其中，

- 15b3：表示此 PCI 设备的厂商号，如 15b3 表示 Mellanox
- 1017：表示此 PCI 设备的设备型号，如 1017 表示 Mellanox MT27800 Family [ConnectX-5] 系列网卡

> 可通过 https://devicehunt.com/all-pci-vendors 查询所有 PCI 设备信息。

### 2. 配置 VF（虚拟功能）¶

通过下面的方式为支持 SR-IOV 的网卡配置 VF：

```
root@172-17-8-120:~# echo 8 > /sys/class/net/enp4s0f0np0/device/sriov_numvfs
```

确认 VF 配置成功：

```
root@172-17-8-120:~# cat /sys/class/net/enp4s0f0np0/device/sriov_numvfs
8
root@172-17-8-120:~# ip l show enp4s0f0np0
6: enp4s0f0np0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
    link/ether 04:3f:72:d0:d2:86 brd ff:ff:ff:ff:ff:ff
    vf 0     link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff, spoof checking off, link-state auto, trust off, query_rss off
    vf 1     link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff, spoof checking off, link-state auto, trust off, query_rss off
    vf 2     link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff, spoof checking off, link-state auto, trust off, query_rss off
    vf 3     link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff, spoof checking off, link-state auto, trust off, query_rss off
    vf 4     link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff, spoof checking off, link-state auto, trust off, query_rss off
    vf 5     link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff, spoof checking off, link-state auto, trust off, query_rss off
    vf 6     link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff, spoof checking off, link-state auto, trust off, query_rss off
    vf 7     link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff, spoof checking off, link-state auto, trust off, query_rss off
```

输出上图内容，表示配置成功。

### 3. 安装 SR-IOV CNI¶

通过安装 Multus-underlay 来安装 SR-IOV CNI，具体安装流程参考[安装](https://docs.daocloud.io/network/modules/multus-underlay/install/)。 注意, 安装时需正确配置 sriov-device-plugin resource 资源，包括 vendor、device 等信息。 否则 SRIOV-Device-Plugin 无法找到正确的 VF。

### 4. 配置 SRIOV-Device-Plugin¶
安装完 SR-IOV CNI 之后，通过下面的方式查看 SR-IOV CNI 是否发现了主机上的 VF：

```
root@172-17-8-110:~# kubectl describe nodes 172-17-8-110
...
Allocatable:
  cpu:                           24
  ephemeral-storage:             881675818368
  hugepages-1Gi:                 0
  hugepages-2Mi:                 0
  intel.com/sriov-netdevice:     8      # 此行表示 SR-IOV CNI 成功的发现了该主机上的 VFs 
  memory:                        16250260Ki
  pods:                          110
```

## 优缺点

**优点**

- 性能好, 不占用计算资源
- intel主推，社区活跃

**缺点**

- 强依赖底层网络；
- 环境要求高：使用 SR-IOV CNI 需要先确认节点是否为物理主机并且节点拥有支持 SR-IOV 的物理网卡。 如果节点为 VM 虚拟机或者没有支持 SR-IOV 的网卡，那么 SR-IOV 将无法工作。
- VF数量有限.
- 需要使用主机子网，需要IP资源较多；
- 硬件绑定，不支持容器迁移

## 简介

- [SR-IOV](https://kubernetes.feisky.xyz/extension/network/sriov)
- [SR-IOV CNI 配置](https://docs.daocloud.io/network/modules/multus-underlay/sriov/)
- [玩转sriov-network-device-plugin](https://rexrock.github.io/post/k8s-net-sriov/)
