---
layout:     post
title:      "DeepSeek 模型发展时间线"
subtitle:   "DeepSeek 模型发展时间线"
date:       2025-02-07
author:     "vxiaozhi"
catalog: true
tags:
    - deepseek
---

## 2023年

2023年7月：DeepSeek成立，总部位于杭州，专注于通用人工智能（AGI）与大模型研发

**DeepSeek Coder** 

发布于2023年7月，支持多种编程语言的代码生成、调试和数据分析任务。

**DeepSeek LLM** 

发布于2023年7月，包括7B和67B的base及chat版本。

## 2024年

**DeepSeek-V2**

- 总参数达2360亿，推理成本降至每百万token仅1元人民币。DeepSeek-V2在实现更强性能的同时，训练成本降低了42.5%，KV缓存减少了93.3%，最大生成吞吐量提高了5.76倍。

**DeepSeek-V2.5**

- [deepseek-v2.5](https://ollama.com/library/deepseek-v2.5)

升级到V2.5，不仅保留了原有Chat模型的通用对话能力和Coder模型的强大代码处理能力，还更好地对齐了人类偏好，在写作任务、指令跟随等多个方面实现了大幅提升。

**DeepSeek-R1-Lite**

正式上线网页端，该模型使用强化学习训练，推理过程包含大量反思和验证，思维链长度可达数万字。

**DeepSeek-V3**

总参数达6710亿，采用创新的MoE架构和FP8混合精度训练，训练成本仅为557.6万美元。

## 2025年

**DeepSeek-R1** 

- DeepSeek-R1的性能与OpenAI的o1正式版持平，其强化学习样本利用率达78%，是传统RLHF的4.3倍。
- 2025年1月26日：DeepSeek应用登顶苹果中国地区和美国地区应用商店免费APP下载排行榜，在美区下载榜上超越了ChatGPT。
- 2025年1月31日：DeepSeek-R1模型现已作为NVIDIA NIM微服务预览版提供，可以在单个NVIDIA HGX H200系统上每秒提供多达3872tokens。


huggingface

- [DeepSeek-R1](https://huggingface.co/deepseek-ai/DeepSeek-R1)

**Janus-Pro**

DeepSeek Janus-Pro 是由 DeepSeek 团队推出的一款开源多模态 AI 模型，旨在通过统一的框架实现高效的多模态理解和生成能力。该模型系列基于自回归框架设计，具备强大的文本到图像生成和视觉理解能力。其目标是解决传统多模态模型中视觉编码器在不同任务中的功能冲突问题，同时提升模型在多模态任务中的灵活性和性能。

技术特点

- 视觉编码解耦：Janus-Pro 采用独立的路径分别处理多模态理解与生成任务，有效解决了视觉编码器在两种任务中的功能冲突。这种解耦设计使得模型在处理复杂多模态任务时更加高效。
- 统一 Transformer 架构：使用单一的 Transformer 架构处理多模态任务，简化了模型设计，提升了扩展能力。这种架构设计使得模型在处理不同模态数据时能够保持一致性和高效性。
- 优化的训练策略：Janus-Pro 对训练策略进行了精细调整，包括延长 ImageNet 数据集训练、聚焦文本到图像数据训练和调整数据比例。这些优化措施显著提升了模型的性能。
- 扩展的训练数据：Janus-Pro 扩展了训练数据的规模和多样性，涵盖多模态理解数据和视觉生成数据。丰富的数据集使得模型能够更好地适应不同的任务需求。
- 高性能视觉编码器：基于 SigLIP-L 作为视觉编码器，支持高分辨率输入，能够捕捉图像细节。
- 高效生成模块：使用 LlamaGen Tokenizer，下采样率为 16，生成更精细的图像。

Janus-Pro 系列包括两个主要版本：

- [Janus-Pro-1B](https://huggingface.co/deepseek-ai/Janus-Pro-1B)
- [Janus-Pro-7B](https://huggingface.co/deepseek-ai/Janus-Pro-7B)

**DeepSeek-V3-0324**

DeepSeek V3–0324 是对前代 DeepSeek V3（初代V3发布于2024年12月26日发布） 的一次重要更新。
虽然官方尚未详细介绍其架构和机制，它主要的亮点：拥有 685B 参数，为Mixture of Experts（MoE）架构已于 Hugging Face 上开源，模型权重全面开放 命名中的“0324”代表发布日期（2025年3月24日） 这一版本被视为 DeepSeek 在通用能力之外，进一步发力编码与推理领域的战略升级。


- [](https://huggingface.co/deepseek-ai/DeepSeek-V3-0324)

