---
layout:     post
title:      "AI网关-Higress部署"
subtitle:   "AI网关-Higress部署"
date:       2025-03-23
author:     "vxiaozhi"
catalog: true
tags:
    - gateway
---

## 部署方式

### 1. 云原生部署

支持 部署到 Kubernetes，或者 本地k8s， 如 Kind。具体参考

- [使用 Helm 进行云原生部署](https://higress.cn/docs/latest/ops/deploy-by-helm/?spm=36971b57.d107700.0.0.23882d89GafqV0)
- [部署到本地k8s，如Kind](https://higress.cn/docs/latest/user/quickstart/?spm=36971b57.d107700.0.0.23882d89GafqV0)

### 2. Docker-Compose部署

参考

- [基于 Docker Compose 进行独立部署](https://higress.cn/docs/latest/ops/deploy-by-docker-compose/?spm=36971b57.d107700.0.0.23882d89GafqV0)


### 3. All-In-One部署

及将所有服务全部打包到一个容器中，并通过 Supervisord 管理。 参考：

- [脱离 K8s 使用](https://higress.cn/docs/latest/user/quickstart/?spm=36971b57.d107700.0.0.23882d89GafqV0)

实例：

```
mkdir higress; cd higress
docker run -d --rm --name higress-ai -v ${PWD}:/data \
        -p 8001:8001 -p 8080:8080 -p 8443:8443  \
        higress-registry.cn-hangzhou.cr.aliyuncs.com/higress/all-in-one:latest
```

### 4. 命令行工具：hgctl 部署

hgctl 是一个命令行工具，用于管理 Higress 的配置，如：

- 提供多种安装方式，简化安装过程，支持本地部署，Kubernetes 部署，以及 Docker Compose 部署。
- 除了提供安装功能外，也支持插件管理，配置查看等。

参考：

- [hgctl 工具使用说明](https://higress.cn/docs/latest/ops/hgctl/?spm=36971b57.d107700.0.0.23882d89GafqV0)

## 部署实践

### 关于 Higress Chat 包的信息。

**如何知道 Higress Chat 包有哪些版本**

```
helm repo add higress.io https://higress.io/helm-charts
helm search repo  higress.io/higress  --versions
```
higress 当前最新版本为：2.0.7
```
% helm search repo   higress.io/higress  --versions
NAME                      	CHART VERSION	APP VERSION	DESCRIPTION
higress.io/higress        	2.0.7        	2.0.7      	Helm chart for deploying Higress gateways
higress.io/higress        	2.0.6        	2.0.6      	Helm chart for deploying Higress gateways
higress.io/higress        	2.0.5        	2.0.5      	Helm chart for deploying Higress gateways
higress.io/higress        	2.0.4        	2.0.4      	Helm chart for deploying Higress gateways
higress.io/higress        	2.0.3        	2.0.3      	Helm chart for deploying Higress gateways
higress.io/higress        	2.0.2        	2.0.2      	Helm chart for deploying Higress gateways
higress.io/higress        	2.0.1        	2.0.1      	Helm chart for deploying Higress gateways
higress.io/higress        	2.0.0        	2.0.0      	Helm chart for deploying Higress gateways
higress.io/higress        	1.4.2        	1.4.2      	Helm chart for deploying Higress gateways
higress.io/higress        	1.4.1        	1.4.1      	Helm chart for deploying Higress gateways
higress.io/higress        	1.4.0        	1.4.0      	Helm chart for deploying Higress gateways
higress.io/higress        	1.3.6        	1.3.6      	Helm chart for deploying Higress gateways
higress.io/higress        	1.3.5        	1.3.5      	Helm chart for deploying Higress gateways
higress.io/higress        	1.3.4        	1.3.4      	Helm chart for deploying Higress gateways
higress.io/higress        	1.3.3        	1.3.3      	Helm chart for deploying Higress gateways
higress.io/higress        	1.3.2        	1.3.2      	Helm chart for deploying Higress gateways
higress.io/higress        	1.3.1        	1.3.1      	Helm chart for deploying Higress gateways
higress.io/higress        	1.3.0        	1.3.0      	Helm chart for deploying Higress gateways
higress.io/higress        	1.2.0        	1.2.0      	Helm chart for deploying Higress gateways
higress.io/higress        	1.1.2        	1.1.2      	Helm chart for deploying Higress gateways
higress.io/higress        	1.1.1        	1.1.1      	Helm chart for deploying Higress gateways
higress.io/higress        	1.1.0        	1.1.0      	Helm chart for deploying Higress gateways
higress.io/higress        	1.0.1        	1.0.1      	Helm chart for deploying Higress gateways
higress.io/higress        	1.0.0        	1.0.0      	Helm chart for deploying Higress gateways
higress.io/higress        	0.7.4        	0.7.4      	Helm chart for deploying Higress gateways
higress.io/higress        	0.7.3        	0.7.3      	Helm chart for deploying higress gateways
higress.io/higress        	0.7.2        	0.7.2      	Helm chart for deploying higress gateways
higress.io/higress        	0.7.1        	0.7.1      	Helm chart for deploying higress gateways
higress.io/higress        	0.7.0        	0.7.0      	Helm chart for deploying higress gateways
higress.io/higress        	0.6.2        	0.6.2      	Helm chart for deploying higress gateways
higress.io/higress        	0.6.1        	0.6.1      	Helm chart for deploying higress gateways
higress.io/higress-console	2.0.4        	2.0.4      	Management console for Higress
higress.io/higress-console	2.0.3        	2.0.3      	Management console for Higress
higress.io/higress-console	2.0.2        	2.0.2      	Management console for Higress
higress.io/higress-console	2.0.1        	2.0.1      	Management console for Higress
higress.io/higress-console	2.0.0        	2.0.0      	Management console for Higress
higress.io/higress-console	1.4.6        	1.4.6      	Management console for Higress
higress.io/higress-console	1.4.5        	1.4.5      	Management console for Higress
higress.io/higress-console	1.4.4        	1.4.4      	Management console for Higress
higress.io/higress-console	1.4.3        	1.4.3      	Management console for Higress
higress.io/higress-console	1.4.2        	1.4.2      	Management console for Higress
higress.io/higress-console	1.4.1        	1.4.1      	Management console for Higress
higress.io/higress-console	1.4.0        	1.4.0      	Management console for Higress
higress.io/higress-console	1.3.3        	1.3.3      	Management console for Higress
higress.io/higress-console	1.3.2        	1.3.2      	Management console for Higress
higress.io/higress-console	1.3.1        	1.3.1      	Management console for Higress
higress.io/higress-console	1.3.0        	1.3.0      	Management console for Higress
higress.io/higress-console	1.2.0        	1.2.0      	Management console for Higress
higress.io/higress-console	1.1.2        	1.1.2      	Management console for Higress
higress.io/higress-console	1.1.1        	1.1.1      	Management console for Higress
higress.io/higress-console	1.1.0        	1.1.0      	Management console for Higress
higress.io/higress-console	1.0.2        	1.0.2      	Management console for Higress
higress.io/higress-console	1.0.1        	1.0.1      	Management console for Higress
higress.io/higress-console	1.0.0        	1.0.0      	Management console for Higress
higress.io/higress-console	0.2.0        	0.2.0      	Management console for Higress
higress.io/higress-console	0.1.1        	0.1.1      	Management console for Higress
higress.io/higress-console	0.1.0        	0.1.0      	Management console for Higress
higress.io/higress-console	0.0.3        	0.0.3      	Management console for Higress
higress.io/higress-console	0.0.2        	0.0.2      	Management console for Higress
higress.io/higress-core   	2.0.7        	2.0.7      	Helm chart for deploying higress gateways
higress.io/higress-core   	2.0.6        	2.0.6      	Helm chart for deploying higress gateways
higress.io/higress-core   	2.0.5        	2.0.5      	Helm chart for deploying higress gateways
higress.io/higress-core   	2.0.4        	2.0.4      	Helm chart for deploying higress gateways
higress.io/higress-core   	2.0.3        	2.0.3      	Helm chart for deploying higress gateways
higress.io/higress-core   	2.0.2        	2.0.2      	Helm chart for deploying higress gateways
higress.io/higress-core   	2.0.1        	2.0.1      	Helm chart for deploying higress gateways
higress.io/higress-core   	2.0.0        	2.0.0      	Helm chart for deploying higress gateways
higress.io/higress-core   	1.4.2        	1.4.2      	Helm chart for deploying higress gateways
higress.io/higress-core   	1.4.1        	1.4.1      	Helm chart for deploying higress gateways
higress.io/higress-core   	1.4.0        	1.4.0      	Helm chart for deploying higress gateways
higress.io/higress-core   	1.3.6        	1.3.6      	Helm chart for deploying higress gateways
higress.io/higress-core   	1.3.5        	1.3.5      	Helm chart for deploying higress gateways
higress.io/higress-core   	1.3.4        	1.3.4      	Helm chart for deploying higress gateways
higress.io/higress-core   	1.3.3        	1.3.3      	Helm chart for deploying higress gateways
higress.io/higress-core   	1.3.2        	1.3.2      	Helm chart for deploying higress gateways
higress.io/higress-core   	1.3.1        	1.3.1      	Helm chart for deploying higress gateways
higress.io/higress-core   	1.3.0        	1.3.0      	Helm chart for deploying higress gateways
higress.io/higress-core   	1.2.0        	1.2.0      	Helm chart for deploying higress gateways
higress.io/higress-core   	1.1.2        	1.1.2      	Helm chart for deploying higress gateways
higress.io/higress-core   	1.1.1        	1.1.1      	Helm chart for deploying higress gateways
higress.io/higress-core   	1.1.0        	1.1.0      	Helm chart for deploying higress gateways
higress.io/higress-core   	1.0.1        	1.0.1      	Helm chart for deploying higress gateways
higress.io/higress-core   	1.0.0        	1.0.0      	Helm chart for deploying higress gateways
higress.io/higress-core   	0.7.4        	0.7.4      	Helm chart for deploying higress gateways
higress.io/higress-core   	0.7.3        	0.7.3      	Helm chart for deploying higress gateways
higress.io/higress-core   	0.7.2        	0.7.2      	Helm chart for deploying higress gateways
higress.io/higress-core   	0.7.1        	0.7.1      	Helm chart for deploying higress gateways
higress.io/higress-core   	0.7.0        	0.7.0      	Helm chart for deploying higress gateways
higress.io/higress-local  	0.6.1        	0.6.1      	Helm chart for deploying higress gateways
```

**如何查看Higress Chart包内容**

```
# 先从私有仓库拉取（需先添加仓库）
helm repo add higress.io https://higress.io/helm-charts

# 拉取Chart
helm pull higress.io/higress --version <版本号> --untar  # --untar参数自动解压

# 如：
helm pull  higress.io/higress --version 2.0.7
```

### 以hgctl部署higress到k8s为例

```
# 安装hgctl
curl -Ls https://raw.githubusercontent.com/alibaba/higress/main/tools/hack/get-hgctl.sh | bash

# 查看默认 profile
hgctl profile dump k8s -o ./k8s.yaml

# 安装， 更多values 参考：https://github.com/alibaba/higress/blob/main/helm/core/values.yaml
hgctl upgrade --set profile=k8s --set gateway.httpPort=80 --set gateway.httpsPort=443 --set global.namespace=higress-gateway --set chart.higress.version=2.0.7 --kubeconfig ./kube_config_xxx.yaml --context xxx \
--set values.higress-core.gateway.hub=mirrors.xxx.com/xxx/higress --set values.higress-core.gateway.tag=2.0.7 \
--set values.higress-core.controller.hub=mirrors.xxx.com/xxx/higress --set values.higress-core.controller.tag=2.0.7 \
--set values.higress-core.pilot.hub=mirrors.xxx.com/xxx/higress --set values.higress-core.pilot.tag=2.0.7 \
--set values.higress-console.image.repository=mirrors.xxx.com/xxx/higress/console --set values.higress-console.image.tag=2.0.4

# 更新， 参数 flags 同 hgctl install
hgctl upgrade [flags]

# Uninstall higress, istioAPI and GatewayAPI from a cluster
hgctl uninstall --purge-resources  --context string --kubeconfig string
```

### 以 Helm 部署higress到k8s为例

```
helm --kubeconfig ./kube_config_xxx.yaml repo add higress.io https://higress.io/helm-charts

helm upgrade --install --kubeconfig ./kube_config_xxx.yaml higress higress.io/higress   --version 2.0.7  -n higress-gateway-test \
--set global.watchNamespace="higress-gateway-test" --set global.ingressClass="higress-test" --set higress-core.gateway.hub=mirrors.xxx.com/xxx/higress \
 --set higress-core.gateway.tag=2.0.7 --set higress-core.controller.hub=mirrors.xxx.com/xxx/higress --set higress-core.controller.tag=2.0.7 \
 --set higress-core.pilot.hub=mirrors.xxx.com/xxx/higress --set higress-core.pilot.tag=2.0.7 
```
**注意**： global.ingressClass global.watchNamespace 这两个参数， 如果要在 一个集群中的多个 namespace 中部署 higress 实例， 那么这两个参数必需设置值，不能使用默认值。

### 调试技巧

- 如何查看 Envoy 展开配置

Envoy 启动是， 会在 localhost:15000 监听，用于 Admin 管理， 通过以下命令dump Envoy 配置。

```
curl http://127.0.0.1:15000/config_dump
```


## 配置

Higress Console 中各项配置本质上就是 K8s 资源

- 路由配置
- 服务来源
- 服务列表
- 域名管理
- 消费者管理
- 插件
- AI 流量入口管理

### 路由配置

每条路由对应 Ingress 下的一个资源对象。

[配置路由执行 gRPC 服务](https://higress.cn/docs/latest/ops/how-tos/grpc-upstream/?spm=36971b57.35684624.0.0.67a94767pTZS2Z)：

```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    nginx.ingress.kubernetes.io/backend-protocol: "GRPC"
  name: ingress-grpc-httpbin
  namespace: default
spec:
  ingressClassName: higress
  rules:
    - host: foo.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: grpc-httpbin-v1
                port:
                  number: 9091
```
  
### 控制台密码

用户名密码作为 Secrets 资源，名为：higress-console，数据格式如下：

```
data:
  adminDisplayName: YWRtaW4=
  adminPassword: YWRtaW4=
  adminUsername: YWRtaW4=
```


