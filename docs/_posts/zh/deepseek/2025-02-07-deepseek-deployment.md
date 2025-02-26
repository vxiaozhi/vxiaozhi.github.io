---
layout:     post
title:      "deepseek 部署方案"
subtitle:   "deepseek 部署方案"
date:       2025-02-07
author:     "vxiaozhi"
catalog: true
tags:
    - deepseek
---

DeepSeek是最近非常火的开源大模型，国产大模型 DeepSeek 凭借其优异的性能和对硬件资源的友好性，受到了众多开发者的关注。

无奈，在使用时候deepseek总是提示服务器繁忙，请稍后再试。

这可怎么办？

万幸的是，DeepSeek是一个开源模型，这意味着我们可以将它部署在自己的电脑上，以便随时使用！， 同时各个云厂商也提供了自己的部署方案。

今天就跟大家分享一下，DeepSeek部署的几种方案。

## 本地部署方案

### Ollama

首先我们需要安装Ollama，Ollama是一个用于本地管理和运行大模型的工具，能够简化模型的下载和调度操作。

进入Ollama官网（https://ollama.com）。

点击【Download】，选择适合自己系统的版本（Windows/mac/Linux）。

DeepSeek 模型, 以 `deepseek-r1` 为例， 其提供了如下几个版本：

```
1.5b
7b
8b
14b
32b
70b
671b
```

启动 DeepSeek 模型

```
ollama run deepseek-r1:14b
```

在 Apple M1 Pro / 32 GB 机器上运行 14b 模型毫无压力， 可以达到大约 10 token/s 的速度。

### SGLang

- [sglang](https://github.com/sgl-project/sglang) SGLang is a fast serving framework for large language models and vision language models.



### VLLM

- [vllm](https://github.com/vllm-project/vllm)

### inference

- [inference](https://github.com/xorbitsai/inference)


## 支持DeepSeek的云服务平台

### deepseek 官方

- [deepseek 官方](https://chat.deepseek.com/)

### 字节火山引擎

- [模型体验入口](https://console.volcengine.com/ark/region:ark+cn-beijing/experience/chat)
- [我的应用-我的DeepSeek-R1-联网搜索版](https://console.volcengine.com/ark/region:ark+cn-beijing/assistant/detail?id=bot-20250226234543-fdsdl&templateType=InfoSource)

预埋推理接入点：

```
curl https://ark.cn-beijing.volces.com/api/v3/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ARK_API_KEY" \
  -d '{
    "model": "deepseek-r1-250120",
    "messages": [
      {"role": "system","content": "你是人工智能助手."},
      {"role": "user","content": "常见的十字花科植物有哪些？"}
    ]
  }'
```

同时也支持自定义在线接入点（Endpoint）

- [创建在线接入点](https://console.volcengine.com/ark/region:ark+cn-beijing/endpoint?config=%7B%7D)

示例代码如下， ep-20250226225639-lbdsg 即为 Endpoint ID：

```
curl https://ark.cn-beijing.volces.com/api/v3/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ARK_API_KEY" \
  -d '{
    "model": "ep-20250226225639-lbdsg",
    "messages": [
      {"role": "system","content": "你是人工智能助手."},
      {"role": "user","content": "常见的十字花科植物有哪些？"}
    ]
  }'
```

其它参考：

- [字节火山引擎](https://console.volcengine.com/ark/region:ark+cn-beijing/model?feature=&vendor=Bytedance&view=LIST_VIEW)
- [火山引擎控制台](https://console.volcengine.com/home)
- [ChatCompletions-文本生成](https://www.volcengine.com/docs/82379/1298454)

### 阿里云百炼

- [阿里云百炼 模型广场](https://bailian.console.aliyun.com/?spm=5176.29597918.J__Xz0dtrgG-8e2H7vxPlPy.8.67b67ca0NBXQtk#/model-market)
- [DeepSeek-V3 API示例](https://bailian.console.aliyun.com/?spm=5176.29597918.J__Xz0dtrgG-8e2H7vxPlPy.8.67b67ca0NBXQtk#/model-market/detail/deepseek-v3?tabKey=sdk)

## 腾讯云大模型知识引擎

- [DeepSeek应用创建](https://cloud.tencent.com/document/product/1759/116006)
  
### 其它

- [硅基流动](https://siliconflow.cn/zh-cn/models)
- [openrouter](https://openrouter.ai/deepseek/deepseek-r1)
- [huggingface](https://huggingface.co/spaces/llamameta/DeepSeek-R1-Chat-Assistant-Web-Search)
- [replicate](https://replicate.com/deepseek-ai/deepseek-r1)

