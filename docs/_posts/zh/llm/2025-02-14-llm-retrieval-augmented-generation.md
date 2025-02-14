---
layout:     post
title:      "LLM Retrieval-Augmented Generation(RAG)"
subtitle:   "LLM 之检索增强生成"
date:       2025-02-14
author:     "vxiaozhi"
catalog: true
tags:
    - llm
    - rag
---

相关论文：[Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks](https://arxiv.org/abs/2005.11401)
这里有个 [手搓的RAG](https://github.com/SmartFlowAI/Hand-on-RAG) github项目可以一窥RAG的全貌。

## 什么是检索增强生成？

检索增强生成（RAG）是一个概念，它旨在为大语言模型（LLM）提供额外的、来自外部知识源的信息。这样，LLM 在生成更精确、更贴合上下文的答案的同时，也能有效减少产生误导性信息的可能。

### 问题

当下领先的大语言模型 (LLMs) 是基于大量数据训练的，目的是让它们掌握广泛的普遍知识，这些知识被储存在它们神经网络的权重（也就是参数记忆）里。但是，如果我们要求 LLM 生成的回答涉及到它训练数据之外的知识——比如最新的、专有的或某个特定领域的信息——这时就可能出现事实上的错误（我们称之为“幻觉”），以下截图就是一个典型案例：

>
>ChatGPT 在回答“总统对布雷耶法官有何看法？”这个问题时表示：“我不知道，因为我没有办法获取实时的信息”

这是 ChatGPT 回答“总统对布雷耶法官有何看法？”这个问题的情况。

因此，弥合 LLM 的常识与任何额外语境之间的差距非常重要，这样才能帮助 LLM 生成更准确、更符合语境的补全，同时减少幻觉。

### 解决方案

传统上，要让神经网络适应特定领域或私有信息，人们通常会对模型进行微调。这种方法确实有效，但同时也耗费大量计算资源、成本高昂，且需要丰富的技术知识，因此在快速适应信息变化方面并不灵活。

2020 年，Lewis 等人在论文《知识密集型 NLP 任务的检索增强生成》(Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks) [1] 中，提出了一种更为灵活的技术——检索增强生成（Retrieval-Augmented Generation，RAG）。该研究将生成模型与检索模块结合起来，能够从易于更新的外部知识源中获取额外信息。

用一个简单的比喻来说， RAG 对大语言模型（Large Language Model，LLM）的作用，就像开卷考试对学生一样。在开卷考试中，学生可以带着参考资料进场，比如教科书或笔记，用来查找解答问题所需的相关信息。开卷考试的核心在于考察学生的推理能力，而非对具体信息的记忆能力。

同样地，在 RAG 中，事实性知识与 LLM 的推理能力相分离，被存储在容易访问和及时更新的外部知识源中，具体分为两种：

- 参数化知识（Parametric knowledge）： 模型在训练过程中学习得到的，隐式地储存在神经网络的权重中。
- 非参数化知识（Non-parametric knowledge）： 存储在外部知识源，例如向量数据库中。

（顺便提一下，这个贴切的比喻并非我首创，最早是在 Kaggle 的 LLM 科学考试竞赛中，由 JJ 提出的。）

下面是 RAG 工作流程的示意图：

![](/imgs/llm-rag.webp)
检索增强生成（RAG）的工作流程，从用户的查询开始，经过向量数据库的检索，到提示填充，最后生成回应。

检索增强生成的工作流程:

- 检索： 此过程涉及利用用户的查询内容，从外部知识源获取相关信息。具体来说，就是将用户的查询通过嵌入模型转化为向量，以便与向量数据库中的其他上下文信息进行比对。通过这种相似性搜索，可以找到向量数据库中最匹配的前 k 个数据。
- 增强： 接着，将用户的查询和检索到的额外信息一起嵌入到一个预设的提示模板中。
- 生成： 最后，这个经过检索增强的提示内容会被输入到大语言模型 (LLM) 中，以生成所需的输出。

## 向量数据库

- Weaviate 

## Prompt Template

```
 """You are an assistant for question-answering tasks.
Use the following pieces of retrieved context to answer the question.
If you don't know the answer, just say that you don't know.
Use three sentences maximum and keep the answer concise.
Question: {question}
Context: {context}
Answer:
"""
```

