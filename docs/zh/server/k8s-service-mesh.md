# k8s 服务网格（Service Mesh）

希腊语言中大概是风帆的意思， 发音  [iːst'iəʊ] ，相当于中文的 伊斯特亿欧。

如果用一句话来解释什么是服务网格，可以将它比作是应用程序或者说微服务间的 TCP/IP，负责服务之间的网络调用、限流、熔断和监控。

服务网格有如下几个特点：

- 应用程序间通讯的中间层
- 轻量级网络代理
- 应用程序无感知
- 解耦应用程序的重试/超时、监控、追踪和服务发现

所以可以看出，服务网格并没有带来新的东西， 服务网格的本质还是：服务治理。

那既然服务治理，用传统的方式也是能实现的， 为什么要引入 服务网格呢？ 下面从 服务网格的演变说起。


## 有哪些产品

[这里 The Service Mesh Landscape](https://layer5.io/service-mesh-landscape) 列出了业界最流行的服务网格产品。


- Linkerd	是一款高性能网络代理程序，标志着Service Mesh时代的开始。 [linkerd2 github](https://github.com/linkerd/linkerd2)
- Istio	底层为Envoy（由C++开发的，为云原生应用而设计，是一款高性能的网络代理），是Service Mesh的典型实现 [istio github](https://github.com/istio/istio)
- Kuma	是一款基于Envoy构建的服务网络控制平面，Kuma设计的数据平面和控制平面可以极大的降低开发团队使用服务网格的难度。[kuma github](https://github.com/kumahq/kuma)
- SOFAMesh SOFAMesh由蚂蚁金服开源，在兼容Istio整体架构和协议的基础上，做出部分调整：使用Go语言开发全新的Sidecar，替代Envoy。 [sofa-mesh github](https://github.com/sofastack/sofa-mesh)


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


## 服务网格架构演进

- 参考 [ServiceMesh 采纳和演进](https://hezhiqiang.gitbook.io/kubernetes-handbook/ling-yu-ying-yong/service-mesh/the-enterprise-path-to-service-mesh-architectures/service-mesh-adoption-and-evolution)

### 1. 客户端库模式

这个阶段可以认为是 服务网格的雏形，出现了一些 胖客户端 的库，如：
- twitter 开发的 [Finagle](https://github.com/twitter/finagle)
- Netflix 开发的 [Hystrix](https://github.com/Netflix/Hystrix)
- Google 的 [Stubby]([https://github.com/getdnsapi/stubby](https://www.iminho.me/wiki/docs/grpc-cloud-native-go-and-java/grpc-cloud-native-go-and-java-1f07n63dblm47))-gRPC的前身
- Tencent 的 [Trpc](https://github.com/trpc-group/trpc-go) 

### 2. Ingress或边缘代理

### 3. 路由器网格

### 4. Proxy per Node

### 5. Sidecar代理/Fabric模型

### 6. Sidecar代理/控制平面



## Istio

Istio是由Google、IBM和Lyft开源的微服务管理、保护和监控框架。Istio为希腊语，意思是”起航“。

- [Istio 详细介绍](k8s-service-mesh-istio.md)


## 参考

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
