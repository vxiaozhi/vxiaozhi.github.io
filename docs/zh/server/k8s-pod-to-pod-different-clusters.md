# K8s 跨集群通信

分两种情况讨论：

**不同集群间Node互通**  

- 如公司内部多个集群 或者
- 同一个云服务商如腾讯云下的多个集群。

**不同集群间Node不互通** 

- 如公司内集群 和 腾讯公有云集群。
- 不同云服务商之间的集群，如腾讯云、阿里云。

## 方案

**不同集群间Node互通**

- vpc
- hostport
- random hostport

**不同集群间Node不互通**

- [submariner](https://github.com/submariner-io/submariner)
- [Skupper](https://github.com/skupperproject/skupper)
- [Kubeslice ](https://github.com/kubeslice/kubeslice)


## 参考

- [Kubernetes 多集群通信的五种方案](https://www.cnblogs.com/cheyunhua/p/18227292)
- [Kubernetes 多集群网络解决方案 Submariner 中文入门指南](https://www.modb.pro/db/623405)