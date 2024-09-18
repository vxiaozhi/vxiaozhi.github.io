# K8s dns 技术实现原理


## 基础知识

**记录**

- A 记录
- NS 记录

**解析方式**

- 递归
- 迭代


## Kubernetes内部域名解析原理

### 1. 同一集群同一命名空间下
### 2. 同一集群不同命名空间下
### 3. DNS 记录

## Kubernetes DNS 策略

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
 

## Kubernetes 创建 resolv.conf 文件流程分析

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

## 参考

- [k8s 服务注册与发现（一）DNS](https://cloud.tencent.com/developer/article/2126509)
- [k8s 服务注册与发现（二）Kubernetes内部域名解析原理](https://cloud.tencent.com/developer/article/2126510)
- [k8s 服务注册与发现（三）CoreDNS](https://cloud.tencent.com/developer/article/2126512)
- [/etc/resolv.conf文件中的search项作用](https://www.cnblogs.com/zhangmingda/p/13663541.html)
- [CoreDNS系列1：Kubernetes内部域名解析原理、弊端及优化方式](https://hansedong.github.io/2018/11/20/9/)
- [Polaris Sidecar](https://github.com/polarismesh/polaris-sidecar)
