---
layout:     post
title:      "Higress 的OCI扩展插件"
subtitle:   "Higress 的OCI扩展插件"
date:       2025-03-29
author:     "vxiaozhi"
catalog: true
tags:
    - gateway
    - higress
---


## OCI

OCI，Open Container Initiative，是一个轻量级，开放的治理结构（项目），在 Linux 基金会的支持下成立，致力于围绕容器格式和运行时创建开放的行业标准。OCI 项目由 Docker，CoreOS（后来被 Red Hat 收购了，相应的席位被 Red Hat 继承）和容器行业中的其他领导者在 2015 年 6 月的时候启动。OCI 的技术委员会成员包括 Red Hat，Microsoft，Docker，Cruise，IBM，Google，Red Hat 和 SUSE，其中 Docker 公司有两名成员，且其中的一位是现任主席，具体的细节可以查看 OCI Technical Oversight Board。

### OCI Artifacts

伴随着 image spec 与 distribution spec 的演化，人们开始逐步认识到除了 Container Images 之外，Registries 还能够用来分发 Kubernetes Deployment Files, Helm Charts, docker-compose, CNAB 等产物。它们可以共用同一套 API，同一套存储，将 Registries 作为一个云存储系统。这就为带来了 OCI Artifacts 的概念，用户能够把所有的产物都存储在 OCI 兼容的 Registiry 当中并进行分发。为此，Microsoft 将 oras 作为一个 client 端实现捐赠给了社区，包括 Harbor 在内的多个项目都在积极的参与。

### OCI 仓库

- [Harbor](https://github.com/goharbor/harbor) An open source trusted cloud native registry project that stores, signs, and scans content.
- [distribution](https://github.com/distribution/distribution) OCI 仓库开源实现
  
**distribution基本用法**

Start your registry

```
docker run -d -p 5000:5000 --name registry registry:2
```

然后就可以用 docker 命令像推拉普通镜像一样来 操作 OCI 仓库

```
docker image tag ubuntu localhost:5000/myfirstimage
```

Push it

```
docker push localhost:5000/myfirstimage
```

Pull it back
```
docker pull localhost:5000/myfirstimage
```

### OCI 客户端

- [ORAS CLI](https://github.com/oras-project/oras)
- [WASM to OCI](https://github.com/engineerd/wasm-to-oci)
  
**install**

- [源码编译安装](https://oras.land/docs/installation)

或者 Mac 通过 Homebrew 安装

```
brew install oras
```

拉取镜像[默认拉取下来的镜像存储在当前文件夹， 可以通过 -o 参数指定存储位置]

```
oras pull  higress-registry.cn-hangzhou.cr.aliyuncs.com/plugins/ai-proxy:1.0.0
```

推送镜像到本地仓库：
```
oras push --insecure localhost:5000/ai_proxy:v1  \
    ./README.md:application/vnd.module.wasm.doc.v1+markdown \
    ./README_EN.md:application/vnd.module.wasm.doc.v1.en+markdown \
    ./README_dev.md:application/vnd.module.wasm.doc.v1.en+markdown \
    ./plugin.tar.gz:application/vnd.oci.image.layer.v1.tar+gzip
```

查看仓库是否推送成功：

```
# 列出仓库下的所有repo
oras repo ls localhost:5001

# 查看指定repo的所有tag
oras repo tags localhost:5001/ai_proxy
```



## Wasm 插件

Higress 使用 wasm 插件来扩展 Higress 的功能， 并采用 OCI 仓库来管理插件。

- [Wasm 插件镜像规范](https://higress.cn/docs/latest/user/wasm-image-spec/?spm=36971b57.2ef5001f.0.0.2a932c1fS4puA3) 介绍插件格式，插件构建，及使用 oras 命令推拉插件到 OCI 仓库。
- [使用 GO 语言开发 WASM 插件并在本地用Envoy调试](https://higress.cn/docs/latest/user/wasm-go/?spm=36971b57.2ef5001f.0.0.2a932c1fS4puA3)
- [支持的全部 wasm 插件列表](https://github.com/higress-group/higress-console/blob/main/backend/sdk/src/main/resources/plugins/plugins.properties)