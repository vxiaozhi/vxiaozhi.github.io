# k8s 暴露服务的方式

## 暴露Service 的三种方式

### 1. NodePort

将服务的类型设置成NodePort-每个集群节点都会在节点上打 开 一个端口， 对于NodePort服务， 每个集群节点在节点本身（因此得名叫 NodePort)上打开一个端口，并将在该端口上接收到的流量重定向到基础服务。
该服务仅在内部集群 IP 和端口上才可访间， 但也可通过所有节点上的专用端口访问。

### 2. LoadBalane

将服务的类型设置成LoadBalance, NodePort类型的一 种扩展，这使得服务可以通过一个专用的负载均衡器来访问， 这是由Kubernetes中正在运行的云基础设施提供的。 负载均衡器将流量重定向到跨所有节点的节点端口。客户端通过负载均衡器的 IP 连接到服务。

### 3.  Ingress

创建一 个Ingress资源， 这是一 个完全不同的机制， 通过一 个IP地址公开多个服务,就是一个网关入口，和springcloud的网关zuul、gateway类似。


## 本地K8s集群暴露方法

### 1. Kubectl Proxy

kubectl proxy是一个Kubernetes命令行工具，用于创建一个本地代理服务器，将本地端口与Kubernetes集群中的API Server进行连接。它可以用来访问Kubernetes API Server提供的REST接口和资源，而无需直接暴露API Server给外部网络。

通过运行kubectl proxy命令，会在本地主机上创建一个HTTP代理服务器，默认监听在127.0.0.1:8001上。通过这个代理服务器，你可以使用curl、wget或浏览器等工具来访问和操作Kubernetes集群中的API资源。

例如，你可以使用以下命令来获取所有Pod列表：

```
curl http://localhost:8001/api/v1/namespaces/default/pods
```

需要注意的是，在生产环境中不建议直接暴露API Server给公共网络，而应该使用安全的方式进行访问控制和认证。kubectl proxy通常在开发、测试和调试环境中使用。

### 2. Kubectl Port-Forward

port-forward 通过端口转发映射本地端口到指定的应用端口.

在需要调试部署的pod、svc等资源是否提供正常访问时使用。

命令格式：

```
kubectl port-forward <pod_name> <forward_port> --namespace <namespace> --address <IP默认：127.0.0.1>
```

## 参考

- [详解kubernetes五种暴露服务的方式](https://www.cnblogs.com/gaoyuechen/p/17318934.html)
- [k8s-(七）暴露服务的三种方式](https://blog.csdn.net/qq_21187515/article/details/112363072)
- [kubectl proxy 作用](https://golang.0voice.com/?id=7330)