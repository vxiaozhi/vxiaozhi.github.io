# K8s dns 技术实现原理

K8s 中DNS采用的服务器方案也在不断演变， 早期用的是 kube-dns， 从 1.11 版本开始 默认的dns服务器 由 kube-dns切换到了 coredns。

[kube-dns 与 coredns 性能数据对比](https://coredns.io/2018/11/27/cluster-dns-coredns-vs-kube-dns/)

- 整个 CoreDNS 服务都建立在一个使用 Go 编写的 HTTP/2 Web 服务器 [Caddy · GitHub](https://github.com/caddyserver/caddy) 上，CoreDNS 整个项目可以作为一个 Caddy 的教科书用法。
- CoreDNS 的大多数功能都是由插件来实现的，插件和服务本身都使用了 Caddy 提供的一些功能，可以根据不同的需求给不同的域名配置不同的插件.
- 对于内部域名解析 KubeDNS 要优于 CoreDNS 大约 10%，可能是因为 dnsmasq 对于缓存的优化会比 CoreDNS 要好
- 对于外部域名 CoreDNS 要比 KubeDNS 好 3 倍。但这个值大家看看就好，因为 kube-dns 不会缓存 Negative cache。但即使 kubeDNS 使用了 Negative cache，表现仍然也差不多
- CoreDNS 的内存占用情况会优于 KubeDNS


## 一、K8s 内部域名解析原理

先带着两个问题：

 1. 为什么同一个 Namespace 下，直接访问服务名即可？不同 Namespace 下，需要带上 Namespace 才行？
 1. 为什么内部的域名可以做解析，原理是什么？


### 1. 搜索域

DNS 如何解析，依赖容器内 resolv 文件的配置

 ```
cat /etc/resolv.conf

nameserver 10.233.0.3
search default.svc.cluster.local svc.cluster.local cluster.local
 ```

这个文件中，配置的 DNS Server，一般就是 K8S 中，kubedns 的 Service 的 ClusterIP，这个IP是虚拟IP，无法ping，但可以访问。

```
[root@node4 user1]# kubectl get svc -n kube-system
NAME                   TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)         AGE
kube-dns               ClusterIP   10.233.0.3      <none>        53/UDP,53/TCP   270d
kubernetes-dashboard   ClusterIP   10.233.22.223   <none>        443/TCP         124d
```

所以，所有域名的解析，其实都要经过 kubedns 的虚拟IP 10.233.0.3 进行解析，不论是 Kubernetes 内部域名还是外部的域名。

Kubernetes 中，域名的全称，必须是 service-name.namespace.svc.cluster.local 这种模式，所以，当我们执行下面的命令时：

```
curl b
```
必须得有一个 Service 名称为 b. 在容器内，会根据 /etc/resolve.conf 进行解析流程。选择 nameserver 10.233.0.3 进行解析，然后，用字符串 “b”，依次带入 /etc/resolve.conf 中的 search 域，进行DNS查找，分别是：

```
// search 内容类似如下（不同的pod，第一个域会有所不同）
search default.svc.cluster.local svc.cluster.local cluster.local
```

b.default.svc.cluster.local -> b.svc.cluster.local -> b.cluster.local ，直到找到为止。

### 2. DNS 记录

哪些对象会获得 DNS 记录呢？

- Services
- Pods

Services

- A/AAAA 记录
“普通” Service（除了无头 Service）会以 my-svc.my-namespace.svc.cluster-domain.example 这种名字的形式被分配一个 DNS A 或 AAAA 记录，取决于 Service 的 IP 协议族。 该名称会解析成对应 Service 的集群 IP。

“无头（Headless）” Service （没有集群 IP）也会以 my-svc.my-namespace.svc.cluster-domain.example 这种名字的形式被指派一个 DNS A 或 AAAA 记录， 具体取决于 Service 的 IP 协议族。 与普通 Service 不同，这一记录会被解析成对应 Service 所选择的 Pod IP 的集合。 客户端要能够使用这组 IP，或者使用标准的轮转策略从这组 IP 中进行选择。

- SRV 记录
Kubernetes 根据普通 Service 或 Headless Service 中的命名端口创建 SRV 记录。每个命名端口， SRV 记录格式为 _my-port-name._my-port-protocol.my-svc.my-namespace.svc.cluster-domain.example。 普通 Service，该记录会被解析成端口号和域名：my-svc.my-namespace.svc.cluster-domain.example。 无头 Service，该记录会被解析成多个结果，及该服务的每个后端 Pod 各一个 SRV 记录， 其中包含 Pod 端口号和格式为 auto-generated-name.my-svc.my-namespace.svc.cluster-domain.example 的域名。

Pods

- A/AAAA 记录  `pod-ip-address.my-namespace.pod.cluster-domain.example`



## 二、 k8s DNS 策略

在Kubernetes 中，有4种 DNS 策略，从 Kubernetes 源码中看：

```
const (
	// DNSClusterFirstWithHostNet indicates that the pod should use cluster DNS
	// first, if it is available, then fall back on the default
	// (as determined by kubelet) DNS settings.
	DNSClusterFirstWithHostNet DNSPolicy = "ClusterFirstWithHostNet"

	// DNSClusterFirst indicates that the pod should use cluster DNS
	// first unless hostNetwork is true, if it is available, then
	// fall back on the default (as determined by kubelet) DNS settings.
	DNSClusterFirst DNSPolicy = "ClusterFirst"

	// DNSDefault indicates that the pod should use the default (as
	// determined by kubelet) DNS settings.
	DNSDefault DNSPolicy = "Default"

	// DNSNone indicates that the pod should use empty DNS settings. DNS
	// parameters such as nameservers and search paths should be defined via
	// DNSConfig.
	DNSNone DNSPolicy = "None"
)
```

这几种DNS策略，需要在Pod，或者Deployment、RC等资源中，设置 dnsPolicy 即可，以 Pod 为例：

```
apiVersion: v1
kind: Pod
metadata:
   labels:
    name: cadvisor-nodexxxx
    hostip: 192.168.x.x
  name: cadvisor-nodexxxx
  namespace: monitoring
spec:
  containers:
  - args:
    - --profiling
    - --housekeeping_interval=10s
    - --storage_duration=1m0s
    image: google/cadvisor:latest
    name: cadvisor-nodexxxx
    ports:
    - containerPort: 8080
      name: http
      protocol: TCP
    resources: {}
    securityContext:
      privileged: true
    terminationMessagePath: /dev/termination-log
    terminationMessagePolicy: File
  dnsPolicy: ClusterFirst
  nodeName: nodexxxx
```

具体来说：

- None
 表示空的DNS设置
 这种方式一般用于想要自定义 DNS 配置的场景，而且，往往需要和 dnsConfig 配合一起使用达到自定义 DNS 的目的。
 

- Default
 有人说 Default 的方式，是使用宿主机的方式，这种说法并不准确。
 这种方式，其实是，让 kubelet 来决定使用何种 DNS 策略。而 kubelet 默认的方式，就是使用宿主机的 /etc/resolv.conf（可能这就是有人说使用宿主机的DNS策略的方式吧），但是，kubelet 是可以灵活来配置使用什么文件来进行DNS策略的，我们完全可以使用 kubelet 的参数：–resolv-conf=/etc/resolv.conf 来决定你的DNS解析文件地址。
 

- ClusterFirst
 这种方式，表示 POD 内的 DNS 使用集群中配置的 DNS 服务，简单来说，就是使用 Kubernetes 中 kubedns 或 coredns 服务进行域名解析。如果解析不成功，才会使用宿主机的 DNS 配置进行解析。
 

- ClusterFirstWithHostNet
 在某些场景下，我们的 POD 是用 HOST 模式启动的（HOST模式，是共享宿主机网络的），一旦用 HOST 模式，表示这个 POD 中的所有容器，都要使用宿主机的 /etc/resolv.conf 配置进行DNS查询，但如果你想使用了 HOST 模式，还继续使用 Kubernetes 的DNS服务，那就将 dnsPolicy 设置为 ClusterFirstWithHostNet。
 
## 三、 DNS 配置

Pod 的 DNS 配置可让用户对 Pod 的 DNS 设置进行更多控制。

dnsConfig 字段是可选的，它可以与任何 dnsPolicy 设置一起使用。 但是，当 Pod 的 dnsPolicy 设置为 “None” 时，必须指定 dnsConfig 字段。

用户可以在 dnsConfig 字段中指定以下属性：

- nameservers：将用作于 Pod 的 DNS 服务器的 IP 地址列表。 最多可以指定 3 个 IP 地址。当 Pod 的 dnsPolicy 设置为 “None” 时， 列表必须至少包含一个 IP 地址，否则此属性是可选的。 所列出的服务器将合并到从指定的 DNS 策略生成的基本名称服务器，并删除重复的地址。
- searches：用于在 Pod 中查找主机名的 DNS 搜索域的列表。此属性是可选的。 指定此属性时，所提供的列表将合并到根据所选 DNS 策略生成的基本搜索域名中。 重复的域名将被删除。Kubernetes 最多允许 6 个搜索域。
- options：可选的对象列表，其中每个对象可能具有 name 属性（必需）和 value 属性（可选）。 此属性中的内容将合并到从指定的 DNS 策略生成的选项。 重复的条目将被删除。

以下是具有自定义 DNS 设置的 Pod 示例：

```
apiVersion: v1
kind: Pod
metadata:
  namespace: default
  name: dns-example
spec:
  containers:
    - name: test
      image: nginx
  dnsPolicy: "None"
  dnsConfig:
    nameservers:
      - 1.2.3.4
    searches:
      - ns1.svc.cluster-domain.example
      - my.dns.search.suffix
    options:
      - name: ndots
        value: "2"
      - name: edns0
```

创建上面的 Pod 后，容器 test 会在其 /etc/resolv.conf 文件中获取以下内容：

```
nameserver 1.2.3.4
search ns1.svc.cluster-domain.example my.dns.search.suffix
options ndots:2 edns0
```

## 四、CoreDNS配置【全局配置】

以下是一个1.6.2版本CoreDNS默认采用的配置文件：

```
  Corefile: |
    .:53 {
        errors
        log
        health {
           lameduck 15s
        }
        ready
        kubernetes {{.ClusterDomain}} in-addr.arpa ip6.arpa {
          pods verified
          fallthrough in-addr.arpa ip6.arpa
        }
        prometheus :9153
        forward . /etc/resolv.conf {
              prefer_udp
        }
        cache 30
        loop
        reload
        loadbalance
    }
```

**说明** 配置文件中ClusterDomain代指集群创建过程中填写的集群本地域名，默认值为cluster.local。

参数说明：

- errors 错误信息到标准输出。
- health CoreDNS自身健康状态报告，默认监听端口8080，一般用来做健康检查。您可以通过http://localhost:8080/health获取健康状态。
- ready CoreDNS插件状态报告，默认监听端口8181，一般用来做可读性检查。可以通过http://localhost:8181/ready获取可读状态。当所有插件都运行后，ready状态为200。
- kubernetes CoreDNS Kubernetes插件，提供集群内服务解析能力。
- prometheus CoreDNS自身metrics数据接口。可以通过http://localhost:9153/metrics获取prometheus格式的监控数据。
- forward（或proxy）将域名查询请求转到预定义的DNS服务器。默认配置中，当域名不在Kubernetes域时，将请求转发到预定义的解析器（/etc/resolv.conf）中。默认使用宿主机的/etc/resolv.conf配置。
- cache DNS缓存。
- loop 环路检测，如果检测到环路，则停止CoreDNS。
- reload 允许自动重新加载已更改的Corefile。编辑ConfigMap配置后，请等待两分钟以使更改生效。
- loadbalance  循环DNS负载均衡器，可以在答案中随机A、AAAA、MX记录的顺序。

**CoreDNS的扩展配置**

针对以下不同场景，您可以扩展CoreDNS的配置：

- 场景一：开启日志服务
- 场景二：特定域名使用自定义DNS服务器
- 场景三：外部域名完全使用自建DNS服务器
- 场景四：自定义Hosts
- 场景五：集群外部访问集群内服务
- 场景六：统一域名访问服务或是在集群内对域名的做CNAME解析
- 场景七：禁止CoreDNS对IPv6类型的AAAA记录查询返回
- 场景八：开启ACK One多集群服务功能

## 五、K8s dns源码分析

**Kubernetes 创建 resolv.conf 文件流程分析**

以下是 Kubernetes 源码中 dns 创建的逻辑：

```
// SetupDNSinContainerizedMounter replaces the nameserver in containerized-mounter's rootfs/etc/resolv.conf with kubelet.ClusterDNS
func (c *Configurer) SetupDNSinContainerizedMounter(mounterPath string) {
	resolvePath := filepath.Join(strings.TrimSuffix(mounterPath, "/mounter"), "rootfs", "etc", "resolv.conf")
	dnsString := ""
	for _, dns := range c.clusterDNS {
		dnsString = dnsString + fmt.Sprintf("nameserver %s\n", dns)
	}
	if c.ResolverConfig != "" {
		f, err := os.Open(c.ResolverConfig)
		if err != nil {
			klog.ErrorS(err, "Could not open resolverConf file")
		} else {
			defer f.Close()
			_, hostSearch, _, err := parseResolvConf(f)
			if err != nil {
				klog.ErrorS(err, "Error for parsing the resolv.conf file")
			} else {
				dnsString = dnsString + "search"
				for _, search := range hostSearch {
					dnsString = dnsString + fmt.Sprintf(" %s", search)
				}
				dnsString = dnsString + "\n"
			}
		}
	}
	if err := os.WriteFile(resolvePath, []byte(dnsString), 0600); err != nil {
		klog.ErrorS(err, "Could not write dns nameserver in the file", "path", resolvePath)
	}
}

```

从  c.clusterDNS 获取 dns server， 然后最终写入resolv.conf， 并将其 挂载到 容器的 /etc/resolv.conf 下。

追根溯源， clusterDNS 的源头是在 NewMainKubelet 创建时， 从 配置中获取的， 即 `kubeCfg.ClusterDNS`.

```
func NewMainKubelet(kubeCfg *kubeletconfiginternal.KubeletConfiguration,
	kubeDeps *Dependencies,
	crOptions *config.ContainerRuntimeOptions,
	hostname string,
	hostnameOverridden bool,
	nodeName types.NodeName,
	nodeIPs []net.IP,
	providerID string,
	cloudProvider string,
	certDirectory string,
	rootDirectory string,
	podLogsDirectory string,
	imageCredentialProviderConfigFile string,
	imageCredentialProviderBinDir string,
	registerNode bool,
	registerWithTaints []v1.Taint,
	allowedUnsafeSysctls []string,
	experimentalMounterPath string,
	kernelMemcgNotification bool,
	experimentalNodeAllocatableIgnoreEvictionThreshold bool,
	minimumGCAge metav1.Duration,
	maxPerPodContainerCount int32,
	maxContainerCount int32,
	registerSchedulable bool,
	nodeLabels map[string]string,
	nodeStatusMaxImages int32,
	seccompDefault bool,
) (*Kubelet, error) {
    ···

    	clusterDNS := make([]net.IP, 0, len(kubeCfg.ClusterDNS))
	for _, ipEntry := range kubeCfg.ClusterDNS {
		ip := netutils.ParseIPSloppy(ipEntry)
		if ip == nil {
			klog.InfoS("Invalid clusterDNS IP", "IP", ipEntry)
		} else {
			clusterDNS = append(clusterDNS, ip)
		}
	}
    ···
}
```

## 第三方组件

原生DNS服务治理方面存在不足， 如： 

- 延时，ttl最短只能设置10S导致，dns缓存导致服务地址变更，客户端没法及时拿到最新的地址。
- 不支持服务存活检查，如果后台的某台Web服务器出现故障,DNS服务器仍然会把DNS 请求分配到这台故障服务器上,导致不能响应客户端
- 不能够按照Web服务器的处理能力分配负载｡DNS负载均衡采用的是简单的轮循负载算法,不能区分服务器之间的差异,不能反映服务器的当前运行状态。

**polaris：**

-  服务发现  operator： UI/Polaris-config.  random hostport.   operator 对比自主上报好处： 1 无需创建polaris名字  2 反注册可靠。
-  作为主调  支持agent/side-car 模式部署。



## 参考

- [k8s 服务注册与发现（一）DNS](https://cloud.tencent.com/developer/article/2126509)
- [k8s 服务注册与发现（二）Kubernetes内部域名解析原理](https://cloud.tencent.com/developer/article/2126510)
- [k8s 服务注册与发现（三）CoreDNS](https://cloud.tencent.com/developer/article/2126512)
- [/etc/resolv.conf文件中的search项作用](https://www.cnblogs.com/zhangmingda/p/13663541.html)
- [CoreDNS系列1：Kubernetes内部域名解析原理、弊端及优化方式](https://hansedong.github.io/2018/11/20/9/)
- [Polaris Github](https://github.com/polarismesh/polaris)
- [Polaris Sidecar Github](https://github.com/polarismesh/polaris-sidecar)
- [Polaris DNS 接入](https://polarismesh.cn/docs/%E4%BD%BF%E7%94%A8%E6%8C%87%E5%8D%97/k8s%E5%92%8C%E7%BD%91%E6%A0%BC%E4%BB%A3%E7%90%86/dns%E6%8E%A5%E5%85%A5/)
- [HaProxy 配置DNS srv记录 服务发现](https://www.haproxy.com/documentation/haproxy-configuration-tutorials/dns-resolution/)
- [Cluster DNS: CoreDNS vs Kube-DNS](https://coredns.io/2018/11/27/cluster-dns-coredns-vs-kube-dns/)
- [Cluster DNS: CoreDNS vs KubeDNS 中文](https://juejin.cn/post/6890060925840130061)
- [Kubernetes DNS-Based Service Discovery](https://github.com/kubernetes/dns/blob/master/docs/specification.md)
- [DNS TTL 值理解及配置](https://jaminzhang.github.io/dns/DNS-TTL-Understanding-and-Config/)
