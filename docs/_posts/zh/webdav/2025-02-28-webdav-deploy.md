---
layout:     post
title:      "WebDAV 搭建方案"
subtitle:   "WebDAV 搭建方案"
date:       2025-02-28
author:     "vxiaozhi"
catalog: true
tags:
    - webdav
---

## Web 服务器方案

借助传统Web服务器使用的WebDAV的方法有多种：

- Apache2 推荐使用 [下载量最多的docker镜像](https://hub.docker.com/r/bytemark/webdav)
- Nginx Nginx和Caddy都需要额外安装模块才能实现最完整的WebDAV功能
  - [docker镜像](https://hub.docker.com/r/ionelmc/webdav)
  - [docker镜像 github](https://github.com/erikluo/docker-webdav/)
- Caddy Nginx和Caddy都需要额外安装模块才能实现最完整的WebDAV功能（下载、上传、修改）

     

## 专用服务器方案

- [Simple Go WebDAV server Go实现](https://github.com/hacdias/webdav)
- [wsgidav python实现 obsidian remotelySync插件指定服务](https://github.com/mar10/wsgidav)

