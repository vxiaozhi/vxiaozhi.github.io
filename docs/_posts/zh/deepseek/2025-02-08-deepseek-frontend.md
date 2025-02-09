---
layout:     post
title:      "deepseek 前端方案"
subtitle:   "deepseek 前端方案"
date:       2025-02-08
author:     "vxiaozhi"
catalog: true
tags:
    - deepseek
---

[Awesome DeepSeek Integrations](https://github.com/deepseek-ai/awesome-deepseek-integration) 这里列举了DeepSeek 支持的所有前端项目。

经过测试， 最好用的是：

### 1.  [Chatbox]()

- 特点是简洁，提供App和Web部署
  
### 2. [open-webui](https://github.com/open-webui/open-webui) 

- 支持联网搜索
- TTS
- 丰富的应用市场
  
### 3.  [Lobe Chat](https://github.com/lobehub/lobe-chat)

- TTS & STT 语音会话
- Text to Image 文生图
- 插件系统 (Tools Calling), 插件需要模型支持function call ， 具体原理参考:[DeepSeek API 升级，支持续写、FIM、Function Calling、JSON Output](https://api-docs.deepseek.com/zh-cn/news/news0725)
- 助手市场 (GPTs)

docker 部署：

```
$ docker run -d -p 3210:3210 \
  -e OPENAI_API_KEY=sk-xxxx \
  -e ACCESS_CODE=lobe66 \
  --name lobe-chat \
  lobehub/lobe-chat
```
