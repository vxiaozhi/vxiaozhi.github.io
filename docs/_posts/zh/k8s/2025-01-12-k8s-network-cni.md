---
layout:     post
title:      "K8s CNI网络插件"
subtitle:   "K8s CNI网络插件"
date:       2025-01-12
author:     "vxiaozhi"
catalog: true
tags:
    - k8s
---

# K8s CNI网络插件


- [Antrea](https://github.com/antrea-io/antrea)
- [amazon-vpc-cni-k8s](https://github.com/aws/amazon-vpc-cni-k8s)
- [calico](https://github.com/projectcalico/calico)
- [canal](https://github.com/projectcalico/canal)
- [cilium](https://github.com/cilium/cilium)
- [contiv](https://github.com/contiv/vpp)
- [Flannel](https://github.com/flannel-io/flannel)
- [Kube-router](https://github.com/cloudnativelabs/kube-router)
- [Kube-OVN](https://github.com/kubeovn/kube-ovn)
- [WeaveNet](https://github.com/weaveworks/weave)
- [阿里云 Terway CNI Network Plugin](https://github.com/AliyunContainerService/terway)


## CNI 性能

ITNEXT 网站对不同插件的测评

- [Benchmark results of Kubernetes network plugins (CNI) over 10Gbit/s network (Updated: August 2020)](https://itnext.io/benchmark-results-of-kubernetes-network-plugins-cni-over-10gbit-s-network-updated-august-2020-6e1b757b9e49)
- [Benchmark results of Kubernetes network plugins (CNI) over 40Gbit/s network [2024]](https://itnext.io/benchmark-results-of-kubernetes-network-plugins-cni-over-40gbit-s-network-2024-156f085a5e4e#89d8-90c23c8caeb4-reply)

作者给的建议是：

- 小规模集群： 推荐使用 Kube-router（发展迅速）！轻量级、高效，支持广泛的架构（amd64、arm64、riscv64等），如果追求稳定、省事，考虑Flannel或Canal作为替代方案。
- 标准集群： Cilium是首选，其次是Calico或Antrea。（可观测性、故障排除和配置的CLI、基于eBPF的kube-proxy替代方案、文档全面）。
- 高性能集群：Calico 或 Calico VPP。（高性能/流量加密）。




## 参考
- [CNCF Landscape](https://landscape.cncf.io/)
- [k8s cni](https://kubernetes.feisky.xyz/extension/network/cni)
- [CNI 规范定义](https://github.com/containernetworking/cni/blob/main/SPEC.md)
- [Kubernetes CNI 插件选型和应用场景探讨](https://kubesphere.io/zh/blogs/kubernetes-cni/)
- [腾讯云容器网络概述](https://cloud.tencent.com/document/product/457/50353)
- [循序渐进理解CNI机制与Flannel工作原理](https://blog.yingchi.io/posts/2020/8/k8s-flannel.html)
- [深入浅出运维可观测工具（一）：聊聊 eBPF 的前世今生](https://cloudnative.to/blog/current-state-and-future-of-ebpf/)
- [酷壳 - EBPF 介绍](https://coolshell.cn/articles/22320.html)
- [Introducing the Calico eBPF dataplane](https://www.tigera.io/blog/introducing-the-calico-ebpf-dataplane/)
- [The Ultimate Guide To Using Calico, Flannel, Weave and Cilium](https://platform9.com/blog/the-ultimate-guide-to-using-calico-flannel-weave-and-cilium/)
- [Multi CNI  Intel方案 Multus-CNI](https://github.com/k8snetworkplumbingwg/multus-cni)
- [Multi CNI  华为 CNI-Genie](https://github.com/cni-genie/CNI-Genie)
- [Multi CNI 腾讯tkestack的galaxy](https://github.com/tkestack/galaxy)
- [sriov-cni 为POD提供sriov功能和DPDK驱动配置，提供具体的VF功能](https://github.com/k8snetworkplumbingwg/sriov-cni)
- [Benchmark results of Kubernetes network plugins (CNI) over 10Gbit/s network (Updated: August 2020)](https://itnext.io/benchmark-results-of-kubernetes-network-plugins-cni-over-10gbit-s-network-updated-august-2020-6e1b757b9e49)
- [Benchmark results of Kubernetes network plugins (CNI) over 40Gbit/s network [2024]](https://itnext.io/benchmark-results-of-kubernetes-network-plugins-cni-over-40gbit-s-network-2024-156f085a5e4e#89d8-90c23c8caeb4-reply)
- [What is Kube-Proxy and why move from iptables to eBPF?](https://isovalent.com/blog/post/why-replace-iptables-with-ebpf/)
