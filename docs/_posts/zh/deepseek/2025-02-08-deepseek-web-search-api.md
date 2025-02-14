---
layout:     post
title:      "deepseek 联网搜索方案"
subtitle:   "deepseek 联网搜索方案"
date:       2025-02-08
author:     "vxiaozhi"
catalog: true
tags:
    - deepseek
---

联网搜索实现方案，参考: [基于ChatGPT开发Agent实现互联网内容搜索](https://zhuanlan.zhihu.com/p/673524057)

## 搜索引擎API

以Open-webui为例，其提供联网搜索API的搜索引擎有如下：

### 免费开源

- 'searxng',
  
### 免费

- 'duckduckgo',

### 商业收费

- 'google_pse',
- 'brave',
- 'kagi',
- 'mojeek',
- 'serpstack',
- 'serper',
- 'serply',
- 'searchapi',
- 'tavily',
- 'jina',
- 'bing',
- 'exa'

## Open-webui 搜索流程代码解析


- @app.post("/api/chat/completions")
- async def chat_completion()
  - async def process_chat_payload()
    - async def chat_web_search_handler()
      - def process_web_search()


