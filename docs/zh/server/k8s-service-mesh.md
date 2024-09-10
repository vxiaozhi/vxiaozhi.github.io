# k8s 服务网格（Service Mesh）

## 什么是服务网格？

服务网格有如下几个特点：

- 应用程序间通讯的中间层
- 轻量级网络代理
- 应用程序无感知
- 解耦应用程序的重试/超时、监控、追踪和服务发现


如果用一句话来解释什么是服务网格，可以将它比作是应用程序或者说微服务间的 TCP/IP，负责服务之间的网络调用、限流、熔断和监控。对于编写应用程序来说一般无须关心 TCP/IP 这一层（比如通过 HTTP 协议的 RESTful 应用），同样使用服务网格也就无须关系服务之间的那些原来是通过应用程序或者其他框架实现的事情，比如 Spring Cloud、OSS，现在只要交给服务网格就可以了。

服务网格会在每个 pod 中注入一个 sidecar 代理，该代理对应用程序来说是透明，所有应用程序间的流量都会通过它，所以对应用程序流量的控制都可以在服务网格中实现。


## 服务网格的工作流程

- 控制平面将整个网格中的服务配置推送到所有节点的 sidecar 代理中。
- Sidecar 代理将服务请求路由到目的地址，根据中的参数判断是到生产环境、测试环境还是 staging 环境中的服务（服务可能同时部署在这三个环境中），是路由到本地环境还是公有云环境？所有的这些路由信息可以动态配置，可以是全局配置也可以为某些服务单独配置。
- 当 sidecar 确认了目的地址后，将流量发送到相应服务发现端点，在  Kubernetes 中是 service，然后 service 会将服务转发给后端的实例。
- Sidecar 根据它观测到最近请求的延迟时间，选择出所有应用程序的实例中响应最快的实例。
- Sidecar 将请求发送给该实例，同时记录响应类型和延迟数据。
- 如果该实例挂了、不响应了或者进程不工作了，sidecar 将把请求发送到其他实例上重试。
- 如果该实例持续返回 error，sidecar 会将该实例从负载均衡池中移除，稍后再周期性得重试。
- 如果请求的截止时间已过，sidecar 主动失败该请求，而不是再次尝试添加负载。
- Sidecar 以 metric 和分布式追踪的形式捕获上述行为的各个方面，这些追踪信息将发送到集中 metric 系统。


## 为何使用服务网格？

- 服务网格并没有给我们带来新功能，它是用于解决其他工具已经解决过的问题，只不过这次是在云原生的  Kubernetes 环境下的实现。

-  MVC 三层 Web 应用程序架构下，服务之间的通讯并不复杂，在应用程序内部自己管理即可，但是在现今的复杂的大型网站情况下，单体应用被分解为众多的微服务，服务之间的依赖和通讯十分复杂，出现了 Twitter 开发的 Finagle、Netflix 开发的 Hystrix 和 Google 的 Stubby 这样的 ”胖客户端“ 库，这些就是早期的服务网格，但是它们都近适用于特定的环境和特定的开发语言，并不能作为平台级的服务网格支持。

- 在云原生架构下，容器的使用给予了异构应用程序的更多可行性， Kubernetes 增强的应用的横向扩容能力，用户可以快速的编排出复杂环境、复杂依赖关系的应用程序，同时开发者又无须过分关心应用程序的监控、扩展性、服务发现和分布式追踪这些繁琐的事情而专注于程序开发，赋予开发者更多的创造性。


## 常见产品

- Linkerd	是一款高性能网络代理程序，标志着Service Mesh时代的开始。 [linkerd2 github](https://github.com/linkerd/linkerd2)
- Envoy	由C++开发的，为云原生应用而设计，是一款高性能的网络代理 [envoy github](https://github.com/envoyproxy/envoy)
- Istio	底层为Envoy，是Service Mesh的典型实现 [istio github](https://github.com/istio/istio)
- Kuma	是一款基于Envoy构建的服务网络控制平面，Kuma设计的数据平面和控制平面可以极大的降低开发团队使用服务网格的难度。

## 参考

- [服务网格（Service Mesh ）](https://jimmysong.io/kubernetes-handbook/usecases/service-mesh.html)
- [揭开服务网格～Istio Service Mesh神秘的面纱](https://www.cnblogs.com/ZhuChangwu/p/16464316.html)
- [Istio 服务网格](https://istio.io/latest/zh/about/service-mesh/)
- [服务网格基础](https://jimmysong.io/kubernetes-handbook/usecases/service-mesh-fundamental.html)
- [服务网格对比 API 网关](https://jimmysong.io/kubernetes-handbook/usecases/service-mesh-vs-api-gateway.html)
- [采纳和演进](https://jimmysong.io/kubernetes-handbook/usecases/service-mesh-adoption-and-evolution.html)
- [深入理解Istio Service Mesh中的Envoy Sidecar注入与流量劫持](https://hezhiqiang.gitbook.io/kubernetes-handbook/ling-yu-ying-yong/service-mesh/istio/understand-sidecar-injection-and-traffic-hijack-in-istio-service-mesh)
- [Istio](https://jimmysong.io/kubernetes-handbook/usecases/istio.html)
- [Envoy](https://jimmysong.io/kubernetes-handbook/usecases/envoy.html)
- [微服务架构下服务网格的出现带来了什么？](https://www.apiseven.com/blog/what-is-service-mesh)
- [Kubernetes 上的服务网格技术大比较: Istio, Linkerd 和 Consul](https://cloud.tencent.com/developer/article/1628101)
- [什么是服务网格](https://help.aliyun.com/zh/mesh/product-overview/what-is-service-mesh)
- [服务网格终极指南第二版——下一代微服务开发](https://cloudnative.to/blog/service-mesh-ultimate-guide-e2/)
