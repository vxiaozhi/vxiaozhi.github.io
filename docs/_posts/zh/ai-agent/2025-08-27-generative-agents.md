---
layout:     post
title:      "斯坦福小镇 AI 解读"
subtitle:   "斯坦福小镇 AI 解读"
date:       2025-08-27
author:     "vxiaozhi"
catalog: true
tags:
    - ai-agent
---

斯坦福和谷歌的研究人员创建了一个类似于《模拟人生》的微型 RPG 虚拟世界，其中 25 个角色由 GPT 和自定义代码控制，并在arxiv上提交了论文版本，引起了对AIGC+游戏的广泛讨论；

## 主要技术

- 记忆系统（Memory Stream）：长期记忆模块
- 反思机制（Reflection）：高层次推理能力
- 计划系统（Planning）：行为规划与执行
- 评估方法（Evaluation）：代理行为的可信度验证

- [论文：Generative Agents: Interactive Simulacra of Human Behavior](https://arxiv.org/pdf/2304.03442)
- [斯坦福AI小镇论文解读-生成代理:人类行为的交互模拟](https://zhuanlan.zhihu.com/p/649991229)


## 开源实现

- [官方：generative_agents](https://github.com/joonspk-research/generative_agents)
- [ai-town TypeScript 实现](https://github.com/a16z-infra/ai-town)
- [国产斯坦福小镇实现](https://github.com/py499372727/AgentSims)