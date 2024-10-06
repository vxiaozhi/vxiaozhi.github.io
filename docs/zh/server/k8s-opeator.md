# Kubernetes CRD 和 Operator

CRD的全称是CustomResourceDefinition, 是Kubernetes为提高可扩展性，让开发者去自定义资源（如Deployment，StatefulSet等）的一种方法.

```
Operator = CRD(Customer Resource Define) + Controller
```

CRD仅仅是资源的定义，而Controller可以去监听CRD的CRUD事件来添加自定义业务逻辑。

如果说只是对CRD实例进行CRUD的话，不需要Controller也是可以实现的，只是只有数据(只会在etcd内生成这个对象)，没有针对数据的操作。

CR约定了这个资源，或者说是应用将要达到的状态。那如何到达这个状态呢？这个时候，就需要一个Controller负责调和（Reconcile）。

Controller将CR规划的应用蓝图落地，并最终实现CR约定的应用状态。Controller和API Server建立通信，并监听特定CR的创建，销毁和更新事件，并在自己的控制循环内，使用K8S Api完成调和的工作。


## 参考

- [Kubernetes CRD 和 Operator](https://github.com/chenzongshu/Kubernetes/blob/master/Kubernetes%20CRD%E5%92%8COperator.md)
- [Kubernetes Controller 机制详解（一）](https://www.zhaohuabing.com/post/2023-03-09-how-to-create-a-k8s-controller/)
