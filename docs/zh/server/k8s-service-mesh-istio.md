# k8s 服务网格（Service Mesh）

希腊语言中大概是风帆的意思， 发音  [iːst'iəʊ] ，相当于中文的 伊斯特亿欧。

## 1. 为何使用服务网格？(Why)

- 服务网格并没有给我们带来新功能，它是用于解决其他工具已经解决过的问题，只不过这次是在云原生的  Kubernetes 环境下的实现。
-  MVC 三层 Web 应用程序架构下，服务之间的通讯并不复杂，在应用程序内部自己管理即可，但是在现今的复杂的大型网站情况下，单体应用被分解为众多的微服务，服务之间的依赖和通讯十分复杂，出现了 Twitter 开发的 Finagle、Netflix 开发的 Hystrix 和 Google 的 Stubby 这样的 ”胖客户端“ 库，这些就是早期的服务网格，但是它们都近适用于特定的环境和特定的开发语言，并不能作为平台级的服务网格支持。
- 在云原生架构下，容器的使用给予了异构应用程序的更多可行性， Kubernetes 增强的应用的横向扩容能力，用户可以快速的编排出复杂环境、复杂依赖关系的应用程序，同时开发者又无须过分关心应用程序的监控、扩展性、服务发现和分布式追踪这些繁琐的事情而专注于程序开发，赋予开发者更多的创造性。


## 2. 简介(What)

服务网格有如下几个特点：

- 应用程序间通讯的中间层
- 轻量级网络代理
- 应用程序无感知
- 解耦应用程序的重试/超时、监控、追踪和服务发现


如果用一句话来解释什么是服务网格，可以将它比作是应用程序或者说微服务间的 TCP/IP，负责服务之间的网络调用、限流、熔断和监控。对于编写应用程序来说一般无须关心 TCP/IP 这一层（比如通过 HTTP 协议的 RESTful 应用），同样使用服务网格也就无须关系服务之间的那些原来是通过应用程序或者其他框架实现的事情，比如 Spring Cloud、OSS，现在只要交给服务网格就可以了。

服务网格会在每个 pod 中注入一个 sidecar 代理，该代理对应用程序来说是透明，所有应用程序间的流量都会通过它，所以对应用程序流量的控制都可以在服务网格中实现。

Service mesh 的架构如下图所示：

![](https://wmxiaozhi.github.io/picx-images-hosting/picx-imgs/k8s-net/service-mesh-arch.png)

图片来自：[Pattern: Service Mesh](https://philcalcado.com/2017/08/03/pattern_service_mesh.html)

Service mesh 作为 sidecar 运行，对应用程序来说是透明，所有应用程序间的流量都会通过它，所以对应用程序流量的控制都可以在 serivce mesh 中实现。


鉴于服务之间只通过旁车代理进行通信，我们最终得到了类似下面图示的部署：

![](https://wmxiaozhi.github.io/picx-images-hosting/picx-imgs/k8s-net/service-mesh-mesh.png)

这张图也很形象说明了为什么叫 “服务网格”。

Service Mesh中分为控制平面和数据平面：

**控制平面特点**

- 不直接解析数据包

- 与控制平面中的代理通信，下发策略和配置

- 负责网络行为的可视化

- 通常提供API或者命令行工具可用于配置版本化管理，便于持续集成和部署



**数据平面的特点**

- 通常是按照无状态目标设计的，但实际上为了提高流量转发性能，需要缓存一些数据，因此无状态也是有争议的

- 直接处理入站和出站数据包，转发、路由、健康检查、负载均衡、认证、鉴权、产生监控数据等

- 对应用来说透明，即可以做到无感知部署


**服务网格的工作流程**

- 控制平面将整个网格中的服务配置推送到所有节点的 sidecar 代理中。
- Sidecar 代理将服务请求路由到目的地址，根据中的参数判断是到生产环境、测试环境还是 staging 环境中的服务（服务可能同时部署在这三个环境中），是路由到本地环境还是公有云环境？所有的这些路由信息可以动态配置，可以是全局配置也可以为某些服务单独配置。
- 当 sidecar 确认了目的地址后，将流量发送到相应服务发现端点，在  Kubernetes 中是 service，然后 service 会将服务转发给后端的实例。
- Sidecar 根据它观测到最近请求的延迟时间，选择出所有应用程序的实例中响应最快的实例。
- Sidecar 将请求发送给该实例，同时记录响应类型和延迟数据。
- 如果该实例挂了、不响应了或者进程不工作了，sidecar 将把请求发送到其他实例上重试。
- 如果该实例持续返回 error，sidecar 会将该实例从负载均衡池中移除，稍后再周期性得重试。
- 如果请求的截止时间已过，sidecar 主动失败该请求，而不是再次尝试添加负载。
- Sidecar 以 metric 和分布式追踪的形式捕获上述行为的各个方面，这些追踪信息将发送到集中 metric 系统。


常见产品(服务网格有哪些实现?)

- Linkerd	是一款高性能网络代理程序，标志着Service Mesh时代的开始。 [linkerd2 github](https://github.com/linkerd/linkerd2)
- Istio	底层为Envoy（由C++开发的，为云原生应用而设计，是一款高性能的网络代理），是Service Mesh的典型实现 [istio github](https://github.com/istio/istio)
- Kuma	是一款基于Envoy构建的服务网络控制平面，Kuma设计的数据平面和控制平面可以极大的降低开发团队使用服务网格的难度。[kuma github](https://github.com/kumahq/kuma)
- SOFAMesh SOFAMesh由蚂蚁金服开源，在兼容Istio整体架构和协议的基础上，做出部分调整：使用Go语言开发全新的Sidecar，替代Envoy。 [sofa-mesh github](https://github.com/sofastack/sofa-mesh)

## 3. Istio

Istio是由Google、IBM和Lyft开源的微服务管理、保护和监控框架。Istio为希腊语，意思是”起航“。

Istio中的各个组件和一些关键信息请参考下面的mindmap。

![](https://wmxiaozhi.github.io/picx-images-hosting/picx-imgs/k8s-net/istio-mindmap.png)

### Istio 架构

下面是Istio的架构图。

![](https://wmxiaozhi.github.io/picx-images-hosting/picx-imgs/k8s-net/istio-arch.avif)

Istio架构分为控制平面和数据平面。

- 数据平面：由一组智能代理（Envoy）作为sidecar部署，协调和控制所有microservices之间的网络通信。

- 控制平面：负责管理和配置代理路由流量，以及在运行时执行的政策。

一些组件说明：

- **Envoy**
Istio使用Envoy代理的扩展版本，该代理是以C++开发的高性能代理，用于调解service mesh中所有服务的所有入站和出站流量。 Istio利用了Envoy的许多内置功能，例如动态服务发现，负载平衡，TLS终止，HTTP/2＆gRPC代理，断路器，运行状况检查，基于百分比的流量拆分分阶段上线，故障注入和丰富指标。

Envoy在kubernetes中作为pod的sidecar来部署。 这允许Istio将大量关于流量行为的信号作为属性提取出来，这些属性又可以在Mixer中用于执行策略决策，并发送给监控系统以提供有关整个mesh的行为的信息。 Sidecar代理模型还允许你将Istio功能添加到现有部署中，无需重新构建或重写代码。

- **Mixer**
Mixer负责在service mesh上执行访问控制和使用策略，并收集Envoy代理和其他服务的遥测数据。代理提取请求级属性，发送到mixer进行评估。有关此属性提取和策略评估的更多信息，请参见Mixer配置。 混音器包括一个灵活的插件模型，使其能够与各种主机环境和基础架构后端进行接口，从这些细节中抽象出Envoy代理和Istio管理的服务。

- **Istio Manager**
Istio-Manager用作用户和Istio之间的接口，收集和验证配置，并将其传播到各种Istio组件。它从Mixer和Envoy中抽取环境特定的实现细节，为他们提供独立于底层平台的用户服务的抽象表示。 此外，流量管理规则（即通用4层规则和七层HTTP/gRPC路由规则）可以在运行时通过Istio-Manager进行编程。

- **Istio-auth**
Istio-Auth提供强大的服务间和最终用户认证，使用相互TLS，内置身份和凭据管理。它可用于升级service mesh中的未加密流量，并为运营商提供基于服务身份而不是网络控制的策略的能力。 Istio的未来版本将增加细粒度的访问控制和审计，以使用各种访问控制机制（包括属性和基于角色的访问控制以及授权hook）来控制和监控访问你服务、API或资源的人员。

### 3.1. 应用示例 Bookinfo Sample

Istio 代码中提供了一个 图书信息应用的示例 Bookinfo Sample 用来测试, 可以参考其代码和文档 [Bookinfo Sample github](https://github.com/istio/istio/tree/master/samples/bookinfo) 进行部署。

该微服务用到的镜像有：

```
istio/examples-bookinfo-details-v1
istio/examples-bookinfo-ratings-v1
istio/examples-bookinfo-reviews-v1
istio/examples-bookinfo-reviews-v2
istio/examples-bookinfo-reviews-v3
istio/examples-bookinfo-productpage-v1
```

该应用架构图如下：

![](https://wmxiaozhi.github.io/picx-images-hosting/picx-imgs/k8s-net/istio-sample-bookinfo.avif)



其主页面可以使用 http://IP:32000/productpage 来访问。

![](https://wmxiaozhi.github.io/picx-images-hosting/picx-imgs/k8s-net/istio-bookinfo-page.avif)


#### 监控

不断刷新productpage页面，将可以在以下几个监控中看到如下界面。

**Grafana页面**

`http://grafana.istio.io`

![](https://wmxiaozhi.github.io/picx-images-hosting/picx-imgs/k8s-net/istio-bookinfo-grafana.webp)



**Prometheus页面**

`http://prometheus.istio.io`

![](https://wmxiaozhi.github.io/picx-images-hosting/picx-imgs/k8s-net/istio-bookinfo-prometheus.webp)

**Zipkin页面**

`http://zipkin.istio.io`

![](https://wmxiaozhi.github.io/picx-images-hosting/picx-imgs/k8s-net/istio-bookinfo-zipkin.webp)


**ServiceGraph页面**

`http://servicegraph.istio.io/dotviz`

可以用来查看服务间的依赖关系, 类似于链路追踪。

访问`http://servicegraph.istio.io/graph` 可以获得json格式的返回结果。

![](https://wmxiaozhi.github.io/picx-images-hosting/picx-imgs/k8s-net/istio-bookinfo-servicegraph.avif)



### 3.2. 深入理解Istio Service Mesh中的Envoy Sidecar注入与流量劫持

#### 3.2.1. Sidecar注入

我们看下 Istio 官方示例 bookinfo 中 productpage 的 YAML 配置，关于 bookinfo 应用的详细 YAML 配置请参考 [bookinfo.yaml](https://github.com/rootsongjc/kubernetes-vagrant-centos-cluster/blob/master/yaml/istio-bookinfo/bookinfo.yaml)。

```
apiVersion: v1
kind: Service
metadata:
  name: productpage
  labels:
    app: productpage
spec:
  ports:
  - port: 9080
    name: http
  selector:
    app: productpage
---
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: productpage-v1
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: productpage
        version: v1
    spec:
      containers:
      - name: productpage
        image: istio/examples-bookinfo-productpage-v1:1.8.0
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 9080

```

注入 sidecar 之后的配置。

```
$ istioctl kube-inject -f yaml/istio-bookinfo/bookinfo.yaml
```

我们只截取其中与 productpage 相关的 Service 和 Deployment 配置部分。

```
apiVersion: v1
kind: Service
metadata:
  name: productpage
  labels:
    app: productpage
spec:
  ports:
  - port: 9080
    name: http
  selector:
    app: productpage
---
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  creationTimestamp: null
  name: productpage-v1
spec:
  replicas: 1
  strategy: {}
  template:
    metadata:
      annotations:
        sidecar.istio.io/status: '{"version":"fde14299e2ae804b95be08e0f2d171d466f47983391c00519bbf01392d9ad6bb","initContainers":["istio-init"],"containers":["istio-proxy"],"volumes":["istio-envoy","istio-certs"],"imagePullSecrets":null}'
      creationTimestamp: null
      labels:
        app: productpage
        version: v1
    spec:
      containers:
      - image: istio/examples-bookinfo-productpage-v1:1.8.0
        imagePullPolicy: IfNotPresent
        name: productpage
        ports:
        - containerPort: 9080
        resources: {}
      - args:
        - proxy
        - sidecar
        - --configPath
        - /etc/istio/proxy
        - --binaryPath
        - /usr/local/bin/envoy
        - --serviceCluster
        - productpage
        - --drainDuration
        - 45s
        - --parentShutdownDuration
        - 1m0s
        - --discoveryAddress
        - istio-pilot.istio-system:15007
        - --discoveryRefreshDelay
        - 1s
        - --zipkinAddress
        - zipkin.istio-system:9411
        - --connectTimeout
        - 10s
        - --statsdUdpAddress
        - istio-statsd-prom-bridge.istio-system:9125
        - --proxyAdminPort
        - "15000"
        - --controlPlaneAuthPolicy
        - NONE
        env:
        - name: POD_NAME
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
        - name: POD_NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
        - name: INSTANCE_IP
          valueFrom:
            fieldRef:
              fieldPath: status.podIP
        - name: ISTIO_META_POD_NAME
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
        - name: ISTIO_META_INTERCEPTION_MODE
          value: REDIRECT
        image: jimmysong/istio-release-proxyv2:1.0.0
        imagePullPolicy: IfNotPresent
        name: istio-proxy
        resources:
          requests:
            cpu: 10m
        securityContext:
          privileged: false
          readOnlyRootFilesystem: true
          runAsUser: 1337
        volumeMounts:
        - mountPath: /etc/istio/proxy
          name: istio-envoy
        - mountPath: /etc/certs/
          name: istio-certs
          readOnly: true
      initContainers:
      - args:
        - -p
        - "15001"
        - -u
        - "1337"
        - -m
        - REDIRECT
        - -i
        - '*'
        - -x
        - ""
        - -b
        - 9080,
        - -d
        - ""
        image: jimmysong/istio-release-proxy_init:1.0.0
        imagePullPolicy: IfNotPresent
        name: istio-init
        resources: {}
        securityContext:
          capabilities:
            add:
            - NET_ADMIN
          privileged: true
      volumes:
      - emptyDir:
          medium: Memory
        name: istio-envoy
      - name: istio-certs
        secret:
          optional: true
          secretName: istio.default
status: {}
```

我们看到 Service 的配置没有变化，所有的变化都在 Deployment 里，Istio 给应用 Pod 注入的配置主要包括：

- Init 容器 istio-init：用于给 Sidecar 容器即 Envoy 代理做初始化，设置 iptables 端口转发
- Envoy sidecar 容器 istio-proxy：运行 Envoy 代理

接下来将分别解析下这两个容器。

**Init 容器**

Init 容器的启动入口是 /usr/local/bin/istio-iptables.sh 脚本，该脚本的用法如下：

```
$ istio-iptables.sh -p PORT -u UID -g GID [-m mode] [-b ports] [-d ports] [-i CIDR] [-x CIDR] [-h]
  -p: 指定重定向所有 TCP 流量的 Envoy 端口（默认为 $ENVOY_PORT = 15001）
  -u: 指定未应用重定向的用户的 UID。通常，这是代理容器的 UID（默认为 $ENVOY_USER 的 uid，istio_proxy 的 uid 或 1337）
  -g: 指定未应用重定向的用户的 GID。（与 -u param 相同的默认值）
  -m: 指定入站连接重定向到 Envoy 的模式，“REDIRECT” 或 “TPROXY”（默认为 $ISTIO_INBOUND_INTERCEPTION_MODE)
  -b: 逗号分隔的入站端口列表，其流量将重定向到 Envoy（可选）。使用通配符 “*” 表示重定向所有端口。为空时表示禁用所有入站重定向（默认为 $ISTIO_INBOUND_PORTS）
  -d: 指定要从重定向到 Envoy 中排除（可选）的入站端口列表，以逗号格式分隔。使用通配符“*” 表示重定向所有入站流量（默认为 $ISTIO_LOCAL_EXCLUDE_PORTS）
  -i: 指定重定向到 Envoy（可选）的 IP 地址范围，以逗号分隔的 CIDR 格式列表。使用通配符 “*” 表示重定向所有出站流量。空列表将禁用所有出站重定向（默认为 $ISTIO_SERVICE_CIDR）
  -x: 指定将从重定向中排除的 IP 地址范围，以逗号分隔的 CIDR 格式列表。使用通配符 “*” 表示重定向所有出站流量（默认为 $ISTIO_SERVICE_EXCLUDE_CIDR）。

环境变量位于 $ISTIO_SIDECAR_CONFIG（默认在：/var/lib/istio/envoy/sidecar.env）
```

该容器存在的意义就是让 Envoy 代理可以拦截所有的进出 Pod 的流量，即将入站流量重定向到 Sidecar，再拦截应用容器的出站流量经过 Sidecar 处理后再出站。

这条启动命令的作用是：

- 将应用容器的所有流量都转发到 Envoy 的 15001 端口。

- 使用 istio-proxy 用户身份运行， UID 为 1337，即 Envoy 所处的用户空间，这也是 istio-proxy 容器默认使用的用户，见 YAML 配置中的 runAsUser 字段。

- 使用默认的 REDIRECT 模式来重定向流量。

- 将所有出站流量都重定向到 Envoy 代理。

- 将所有访问 9080 端口（即应用容器 productpage 的端口）的流量重定向到 Envoy 代理。

因为 Init 容器初始化完毕后就会自动终止，因为我们无法登陆到容器中查看 iptables 信息，但是 Init 容器初始化结果会保留到应用容器和 Sidecar 容器中。

**Envoy sidecar 容器**

- 为了查看 iptables 配置，我们需要登陆到 Sidecar 容器中使用 root 用户来查看，因为 kubectl 无法使用特权模式来远程操作 docker 容器.
- 查看 iptables 配置，列出 NAT（网络地址转换）表的所有规则，因为在 Init 容器启动的时候选择给 istio-iptables.sh 传递的参数中指定将入站流量重定向到 Envoy 的模式为 “REDIRECT”，因此在 iptables 中将只有 NAT 表的规格配置.


#### 3.2.2. 流量劫持

流量劫持是通过 iptables 转发实现的。

iptables 是 Linux 内核中的防火墙软件 netfilter 的管理工具，位于用户空间，同时也是 netfilter 的一部分。Netfilter 位于内核空间，不仅有网络地址转换的功能，也具备数据包内容修改、以及数据包过滤等防火墙功能。

在了解 Init 容器初始化的 iptables 之前，我们先来了解下 iptables 和规则配置。

下图展示了 iptables 调用链。

![](https://wmxiaozhi.github.io/picx-images-hosting/picx-imgs/k8s-net/istio-iptables.png)

Init 容器中使用的的 iptables 版本是 v1.6.0，共包含 5 张表(注：在本示例中只用到了 nat 表)：

- raw 用于配置数据包，raw 中的数据包不会被系统跟踪。

- filter 是用于存放所有与防火墙相关操作的默认表。

- nat 用于 网络地址转换（例如：端口转发）。

- mangle 用于对特定数据包的修改（参考损坏数据包）。

- security 用于强制访问控制 网络规则。


Init 容器通过向 iptables nat 表中注入转发规则来劫持流量的，下图显示的是 productpage 服务中的 iptables 流量劫持的详细过程。

![](https://wmxiaozhi.github.io/picx-images-hosting/picx-imgs/k8s-net/istio-iptables-traffic.webp)

Init 容器启动时命令行参数中指定了 REDIRECT 模式，因此只创建了 NAT 表规则，接下来我们查看下 NAT 表中创建的规则，这是全文中的重点部分，前面讲了那么多都是为它做铺垫的。

下面是查看 nat 表中的规则，其中链的名字中包含 ISTIO 前缀的是由 Init 容器注入的，规则匹配是根据下面显示的顺序来执行的，其中会有多次跳转。

```
# 查看 NAT 表中规则配置的详细信息
$ iptables -t nat -L -v
# PREROUTING 链：用于目标地址转换（DNAT），将所有入站 TCP 流量跳转到 ISTIO_INBOUND 链上
Chain PREROUTING (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination
    2   120 ISTIO_INBOUND  tcp  --  any    any     anywhere             anywhere

# INPUT 链：处理输入数据包，非 TCP 流量将继续 OUTPUT 链
Chain INPUT (policy ACCEPT 2 packets, 120 bytes)
 pkts bytes target     prot opt in     out     source               destination

# OUTPUT 链：将所有出站数据包跳转到 ISTIO_OUTPUT 链上
Chain OUTPUT (policy ACCEPT 41146 packets, 3845K bytes)
 pkts bytes target     prot opt in     out     source               destination
   93  5580 ISTIO_OUTPUT  tcp  --  any    any     anywhere             anywhere

# POSTROUTING 链：所有数据包流出网卡时都要先进入POSTROUTING 链，内核根据数据包目的地判断是否需要转发出去，我们看到此处未做任何处理
Chain POSTROUTING (policy ACCEPT 41199 packets, 3848K bytes)
 pkts bytes target     prot opt in     out     source               destination

# ISTIO_INBOUND 链：将所有目的地为 9080 端口的入站流量重定向到 ISTIO_IN_REDIRECT 链上
Chain ISTIO_INBOUND (1 references)
 pkts bytes target     prot opt in     out     source               destination
    2   120 ISTIO_IN_REDIRECT  tcp  --  any    any     anywhere             anywhere             tcp dpt:9080

# ISTIO_IN_REDIRECT 链：将所有的入站流量跳转到本地的 15001 端口，至此成功的拦截了流量到 Envoy 
Chain ISTIO_IN_REDIRECT (1 references)
 pkts bytes target     prot opt in     out     source               destination
    2   120 REDIRECT   tcp  --  any    any     anywhere             anywhere             redir ports 15001

# ISTIO_OUTPUT 链：选择需要重定向到 Envoy（即本地） 的出站流量，所有非 localhost 的流量全部转发到 ISTIO_REDIRECT。为了避免流量在该 Pod 中无限循环，所有到 istio-proxy 用户空间的流量都返回到它的调用点中的下一条规则，本例中即 OUTPUT 链，因为跳出 ISTIO_OUTPUT 规则之后就进入下一条链 POSTROUTING。如果目的地非 localhost 就跳转到 ISTIO_REDIRECT；如果流量是来自 istio-proxy 用户空间的，那么就跳出该链，返回它的调用链继续执行下一条规则（OUPT 的下一条规则，无需对流量进行处理）；所有的非 istio-proxy 用户空间的目的地是 localhost 的流量就跳转到 ISTIO_REDIRECT
Chain ISTIO_OUTPUT (1 references)
 pkts bytes target     prot opt in     out     source               destination
    0     0 ISTIO_REDIRECT  all  --  any    lo      anywhere            !localhost
   40  2400 RETURN     all  --  any    any     anywhere             anywhere             owner UID match istio-proxy
    0     0 RETURN     all  --  any    any     anywhere             anywhere             owner GID match istio-proxy    
    0     0 RETURN     all  --  any    any     anywhere             localhost
   53  3180 ISTIO_REDIRECT  all  --  any    any     anywhere             anywhere

# ISTIO_REDIRECT 链：将所有流量重定向到 Envoy（即本地） 的 15001 端口
Chain ISTIO_REDIRECT (2 references)
 pkts bytes target     prot opt in     out     source               destination
   53  3180 REDIRECT   tcp  --  any    any     anywhere             anywhere             redir ports 15001
```

### 3.3. 深入理解Istio Service Mesh中的Envoy Sidecar代理的路由转发

下面是 Istio 自身组件与 Bookinfo 示例的连接关系图，我们可以看到所有的 HTTP 连接都在 9080 端口监听。

![](https://wmxiaozhi.github.io/picx-images-hosting/picx-imgs/k8s-net/bookinfo-application-traffic-route-and-connections-within-istio-service-mesh-20181226.png)

下图展示的是 productpage 服务请求访问 http://reviews.default.svc.cluster.local:9080/，当流量进入 reviews 服务内部时，reviews 服务内部的 Envoy Sidecar 是如何做流量拦截和路由转发的。可以在 Google Drive 上下载原图。

![](https://wmxiaozhi.github.io/picx-images-hosting/picx-imgs/k8s-net/envoy-sidecar-traffic-interception-20181227.png)


## 4. 总结

**用还是不用**

既然Service Mesh这么好，那到底用还是不用，如果用的话应该什么时候用，应该怎么用？这取决于您的公司的云原生技术的成熟度曲线的位置，服务的规模，业务核心和底层基础设施管理是否适应等。

技术总是在不断向前发展，容器出现后，解决的软件环境和分发的问题；但是如何管理分布式的应用呢，又出现了容器编排软件；容器编排软件解决的微服务的部署问题，但是对于微服务的治理的功能太弱，这才出现了Service Mesh，当然Service Mesh也不是万能的，下一步会走向何方呢？会是Serverless吗？我们拭目以待。

Service Mesh还有一些遗留的问题没有解决或者说比较薄弱的功能：

- 分布式应用的调试，可以参考squash

- 服务拓扑和状态图，可以参考kiali和vistio

- 多租户和多集群的支持

- 白盒监控、支持APM

- 加强负载测试工具slow_cooker、fortio、lago等

- 更高级的fallback路径支持

- 可拔插的证书授权组建，支持外部的CA


下面是采纳Service Mesh之前需要考虑的因素。

| 因素        | 可以考虑使用Service Mesh | 强烈建议使用Service Mesh |
|-------------|------------------------|---------------------------|
| 服务通信    | 基本无需跨服务间的通讯      | 十分要求服务间通讯           |
| 可观察性    | 只关注边缘的指标即可        | 内部服务和边缘指标都要考虑以更好的了解服务的行为 |
| 客户关注    | 主要关注外部API的体验，内外用户是隔离的 | 内部外部用户没有区别体验一致 |
| API的界限   | API主要是作为客户端为客户提供，内部的API与外部是分离的 | API即产品，API就是你的产品能力 |
| 安全模型    | 通过边缘、防火墙可信内部网络的方式控制安全 | 所有的服务都需要认证和鉴权、服务间要加密、zero-trust安全观念 |


## 5. 参考

- [服务网格（Service Mesh ）](https://jimmysong.io/kubernetes-handbook/usecases/service-mesh.html)
- [揭开服务网格～Istio Service Mesh神秘的面纱](https://www.cnblogs.com/ZhuChangwu/p/16464316.html)
- [Istio 服务网格](https://istio.io/latest/zh/about/service-mesh/)
- [服务网格基础](https://jimmysong.io/kubernetes-handbook/usecases/service-mesh-fundamental.html)
- [服务网格对比 API 网关](https://jimmysong.io/kubernetes-handbook/usecases/service-mesh-vs-api-gateway.html)
- [采纳和演进](https://jimmysong.io/kubernetes-handbook/usecases/service-mesh-adoption-and-evolution.html)
- [深入理解Istio Service Mesh中的Envoy Sidecar注入与流量劫持](https://hezhiqiang.gitbook.io/kubernetes-handbook/ling-yu-ying-yong/service-mesh/istio/understand-sidecar-injection-and-traffic-hijack-in-istio-service-mesh)
- [深入理解Istio Service Mesh中的Envoy Sidecar注入与流量劫持 英文原文](https://faun.pub/understanding-how-envoy-sidecar-intercept-and-route-traffic-in-istio-service-mesh-20fea2a78833)
- [Istio流量管理实现机制深度解析](https://www.zhaohuabing.com/post/2018-09-25-istio-traffic-management-impl-intro/)
- [Istio](https://jimmysong.io/kubernetes-handbook/usecases/istio.html)
- [Envoy](https://jimmysong.io/kubernetes-handbook/usecases/envoy.html)
- [Istio基础概念](https://github.com/chenzongshu/Kubernetes/blob/master/Istio/Istio%E5%9F%BA%E7%A1%80%E6%A6%82%E5%BF%B5.md)
- [微服务架构下服务网格的出现带来了什么？](https://www.apiseven.com/blog/what-is-service-mesh)
- [Kubernetes 上的服务网格技术大比较: Istio, Linkerd 和 Consul](https://cloud.tencent.com/developer/article/1628101)
- [什么是服务网格](https://help.aliyun.com/zh/mesh/product-overview/what-is-service-mesh)
- [服务网格终极指南第二版——下一代微服务开发](https://cloudnative.to/blog/service-mesh-ultimate-guide-e2/)
- [使用 docker-compose 模拟 Envoy Service-Mesh ](https://hezhiqiang.gitbook.io/kubernetes-handbook/ling-yu-ying-yong/service-mesh/envoy/envoy-front-proxy)
- [使用 docker-compose 模拟 Envoy Service-Mesh 代码](https://github.com/envoyproxy/examples/tree/main/front-proxy)
- [Envoy mesh 手动部署教程](https://hezhiqiang.gitbook.io/kubernetes-handbook/ling-yu-ying-yong/service-mesh/envoy/envoy-mesh-in-kubernetes-tutorial)
- [Envoy mesh 手动部署教程 英文原文](https://www.getambassador.io/blog/envoy-flask-kubernetes)
- [[Istio是什么？] 还不知道你就out了,一文40分钟快速理解](https://cloud.tencent.com/developer/article/1986019)
- [KubeCon 2021｜使用 eBPF 代替 iptables 优化服务网格数据面性能](https://www.cnblogs.com/tencent-cloud-native/p/15696518.html)
- [Polaris Envoy 网格接入](https://polarismesh.cn/docs/%E4%BD%BF%E7%94%A8%E6%8C%87%E5%8D%97/k8s%E5%92%8C%E7%BD%91%E6%A0%BC%E4%BB%A3%E7%90%86/envoy%E7%BD%91%E6%A0%BC%E6%8E%A5%E5%85%A5/)

**Jimmy Song 2022**

- [为什么 Istio 要使用 SPIRE 做身份认证？](https://jimmysong.io/blog/why-istio-need-spire/)
- [Istio 中的 Sidecar 注入、透明流量劫持及流量路由过程详解 By Jimmy Song 2022](https://jimmysong.io/blog/sidecar-injection-iptables-and-traffic-routing/)
- [Istio 数据平面 Pod 启动过程详解 By Jimmy Song 2022](https://jimmysong.io/blog/istio-pod-process-lifecycle/)
- [理解 Iptables](https://jimmysong.io/blog/understanding-iptables/)
- [[译] 在 Istio 中引入 Wasm 意味着什么？](https://jimmysong.io/trans/importance-of-wasm-in-istio/)
- [如何理解 Istio Ingress，它与 API Gateway 有什么区别？](https://jimmysong.io/blog/istio-servicemesh-api-gateway/)
- [什么是 Istio？为什么 Kubernetes 需要 Istio？](https://jimmysong.io/blog/what-is-istio-and-why-does-kubernetes-need-it/)
