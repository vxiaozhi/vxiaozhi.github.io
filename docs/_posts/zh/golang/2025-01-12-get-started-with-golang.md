---
layout:     post
title:      "Golang 学习"
subtitle:   "Golang 学习"
date:       2025-01-12
author:     "vxiaozhi"
catalog: true
tags:
    - 编程语言
    - golang
---

# Golang 学习

云风说：

我发现我花了四年时间锤炼自己用 C 语言构建系统的能力，试图找到一个规范，可以更好的编写软件。结果发现只是对 Go 的模仿。缺乏语言层面的支持，只能是一个拙劣的模仿。
参考 [云风的 BLOG: Go 语言初步](https://blog.codingnow.com/2010/11/go_prime.html)

Go学习路线图参考：[ go学习线路图](https://www.topgoer.com/%E5%BC%80%E6%BA%90/go%E5%AD%A6%E4%B9%A0%E7%BA%BF%E8%B7%AF%E5%9B%BE.html)

## 服务开发常用类库选择

### rpc框架

- [trpc-go](https://github.com/trpc-group/trpc-go)

### 可观测

- [opentelemetry-go](https://github.com/open-telemetry/opentelemetry-go)
- [prometheus 接入库](https://github.com/prometheus/client_golang)， 默认自带了 gorouting数目、内存用量 等监控指标

## 开发实践

Go语言中的单例模式
```
package singleton

import (
    "sync"
)

type singleton struct {}

var instance *singleton
var once sync.Once

func GetInstance() *singleton {
    once.Do(func() {
        instance = &singleton{}
    })
    return instance
}

```
## 参考教程

- [go语言介绍](https://www.topgoer.com/)

