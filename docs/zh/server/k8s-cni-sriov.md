# K8s 网络插件 SR-IOV

SR-IOV 技术是一种基于硬件的虚拟化解决方案，可提高性能和可伸缩性

SR-IOV 标准允许在虚拟机之间高效共享 PCIe（Peripheral Component Interconnect Express，快速外设组件互连）设备，并且它是在硬件中实现的，可以获得能够与本机性能媲美的 I/O 性能。
SR-IOV 规范定义了新的标准，根据该标准，创建的新设备可允许将虚拟机直接连接到 I/O 设备（SR-IOV 规范由 PCI-SIG 在 http://www.pcisig.com 上进行定义和维护）。
单个 I/O 资源可由许多虚拟机共享。共享的设备将提供专用的资源，并且还使用共享的通用资源。这样，每个虚拟机都可访问唯一的资源。因此，启用了 SR-IOV 并且具有适当的硬件和 OS 支持的 PCIe 设备（例如以太网端口）可以显示为多个单独的物理设备，每个都具有自己的 PCIe 配置空间。

SR-IOV主要用于虚拟化中，当然也可以用于容器。

[sriov-cni](https://github.com/hustcat/sriov-cni)最初是由Tencent IEG开源的，被CNI社区接纳后， Intel [fork](https://github.com/k8snetworkplumbingwg/sriov-cni)了项目后，并对其进行了扩展，增加了更多的网卡支持、VF的自动分配管理、支持DPDK等。


## 优点

- 性能好
- 不占用计算资源

## 缺点

- VF数量有限
- 硬件绑定，不支持容器迁移

## 简介

- [SR-IOV](https://kubernetes.feisky.xyz/extension/network/sriov)
