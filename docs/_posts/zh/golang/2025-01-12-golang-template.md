---
layout:     post
title:      "Golang 模板"
subtitle:   "Golang 模板"
date:       2025-01-12
author:     "vxiaozhi"
catalog: true
tags:
    - 编程语言
    - golang
    - template
---

# Golang 模板

## 标准库实现

参考

- [Go标准库：Go template用法详解 ](https://www.cnblogs.com/f-ck-need-u/p/10053124.html)
- [Go标准库：深入剖析Go template ](https://www.cnblogs.com/f-ck-need-u/p/10035768.html)


**踩坑记录**

模板默认会对一些参数进行转义，因此渲染后的字符串可能与预期不符。

如 href 中的变量，被渲染后会经过如下处理：

```html
<a href="/search?q={{.}}">"{{.}}"</a>
```

```html
<a href="/search?q={{. | urlescaper | attrescaper}}">{{. | htmlescaper}}</a>
```

参考stackoverflow 中对该问题说明：

- [go-rendering-url-rowquery-string-in-a-template-different-behaviours](https://stackoverflow.com/questions/44800093/go-rendering-url-rowquery-string-in-a-template-different-behaviours)
- [template](https://pkg.go.dev/html/template)

## pongo2

- [pongo2](https://github.com/flosch/pongo2) Django-syntax like template-engine for Go


## 性能

- [Go语言不同模板引擎的性能对比](https://github.com/slinso/goTemplateBenchmark)