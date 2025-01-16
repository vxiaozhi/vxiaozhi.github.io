---
layout:     post
title:      "Python Http 客户端库"
subtitle:   "Python Http 客户端库"
date:       2025-01-15
author:     "vxiaozhi"
catalog: true
tags:
    - 编程语言
    - python
    - http
---

## urllib、urllib2

Python2中早期使用的http库 urllib、urllib2 ，给我们提供了许多方便的功能。

## requests

requests 是使用率非常高的 HTTP 库.

异常情况处理说明：

在发送HTTP请求获取数据的过程中，可能会遭遇以下异常:

- 1. 网络异常：网络连接不通、DNS解析失败、连接超时等；
- 2. 请求异常：请求被拒绝、请求超时等；
- 3. 响应异常：响应码不是200、响应内容无法解析等；
- 4. 值异常：返回的数据不对。

前三种异常的处理代码通常是通用的，第4种对于那些响应值里又增加了code值的json，通常也是可以通用的。

示例代码

以下是针对以上异常的样例代码（这些是比较通用的，通常包装成一个通用的工具函数）：

```
import requests

# 网络异常示例
try:
    response = requests.get('http://example.com/api/data')
    # print(response.status_code)
    response.raise_for_status()
    data = response.json()
except requests.exceptions.ConnectionError as e:
    print('网络连接异常: ', e)
except requests.exceptions.Timeout as e:
    print('连接超时: ', e)
except requests.exceptions.RequestException as e:
    print('请求异常: ', e)
except requests.exceptions.HTTPError as e:
    print(f'HTTP错误, 状态码: {e.response.status_code}, {e}')
except ValueError as e:
    print('响应解析异常: ', e)

# 对data数据进行进一步校验，例如如果有统一 返回值结构。。。
```

需要注意的是： `response.raise_for_status()` 为必须，否则 当服务器返回非200状态码时，无法捕获到异常。

## Httpx

但是自从 Python 3.6 之后的内置 asyncio 模块的兴起，异步方式 更加符合大众或业务上的需求。所以新一代 HTTP库 Httpx 应运而生。

它可以同时使用异步和同步方式来发送 HTTP 请求，并且比 requests 更快。它也支持许多 HTTP/2 特性，比如多路复用和服务端推送。

官方API：https://www.python-httpx.org/

该库的特性：

- • 广泛兼容请求的 API。
- • 标准同步接口，但如果需要，可以支持异步。
- • HTTP/1.1和 HTTP/2 支持。
- • 能够直接向WSGI 应用程序或ASGI 应用程序发出请求。
- • 到处都是严格的超时。
- • 完全类型注释。
- • 100% 的测试覆盖率。
