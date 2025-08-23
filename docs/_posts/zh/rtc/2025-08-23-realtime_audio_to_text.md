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

# 开源项目

## IntraScribe

- [团队适用的语音转录总结工具，完整的前后端代码](https://github.com/weynechen/intrascribe)

实现原理：

### rtc

- 其音频捕获框架采用 fastrtc，直接将端口mount到fastapi之上，对外公开暴露
- 鉴权：需要再不修改源码的情况下，对fastrtc的端口添加中间件进行认证保护。

### asr

语音识别采用了当前流行的开源项目 FunASR.

FunASR是一个基础语音识别工具包，提供多种功能，包括语音识别（ASR）、语音端点检测（VAD）、标点恢复、语言模型、说话人验证、说话人分离和多人对话语音识别等。FunASR提供了便捷的脚本和教程，支持预训练好的模型的推理与微调。

- [FunASR](https://github.com/modelscope/FunASR)

## rtc 开源框架

- [The python library for real-time communication](https://github.com/gradio-app/fastrtc)