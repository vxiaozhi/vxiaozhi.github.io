# Vite 学习

Next generation frontend tooling. It's fast!

- [vite github](https://github.com/vitejs/vite) 

## Why

- Vite 通过在一开始将应用中的模块区分为 依赖 和 源码 两类，改进了开发服务器启动时间。
- 在 Vite 中，HMR 是在原生 ESM 上执行的。当编辑一个文件时，Vite 只需要精确地使已编辑的模块与其最近的 HMR 边界之间的链失活[1]（大多数时候只是模块本身），使得无论应用大小如何，HMR 始终能保持快速更新。

## 开始

安装
```
npm install -D vite
```

创建项目
```
npm create vite@latest
```

创建 `index.html` 文件：
```
<p>Hello Vite!</p>
```

运行
```
npx vite
```

构建
```
npm run build
```

## 构建

构建工具逐渐从原始的 js 类的工具逐渐演化成 Rust 实现以便来提升性能。

### 1. ESBuild

- ESBuild： 只在开发中预打包一些依赖，但 Vite 不会在生产构建中使用 esbuild 作为打包工具。

### 2. Rollup

Rollup：构建性能好。Rust 版本的 Rollup 正在开发中。

vite 在开发环境使用 esbuild 进行预编译，在生成环境使用 bundler rollup，处理方式不一样，偶尔可能会出现开发环境与线上行为不一致的情况，一旦出现不一致，则意味着巨大的排查成本。

- [rollup js](https://github.com/rollup/rollup)



### 3. Parcel

- [Parcel : The zero configuration build tool for the web](https://github.com/parcel-bundler/parcel)

### 4. Rust 版本的工具

**Rolldown**

- [Rolldown: is a JavaScript/TypeScript bundler written in Rust intended to serve as the future bundler used in Vite](https://github.com/rolldown/rolldown)

Vite 团队正在研发 Rolldown 并且已经开源，它是使用 rust 开发的 Rollup 的替代品。它的重点将放在本地级别的性能上，同时保持与 Rollup 的兼容性。最终目标是能悄悄在 Vite 中切换到 Rolldown，并且 Vite 的使用者产生最小的影响。

不过目前来看，Vite 要实现 rust 重构这个目标压力很大。因此 Vite 团队规划了四个阶段来推动这个事情

- 1、替换 esbuild
- 2、替换 Rollup
- 3、使用 rust 实现常用需求的内置转化，如编译 ts、JSX 等
- 4、使用 rust 完全重构 Vite

**Farm**

- [Farm Extremely fast Vite-compatible web build tool written in Rust](https://github.com/farm-fe/farm)

针对 vite 的痛点，Farm 使用 rust 重新实现了对 css/ts/js/sass的编译能力，能实现毫秒级启动项目，对于大部分情况，能讲 hmr 时间控制在 10ms 以内。

**Turborepo**

- [Turborepo](https://github.com/vercel/turborepo)

Turbopack同样是一款基于 rust 构建的前端项目构建工具。Turbopack 建立在新的增量架构上，在打包时只关注开发所需的最小资源，因此不管是启动速度还是 hmr 速度，都有远超 vite 的性能。

在具有 3000 个模块的应用上，Turbopack 只需要 1.8s，而 Vite 需要 11.4s。

Turbopack是由 Vercel团队提供的，专注于提高 Next.js速度的打包工具。并且未来的目标是取代 webpack，成为新一代的前端打包工具。因此 Next.js的成熟与大热，也会带动 Turbopack成为更值得信赖的打包工具。

**Rspack**

- [Rspack: The fast Rust-based web bundler with webpack-compatible API ](https://github.com/web-infra-dev/rspack)

Rspack 是一款由字节团队提供的项目打包工具。和 Turbopack 一样，它也充分发挥了 Rust 语言的性能优势，在打包速度上都有显著的提升。

但是与 Turbopack 不同的是，Rspack 选择了优先对 webpack 生态兼容的路线。一方面，这些兼容可能会带来一定的性能开销，但是在实际的业务落地中，这写性能开销是可以接受的。另外一方面，这些兼容也使得 Rspack 可以更好的与上层框架和生态进行集成，能够实现业务的渐进式迁移。

Rspack 的耗时大概是 Webpack 的十分之一。如果 Webpack 需要10秒，Rspack 就是1秒。但是，它的最大优势还不是快，而是 Webpack 的无缝替换。你基本上不需要改动配置，直接把配置文件webpack.config.js改名为rspack.config.js即可。

Rspack 不仅兼容 Webpack 的语法，还兼容插件。根据官方文档，下载量最高的50个 Webpack 插件，80%以上可以直接使用，剩下的也有替代方案。


## 服务端渲染（SSR）

Vite 为服务端渲染（SSR）提供了内建支持。create-vite-extra 包含了一些你可以用作参考的SSR设置示例：


## SEO

## 应用

- [it-tools](https://github.com/CorentinTh/it-tools)


