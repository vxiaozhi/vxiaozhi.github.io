---
layout:     post
title:      "Linux 反弹Shell"
subtitle:   "Linux 反弹Shell"
date:       2025-01-12
author:     "vxiaozhi"
catalog: true
tags:
    - server
---

# Linux 反弹Shell


## 前言

在渗透测试实战中，我们经常会遇到Linux系统环境，而让Linux主机反弹个shell是再常见不过的事情了。

反弹shell，就是攻击机监听在某个TCP/UDP端口为服务端，目标机主动发起请求到攻击机监听的端口，并将其命令行的输入输出转到攻击机。

**正向连接**

假设我们攻击了一台机器，打开了该机器的一个端口，攻击者在自己的机器去连接目标机器（目标ip：目标机器端口），这是比较常规的形式，我们叫做正向连接。远程桌面、web服务、ssh、telnet等等都是正向连接。

**反向连接**

那么为什么要用反弹shell呢？

反弹shell通常适用于如下几种情况：

- 目标机因防火墙受限，目标机器只能发送请求，不能接收请求。
- 目标机端口被占用。
- 目标机位于局域网，或IP会动态变化，攻击机无法直接连接。
- 对于病毒，木马，受害者什么时候能中招，对方的网络环境是什么样的，什么时候开关机，都是未知的。
- ......

对于以上几种情况，我们是无法利用正向连接的，要用反向连接。

那么反向连接就很好理解了，就是攻击者指定服务端，受害者主机主动连接攻击者的服务端程序，即为反向连接。

反弹shell的方式有很多，那具体要用哪种方式还需要根据目标主机的环境来确定，比如目标主机上如果安装有netcat，那我们就可以利用netcat反弹shell，如果具有python环境，那我们可以利用python反弹shell。如果具有php环境，那我们可以利用php反弹shell。



## 参考

- [反弹Shell，看这一篇就够了](https://xz.aliyun.com/t/9488?u_atoken=1a7a62705659211ef639f8e2692c3b1e&u_asig=1a0c399817296127525811237e003e)
- [反弹shell方法汇总](https://github.com/xuanhusec/OscpStudyGroup/blob/master/0x0004-%E5%8F%8D%E5%BC%B9shell%E6%96%B9%E6%B3%95%E6%B1%87%E6%80%BB.md)
- [多种姿势反弹shell](https://brucetg.github.io/2018/05/03/%E5%A4%9A%E7%A7%8D%E5%A7%BF%E5%8A%BF%E5%8F%8D%E5%BC%B9shell/)
