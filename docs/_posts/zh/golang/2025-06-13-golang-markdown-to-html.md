---
layout:     post
title:      "Markdown 转换为 HTML 的golang开源项目"
subtitle:   "Markdown 转换为 HTML 的golang开源项目"
date:       2025-06-13
author:     "vxiaozhi"
catalog: true
tags:
    - golang
    - markdown
---

在 Go 语言生态中，有几个优秀的开源项目可以将 Markdown 转换为 HTML。以下是常见的工具和库：

## Goldmark

GitHub: https://github.com/yuin/goldmark

特点：

- 高性能、符合 CommonMark 标准。
- 支持扩展（如表格、任务列表、数学公式等）。
- 被许多知名项目（如 Hugo 静态站点生成器）使用。

```
import "github.com/yuin/goldmark"

md := goldmark.New()
var buf bytes.Buffer
err := md.Convert([]byte("# Hello"), &buf)
html := buf.String()
```

## Blackfriday

GitHub: https://github.com/russross/blackfriday

特点：

- 老牌库，功能稳定。
- 支持 GitHub Flavored Markdown (GFM)。
- 输出支持 HTML 或 LaTeX。

```
import "github.com/russross/blackfriday"

output := blackfriday.Run([]byte("bold text"))
```

## Lute

GitHub: https://github.com/88250/lute

特点：

- 中文开发者维护，支持中文排版优化。
- 支持流程图、数学公式、音视频等扩展。

```
import "github.com/88250/lute"

luteEngine := lute.New()
html := luteEngine.MarkdownStr("demo", "## Heading")
```

## go-markdown

GitHub: https://github.com/gomarkdown/markdown

特点：

- Blackfriday 的维护者新开发的替代品。
- 模块化设计，支持自定义渲染。

```
import "github.com/gomarkdown/markdown"

html := markdown.ToHTML([]byte("code"), nil, nil)
```

## md2html

Github: https://github.com/nocd5/md2html

功能:

- md2html 可将 Markdown 转换为单一 HTML 文件。
- 所有脚本和 CSS 都将内嵌于文件中，因此转换后的文件可离线浏览。
- 此外，md2html 还支持通过 base64 编码将图片嵌入 HTML，从而实现无需外部资源的文件传输。

## markdownd

Markdown 服务器

Github: https://github.com/aerth/markdownd

特点：  

- 默认优先尝试将 .md 文件作为 .html 请求响应（如访问 /index.html 会先查找 /index.md）  
- 若存在同名 .html 文件则直接返回  
- 支持静态文件托管（非 .html/.md 文件时提供下载）  
- 可选目录索引功能（默认关闭，使用 -index=gen 或 -index=README.md 开启）  
- 禁用符号链接与父级路径跳转（../）  
- 支持原始 Markdown 源码请求（示例：GET /index.md?raw）  
- 可指定自定义索引页（参数示例：-index README.md）  
- 通过 -toc 参数自动生成目录结构  
- 通过 -header/-footer 参数实现主题化 HTML   
- 新增语法高亮功能（启用参数：-syntax）
