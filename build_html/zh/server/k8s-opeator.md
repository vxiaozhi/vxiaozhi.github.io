# Kubernetes CRD 和 Operator

CRD的全称是CustomResourceDefinition, 是Kubernetes为提高可扩展性，让开发者去自定义资源（如Deployment，StatefulSet等）的一种方法.

```
Operator = CRD + Controller
```

CRD仅仅是资源的定义，而Controller可以去监听CRD的CRUD事件来添加自定义业务逻辑。

如果说只是对CRD实例进行CRUD的话，不需要Controller也是可以实现的，只是只有数据，没有针对数据的操作。

## 参考

- [Kubernetes CRD 和 Operator](https://github.com/chenzongshu/Kubernetes/blob/master/Kubernetes%20CRD%E5%92%8COperator.md)
- [Kubernetes Controller 机制详解（一）](https://www.zhaohuabing.com/post/2023-03-09-how-to-create-a-k8s-controller/)
