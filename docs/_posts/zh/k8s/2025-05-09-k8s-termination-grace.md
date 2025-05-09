---
layout:     post
title:      "Kubernetes 优雅停止"
subtitle:   "Kubernetes 优雅停止"
date:       2025-05-09
author:     "vxiaozhi"
catalog: true
tags:
    - k8s
---

# Kubernetes 优雅停止

在Kubernetes (K8s) 中，Pod的优雅终止过程是一个有序的过程，旨在确保Pod中运行的应用程序能够平滑关闭，释放资源，并尽可能减少因突然关闭带来的数据丢失和服务中断。

## 以下是Pod优雅终止的一般步骤

1.  **删除Pod请求**
    
    - 用户或控制器发出删除Pod的请求，比如通过 `kubectl delete pod <pod-name>` 或者由于Deployment的滚动更新策略等。

2.  **Pod状态更改为Terminating**
    
    - Kubernetes控制平面接收到请求后，将Pod的状态更新为“Terminating”。

3.  **kube-proxy更新**
    
    - kube-proxy会立即从Service的负载均衡列表中移除该Pod，停止新的网络流量被路由到该Pod。

4.  **执行PreStop Hook**
    
    - 如果Pod的定义中包含了`.spec.containers[].lifecycle.preStop`钩子，kubelet将在发送SIGTERM信号之前执行这些自定义操作，例如清理缓存、写入最终状态或通知外部服务。

5.  **发送SIGTERM信号**
    
    - kubelet向Pod中的每个容器发送SIGTERM信号，这标志着容器应该开始执行其自身的优雅停机流程。

6.  **等待容器关闭**
    
    - 容器在接收到SIGTERM信号后应尽快结束处理正在进行的请求，并在完成必要的清理工作后自行退出。

7.  **Grace Period（优雅终止期）**
    
    - Kubernetes会给Pod一个默认的 grace period（默认为30秒，可在Pod的`.spec.terminationGracePeriodSeconds`中自定义），在此期间等待容器自己关闭。

8.  **强制停止**
    
    - 如果容器在grace period结束后仍未退出，kubelet将向其发送SIGKILL信号强制终止容器，以确保Pod能够及时释放资源。

9.  **清理Pod资源**
    
    - 所有容器终止后，kubelet会清理与Pod关联的一切资源，如临时存储卷、环境变量、网络端点等。

10. **Pod完全删除**
    
    - 当Pod的所有资源都被成功清理，kubelet会将Pod从集群中删除，Pod的生命周期至此结束。

综上所述，整个过程中，应用程序应当监听SIGTERM信号，并在接收到该信号时开始优雅地关闭服务。这一系列动作确保了Pod不仅能够快速响应集群管理的需求，还能尽量避免由此造成的用户体验下降或数据完整性损失。

需要注意的是，如果在等待容器进程停止的过程中，kubelet或容器管理器发生了重启，那么终止操作会重新获得一个满额的删除宽限期并重新执行删除操作。

优雅终止过程确保了Pod中的容器在被删除前能够完成必要的清理工作，从而避免了数据丢失和资源泄漏。这对于长期运行的容器和需要保持数据一致性的应用来说尤为重要。

## 原理及实践

参考 ： [详解Kubernetes Pod优雅退出](https://www.cnblogs.com/zhangmingcheng/p/18254613)
