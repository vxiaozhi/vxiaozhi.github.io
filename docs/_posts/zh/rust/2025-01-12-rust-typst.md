---
layout:     post
title:      "Typst"
subtitle:   "Typst"
date:       2025-01-12
author:     "vxiaozhi"
catalog: true
tags:
    - 编程语言
    - rust
---

# Typst

Typst 是一款专门为排版而生的新生代工具。它完全摒弃了现有系统的约束，着眼于现代化的功能与设计，成功地克服了传统方案上的一些不足之处。

在使用流程上，Typst 和 Latex 的实际使用流程非常相似，总结起来可以用三个步骤概括：

- 配置 Typst 的编辑环境
- 找一份 Typst 的简历模板
- 填充内容及修改模版

## 配置 Typst 的编辑环境

Typst 的环境配置比 Latex 简单了非常多，

- Online editor。Typst 官方提供了一个在线编辑器 typst.app 供用户免费使用，等同于 Latex 在线编辑器 overleaf.com 的存在。在线编辑器需要上传资源和下载文件来交互，对于想要备份简历的同学来说不是很方便，但开箱即用的特点对于小白用户来说特别友好。

- All in vscode。 把全部的开发依赖都交给 vscode 来管理是目前的一种流行开发范式。在 vscode 中需要下载两个插件：Typst LSP 用来给 vscode 提供智能提示，同时它也包含了 typst 的编译器；vscode-pdf 用来在 vscode 中实时预览生成的简历 PDF 文件。

- Advances。 对于高级玩家来说，他们比较喜欢用自己顺手的编辑器。编辑器 + 编译器 + PDF 阅读器分离能够做到最大的自由度，且重用已有的软件。具体可以参考：https://github.com/typst/typst 自行配置。

## 找一份 Typst 的简历模板

站在巨人的肩膀上总是最便捷的方法达到一定的高度，我们制作简历也可以基于网上开源的模板进行修改，从一个布局设计精美的模板开始填入自己的内容。

在 GitHub 上有两个 awesome 项目收纳了很多 typst 的模板。比如：

- https://github.com/qjcg/awesome-typst
- [Awesome Typst 列表中文版](https://github.com/typst-cn/awesome-typst-cn)

使用 Typst 的模板非常简单，最直接的使用方法是从 GitHub 克隆下来整个仓库，通过 typst.app 或者 vscode 打开整个文件夹，然后就能编辑使用了。相比于 Latex 的模板，Typst 不用再安装各种隐藏的宏包，相当于下载了一份 Python 开源代码但不用再安装各种依赖的第三方库就能直接运行了。

## 填充内容及修改模版

在一份优秀的开源模板基础之上，填充内容对于用户来说一般不成问题。

有一个常见的问题是各种简历模板总是在满足原作者的需求上被开发出来的，但是他人的需求并不总是满足自己的需求，因此定制化就成了制作简历里不可缺失的一环。

由于 Typst 的诞生比较晚，Typst 的原生语法相对 Latex 来说非常简单，没有了历史的包袱，Typst 语法语义化程度非常高。比如，我想要修改上面的简历增加 Publication 这个内容，只需要简单参考 Typst 语法的参考文档，很快就能摸索出来正确的写法。


