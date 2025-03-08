---
layout:     post
title:      "阿里千问系列模型"
subtitle:   "阿里千问系列模型"
date:       2025-03-08
author:     "vxiaozhi"
catalog: true
tags:
    - qwenlm
    - 千问
---

## 简介

Github仓库:

-  [Qwen](https://github.com/QwenLM)

所有的博客都会发表在这里：

- [qwenlm.github.io](https://github.com/QwenLM/qwenlm.github.io)
  
如：
- [QwQ-32B: 领略强化学习之力](https://qwenlm.github.io/zh/blog/qwq-32b/)

## API

以下我们展示了一段简短的示例代码，说明如何通过 API 使用 QwQ-32B:

```
from openai import OpenAI
import os

# Initialize OpenAI client
client = OpenAI(
    # If the environment variable is not configured, replace with your API Key: api_key="sk-xxx"
    # How to get an API Key：https://help.aliyun.com/zh/model-studio/developer-reference/get-api-key
    api_key=os.getenv("DASHSCOPE_API_KEY"),
    base_url="https://dashscope.aliyuncs.com/compatible-mode/v1"
)

reasoning_content = ""
content = ""

is_answering = False

completion = client.chat.completions.create(
    model="qwq-32b",
    messages=[
        {"role": "user", "content": "Which is larger, 9.9 or 9.11?"}
    ],
    stream=True,
    # Uncomment the following line to return token usage in the last chunk
    # stream_options={
    #     "include_usage": True
    # }
)

print("\n" + "=" * 20 + "reasoning content" + "=" * 20 + "\n")

for chunk in completion:
    # If chunk.choices is empty, print usage
    if not chunk.choices:
        print("\nUsage:")
        print(chunk.usage)
    else:
        delta = chunk.choices[0].delta
        # Print reasoning content
        if hasattr(delta, 'reasoning_content') and delta.reasoning_content is not None:
            print(delta.reasoning_content, end='', flush=True)
            reasoning_content += delta.reasoning_content
        else:
            if delta.content != "" and is_answering is False:
                print("\n" + "=" * 20 + "content" + "=" * 20 + "\n")
                is_answering = True
            # Print content
            print(delta.content, end='', flush=True)
            content += delta.content

```