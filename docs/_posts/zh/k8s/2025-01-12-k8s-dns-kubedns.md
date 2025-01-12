# Kube-dns

## 简介

从 Kubernetes v1.3 版本开始，使用 cluster add-on 插件管理器回自动启动内置的 DNS。

Kubernetes DNS pod 中包括 3 个容器：

- kubedns：kubedns 进程监视 Kubernetes master 中的 Service 和 Endpoint 的变化，并维护内存查找结构来服务DNS请求。
- dnsmasq：dnsmasq 容器添加 DNS 缓存以提高性能。
- sidecar：sidecar 容器在执行双重健康检查（针对 dnsmasq 和 kubedns）时提供单个健康检查端点（监听在10054端口）。


DNS pod 具有静态 IP 并作为 Kubernetes 服务暴露出来。该静态 IP 分配后，kubelet 会将使用 --cluster-dns = <dns-service-ip> 标志配置的 DNS 传递给每个容器。

DNS 名称也需要域名。本地域可以使用标志 --cluster-domain = <default-local-domain> 在 kubelet 中配置。

Kubernetes集群DNS服务器基于 SkyDNS 库。它支持正向查找（A 记录），服务查找（SRV 记录）和反向 IP 地址查找（PTR 记录）

## kube-dns 支持的 DNS 格式

kube-dns 将分别为 service 和 pod 生成不同格式的 DNS 记录。

### Service

A记录：生成my-svc.my-namespace.svc.cluster.local域名，解析成 IP 地址，分为两种情况：

- 普通 Service：解析成 ClusterIP

- Headless Service：解析为指定 Pod 的 IP 列表

- SRV记录：为命名的端口（普通 Service 或 Headless Service）生成 _my-port-name._my-port-protocol.my-svc.my-namespace.svc.cluster.local 的域名

### Pod

- A记录：生成域名 pod-ip.my-namespace.pod.cluster.local



## kube-dns 存根域名

可以在 Pod 中指定 hostname 和 subdomain：hostname.custom-subdomain.default.svc.cluster.local

例如：


```
apiVersion: v1
kind: Pod
metadata:
  name: busybox
  labels:
    name: busybox
spec:
  hostname: busybox-1
  subdomain: busybox-subdomain
  containers:
  name: busybox
  - image: busybox
    command:
    - sleep
    - "3600"
```

该 Pod 的域名是 busybox-1.busybox-subdomain.default.svc.cluster.local。

补充： 这样做的意义可以 将相同类型的 Pod 或者 相同业务的 Pod 按照 子域名 进行划分。


## 继承节点的 DNS

运行 Pod 时，kubelet 将预先配置集群 DNS 服务器到 Pod 中，并搜索节点自己的 DNS 设置路径。如果节点能够解析特定于较大环境的 DNS 名称，那么 Pod 应该也能够解析。

Pod 设置不同的 DNS 配置，可以给 kubelet 指定 `--resolv-conf ` 标志。

- 将该值设置为 "" 意味着 Pod 不继承 DNS。
- 将其设置为有效的文件路径意味着 kubelet 将使用此文件而不是 /etc/resolv.conf 用于 DNS 继承。

## 配置存根域和上游 DNS 服务器

通过为 kube-dns （kube-system:kube-dns）提供一个 ConfigMap，集群管理员能够指定 自定义存根域 和 上游 nameserver。

例如，下面的 ConfigMap 建立了一个 DNS 配置，它具有一个单独的存根域和两个上游 nameserver：

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: kube-dns
  namespace: kube-system
data:
  stubDomains: |
    {“acme.local”: [“1.2.3.4”]}
  upstreamNameservers: |
    [“8.8.8.8”, “8.8.4.4”]

```   

上面配置中，带有“.acme.local”后缀的 DNS 请求被转发到地址为 1.2.3.4 的 DNS服务器。 其它域名查询则转发给 DNS 服务器：“8.8.8.8”, “8.8.4.4” 。


### Pod 中 DNS 策略配置

dnsPolicy 取值如下：

- Default 
- None
- ClusterFirst 其名称解析将按其他方式处理，具体取决于存根域和上游 DNS 服务器的配置


如果配置了存根域和上游 DNS 服务器（和在前面例子配置的一样），DNS 查询将根据下面的流程进行路由：

- 查询首先被发送到 kube-dns 中的 DNS 缓存层。
- 从缓存层，检查请求的后缀，并转发到合适的 DNS 上，基于如下的示例：
- 具有集群后缀的名字（例如 “.cluster.local”）：请求被发送到 kube-dns。
- 具有存根域后缀的名字（例如 “.acme.local”）：请求被发送到配置的自定义 DNS 解析器（例如：监听在 1.2.3.4）。
- 不具有能匹配上后缀的名字（例如 “widget.com”）：请求被转发到上游 DNS（例如：Google 公共 DNS 服务器，8.8.8.8 和 8.8.4.4）。

![VuePress Logo](../../.vuepress/public/images/k8s-dns-poilicy.png)

## ConfigMap 选项

kube-dns kube-system:kube-dns ConfigMap 的选项如下所示：

- stubDomains
- upstreamNameservers

### 示例：存根域

在这个例子中，用户有一个 Consul DNS 服务发现系统，他们希望能够与 kube-dns 集成起来。 Consul 域名服务器地址为 10.150.0.1，所有的 Consul 名字具有后缀 .consul.local。 要配置 Kubernetes，集群管理员只需要简单地创建一个 ConfigMap 对象，如下所示：

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: kube-dns
  namespace: kube-system
data:
  stubDomains: |
    {“consul.local”: [“10.150.0.1”]}

```

注意，集群管理员不希望覆盖节点的上游 nameserver，所以他们不会指定可选的 upstreamNameservers 字段。

### 示例：上游 nameserver

在这个示例中，集群管理员不希望显式地强制所有非集群 DNS 查询进入到他们自己的 nameserver 172.16.0.1。 而且这很容易实现：他们只需要创建一个 ConfigMap，upstreamNameservers 字段指定期望的 nameserver 即可。

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: kube-dns
  namespace: kube-system
data:
  upstreamNameservers: |
    [“172.16.0.1”]

```
## 参考

- [安装配置Kube-dns](https://hezhiqiang.gitbook.io/kubernetes-handbook/zui-jia-shi-jian/service-discovery-and-loadbalancing/dns-installation/configuring-dns)
- [Kubernetes DNS github](https://github.com/kubernetes/dns)
- [DNS 学习笔记 - SRV记录](https://skyao.io/learning-dns/dns/record/srv.html)