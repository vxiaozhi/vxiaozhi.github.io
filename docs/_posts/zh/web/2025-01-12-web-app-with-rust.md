---
layout:     post
title:      "使用 Rust 创建 Web 应用程序"
subtitle:   "使用 Rust 创建 Web 应用程序"
date:       2025-01-12
author:     "vxiaozhi"
catalog: true
tags:
    - web
    - rust
---

# 使用 Rust 创建 Web 应用程序

- [dioxus](https://github.com/DioxusLabs/dioxus)
- [leptos](https://github.com/leptos-rs/leptos)
- [yew](https://github.com/yewstack/yew)

Yew

- 最成熟、应用最广泛
- 类似 JSX 的模板语法
- 类似 React（以前是类似 Elm 的结构组件，现在是类似 React 的函数组件）
- 更多样板文件，例如事件回调、需要将 .clone() 内容放入闭包等。
- 相对较好的性能（比如 Preact/Vue，比 React 更快）
- WASM 二进制大小中等
- 社区维护（即原创者已经丢失）；它维护得很好，审稿人在查看 PR 等方面做得很好，但是（这里主观认为）没有看到太多推动它长期发展的愿景

Dioxus

- 相对较新，发展较快
- 明确地将自己模型/市场为类似 React
- 独特的模板语法（不是 JSX）
- 大量不安全的 rust
- 基于新的 block-DOM 方法，性能非常好（不如React/Yew VDOM 灵活，但性能更高）
- WASM 二进制文件较大
- 非常重视针对桌面/本机 UI

Leptos

- 相对较新，发展较快
- 基于 SolidJS/fine-grained reactivity，没有虚拟 DOM 开销
- 类似 JSX 的模板语法
- 完全安全的 Rust
- 性能非常好；不仅在渲染速度上，而且在内存使用和服务器渲染速度上都优于此处列出的其他产品
- WASM 二进制较小（比 Sycamore 稍大）
- 服务器渲染非常快，并高度重视/支持与服务器的集成，包括多种服务器渲染模式（如有序和无序 HTML 流）

Sycamore

- 比 Dioxus/Leptos 更成熟，发展相对缓慢
- 基于 SolidJS/fine-grained reactivity
- 独特的模板语法（不像 JSX）
- 大量不安全的 rust
- WASM 二进制大小较小
- 性能相当不错，比 Yew 快，比 Dioxus/Leptos 慢，但可能足以满足您的需求
- 主要福利：Perseus 元框架


前端框架性能基准测试 [js-framework-benchmark results for Chrome 130.0.6723.58](https://krausest.github.io/js-framework-benchmark/current.html)

## 参考

  - [前端框架Yew、Dioxus、Leptos、Sycamore区别](https://juejin.cn/post/7282733743911354425)
  - []()
