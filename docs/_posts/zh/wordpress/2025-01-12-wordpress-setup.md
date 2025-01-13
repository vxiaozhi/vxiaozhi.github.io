---
layout:     post
title:      "wordpress 安装配置实践"
subtitle:   "wordpress 安装配置实践"
date:       2025-01-12
author:     "vxiaozhi"
catalog: true
tags:
    - web
    - WordPress
---

# wordpress 安装配置实践

有如下几种安装方式：

## 基于 docker-compose 方式

如果在本地测试查看效果，可采用 docker-compose 方式启动， 参考

- [wordpress-docker-compose](https://github.com/nezhar/wordpress-docker-compose)


## 基于 docker 方式

如果 已有 MySQL 服务的情况下， 可采用docker方式：

- [Docker Official Image packaging for WordPress](https://github.com/docker-library/wordpress)
- [docker 启动命令](https://hub.docker.com/_/wordpress/)

该方式 Web 服务器采用的是 Apache.

## 基于 腾讯云 WordPress 6.5.2 应用模板

相比较于前两种方式，该方式， 优点是：

- 一站式集成：集成了 nginx + php-fpm + mysql + 宝塔面板。
- nginx 支持了 systemctl 方式启动，开机自动重启

具体配置如下：

- 系统： Linux VM-0-10-centos 3.10.0-1160.108.1.el7.x86_64
- WordPress	 /usr/local/lighthouse/softwares/wordpress
- Nginx	 /www/server/nginx/
- PHP	/www/server/php
- MariaDB	/www/server/mysql/
- 宝塔Linux面板	 /www

安装并启动docker

```
# 设置Docker的稳定仓库:
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

sudo yum install docker-ce docker-ce-cli containerd.io -y

sudo systemctl start docker

sudo docker run hello-world
```



