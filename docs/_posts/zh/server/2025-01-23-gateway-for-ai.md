---
layout:     post
title:      "LLM时代下的AI网关"
subtitle:   "LLM时代下的AI网关"
date:       2025-01-23
author:     "vxiaozhi"
catalog: true
tags:
    - server
    - gateway
    - LLM
---

## AI 网关

AI Gateway 也被称为大模型网关、AI 网关，是一个用于部署和管理人工智能（AI）模型的平台，在开源社区有对应技术实现。它为用户提供了一种方便的方式来部署和管理 AI 模型，无论这些模型是预训练的模型，还是用户自己开发的模型。AI Gateway 还提供了一种方式，让用户能够在需要的时候轻松地调用这些模型，例如在进行数据分析或开发新的 AI 应用程序时。此外，AI Gateway 还提供了各种工具，可以帮助用户监控模型的性能，以及进行模型的优化。

当然，除了上述功能外，AI Gateway 的特点不仅限于些，它还提供了高度的灵活性和可扩展性，用户可以根据自己的需求选择部署模型的规模，以满足各种业务需求。用户也可以根据自己的需求，调整模型的参数，以满足特定需求。

此外，由于具有对模型的权限管理及实时监控功能，加上可以缓存、重试、调整模型调用优先级等优化措施，AI Gateway 还可以保护数据隐私，稳定、高负载、安全的运行。


## AI 场景下的新需求

相比传统 Web 应用，LLM 应用在网关层的流量有以下三大特征：


- 长连接。由 AI 场景常见的 Websocket 和 SSE 协议决定，长连接的比例很高，要求网关更新配置操作对长连接无影响，不影响业务。

- 高延时。LLM 推理的响应延时比普通应用要高出很多，使得 AI 应用面向恶意攻击很脆弱，容易被构造慢请求进行异步并发攻击，攻击者的成本低，但服务端的开销很高。

- 大带宽。 结合 LLM 上下文来回传输，以及高延时的特性，AI 场景对带宽的消耗远超普通应用，网关如果没有实现较好的流式处理能力和内存回收机制，容易导致内存快速上涨。

## 功能需求




### AI 内容安全

能够做到对大模型请求/响应的实时处理与内容封禁，保障AI应用内容合法合规。

### AI代理

支持不同模型提供商的provider


### AI 缓存

LLM 结果缓存插件，默认配置方式可以直接用于 openai 协议的结果缓存，同时支持流式和非流式响应的缓存。

### AI提示词

### AI JSON 格式化

### AI Agent

一个可定制化的 API AI Agent，支持配置 http method 类型为 GET 与 POST 的 API，支持多轮对话，支持流式与非流式模式。 


### AI 历史对话
### AI 意图识别
### AI RAG
### AI 请求响应转换



### 灰度路由

网关支持模型按比例灰度能力，便于用户在模型间迁移，如下图所示，请求流量将有90%被路由到 OpenAI，10%被路由到 Deepseek。

### API Key 二次分租

基于 API 网关的消费者鉴权能力支持 API Key 的二次分租，使用者在对外提供服务时，可以屏蔽掉模型提供商的 API Key，在网关上签发自己的 API Key 供用户使用，从而可以兼容历史调用方的 API Key；除了能够控制消费者的调用权限和调用额度，配合可观测能力，还可以对每个消费者的 token 用量进行观测统计。

### 可观测性

在灰度的过程中，需要持续观测不同模型的 token 开销以及响应速度的情况，来整体衡量切换效果。



网关具备开箱即用的 AI 可观测能力，提供了全局、provider 维度、模型维度以及消费者维度的 token 消耗/延时等观测能力。

## 开源项目

- [gateway](https://github.com/Portkey-AI/gateway)
- [higress](https://github.com/alibaba/higress)
- [kong](https://github.com/Kong/kong)

## 参考

- [DeepSeek-R1 来了，如何从 OpenAI 平滑迁移到 DeepSeek](https://mp.weixin.qq.com/s/0NokzM9SGPkAJgl0c9JiEA)
- [Welcome to Higress Plugin Hub](https://higress.cn/plugin/?spm=36971b57.2ef5001f.0.0.2a932c1frcJdvJ)