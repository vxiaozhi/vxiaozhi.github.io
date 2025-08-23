---
layout:     post
title:      "实时语音转文字"
subtitle:   "实时语音转文字"
date:       2025-08-23
author:     "vxiaozhi"
catalog: true
tags:
    - rtc
---

## 开源项目：

### IntraScribe

- [团队适用的语音转录总结工具，完整的前后端代码](https://github.com/weynechen/intrascribe)

实现原理：

- 其音频捕获框架采用 fastrtc，直接将端口mount到fastapi之上，对外公开暴露
- 鉴权：需要再不修改源码的情况下，对fastrtc的端口添加中间件进行认证保护。

## rtc 开源框架

- [The python library for real-time communication](https://github.com/gradio-app/fastrtc)