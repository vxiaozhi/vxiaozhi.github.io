---
layout:     post
title:      "Golang 常用的程序库"
subtitle:   "Golang 常用的程序库"
date:       2025-01-12
author:     "vxiaozhi"
catalog: true
tags:
    - 编程语言
    - golang
    - library
---

# Golang 常用的程序库

## 通用库

- [lancet（柳叶刀](https://github.com/duke-git/lancet) 是一个全面、高效、可复用的go语言工具函数库。 lancet受到了java apache common包和lodash.js的启发。

## 类型转换

**cast**

cast是一个小巧、实用的类型转换库，用于将一个类型转为另一个类型。 最初开发cast是用在hugo中的。

cast实现了多种常见类型之间的相互转换，返回最符合直觉的结果。例如：

- nil转为string的结果为""，而不是"nil"；
- true转为string的结果为"true"，而true转为int的结果为1；
- interface{}转为其他类型，要看它里面存储的值类型。

参考：

- [cast](https://github.com/spf13/cast) Easy and safe casting from one type to another in Go, 用于安全类型转换。
- [Go 每日一库之 cast](https://darjun.github.io/2020/01/20/godailylib/cast/)

## 进程相关

- [tableflip](https://github.com/cloudflare/tableflip) Graceful process restarts in Go 【用于服务进程优雅停止】

## 任务相关

- [gocraft/work](https://github.com/gocraft/work) Process background jobs in Go

## 网络相关

- [google/GoPacket](https://github.com/google/gopacket) Provides packet processing capabilities for Go
