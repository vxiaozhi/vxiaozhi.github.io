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

## 云原生部署

支持 部署到 Kubernetes，或者 本地k8s， 如 Kind。具体参考

- [使用 Helm 进行云原生部署](https://higress.cn/docs/latest/ops/deploy-by-helm/?spm=36971b57.d107700.0.0.23882d89GafqV0)
- [部署到本地k8s，如Kind](https://higress.cn/docs/latest/user/quickstart/?spm=36971b57.d107700.0.0.23882d89GafqV0)

## Docker-Compose部署

参考

- [基于 Docker Compose 进行独立部署](https://higress.cn/docs/latest/ops/deploy-by-docker-compose/?spm=36971b57.d107700.0.0.23882d89GafqV0)


## All-In-One部署

及将所有服务全部打包到一个容器中，并通过 Supervisord 管理。 参考：

- [脱离 K8s 使用](https://higress.cn/docs/latest/user/quickstart/?spm=36971b57.d107700.0.0.23882d89GafqV0)

实例：

```
mkdir higress; cd higress
docker run -d --rm --name higress-ai -v ${PWD}:/data \
        -p 8001:8001 -p 8080:8080 -p 8443:8443  \
        higress-registry.cn-hangzhou.cr.aliyuncs.com/higress/all-in-one:latest
```

## 命令行工具：hgctl 部署

hgctl 是一个命令行工具，用于管理 Higress 的配置，如：

- 提供多种安装方式，简化安装过程，支持本地部署，Kubernetes 部署，以及 Docker Compose 部署。
- 除了提供安装功能外，也支持插件管理，配置查看等。

参考：

- [hgctl 工具使用说明](https://higress.cn/docs/latest/ops/hgctl/?spm=36971b57.d107700.0.0.23882d89GafqV0)
  