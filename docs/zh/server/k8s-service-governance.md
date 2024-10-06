# K8s 服务治理

微服务治理的手段

- Istio
- Polaris
- [Spring Cloud](https://github.com/spring-cloud)

两者虽然都支持： 路由、熔断、重试 等服务治理手段， 但两者的实现原理完全不同。 区别在于：

Istio 相当于时网关/代理 模式。
Polaris 则是旁路模式。

## 参考

- [万字长文分享腾讯云原生微服务治理实践及企业落地建议](https://mp.weixin.qq.com/s/BCK8WdzUVtJjfqLbAFJLMg)
- [springcloud-learning Spring Cloud组件、微服务项目实战、Kubernetes容器化部署全方位解析](https://github.com/macrozheng/springcloud-learning)
