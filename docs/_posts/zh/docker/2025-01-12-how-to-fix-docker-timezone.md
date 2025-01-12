---
layout:     post
title:      "Docker容器时间如何与宿主机同步问题解决方案"
subtitle:   "Docker容器时间如何与宿主机同步问题解决方案"
date:       2025-01-12
author:     "vxiaozhi"
catalog: true
tags:
    - docker
---

# Docker容器时间如何与宿主机同步问题解决方案

宿主机设置了时区，而Docker容器并没有设置，会导致导致两者相差8小时
一般来说， 原因是docker 和宿主机所采用的时区不一样。 

- 宿主机采用：CST应该是指（China Shanghai Time，东八区时间）
- Docker采用：UTC应该是指（Coordinated Universal Time，标准时间）

所以，必须统一两者的时区

**docker run 添加时间参数**

```
-v /etc/localtime:/etc/localtime

# 实例1
docker run -p 3306:3306 --name mysql -v /etc/localtime:/etc/localtime
```


**Dockerfile**

```
方法1
# 添加时区环境变量，亚洲，上海
ENV TimeZone=Asia/Shanghai
# 使用软连接，并且将时区配置覆盖/etc/timezone
RUN ln -snf /usr/share/zoneinfo/$TimeZone /etc/localtime && echo $TimeZone > /etc/timezone

# 方法2
# CentOS
RUN echo "Asia/shanghai" > /etc/timezone
# Ubuntu
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
```

**docker-compose**

```
第一种方式(推荐)：
environment:
  TZ: Asia/Shanghai
  
#第二种方式：
environment:
  SET_CONTAINER_TIMEZONE=true
  CONTAINER_TIMEZONE=Asia/Shanghai

#第三种方式：
volumes:
  - /etc/timezone:/etc/timezone
  - /etc/localtime:/etc/localtime
```


**宿主机直接执行命令给某个容器同步时间**

```
方法1：直接在宿主机操作
docker cp /etc/localtime 【容器ID或者NAME】:/etc/localtime
docker cp -L /usr/share/zoneinfo/Asia/Shanghai 【容器ID或者NAME】:/etc/localtime

# 方法2：登录容器同步时区timezone
ln -sf /usr/share/zoneinfo/Asia/Singapore /etc/localtime
```
