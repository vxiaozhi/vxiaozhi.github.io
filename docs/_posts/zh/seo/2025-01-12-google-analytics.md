---
layout:     post
title:      "Google 统计接入"
subtitle:   "如何要在网站中接入谷歌统计插件(Google Analytics)"
date:       2025-01-12
author:     "vxiaozhi"
catalog: true
tags:
    - seo
---

## 步骤

如果要在后端接入，可参考： [谷歌统计接入](https://www.cnblogs.com/lwhzj/p/18347217)

要在网站中接入谷歌统计插件(Google Analytics),你可以按照以下步骤操作：

### Step 1

 注册Google Analytics账号并获取跟踪ID：访问 https://analytics.google.com/ 并使用你的 Google 账户登录

### Step2  根据提示添加代码。以下是实例

以下是此账号的 Google 代码。请将该代码复制并粘贴到您网站上每个网页的代码中，紧跟在 <head> 元素之后。每个网页只能添加一个 Google 代码。

```
<!-- Google tag (gtag.js) -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-L2FGRML2DB"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'G-L2FGRML2DB');
</script>
```

注意 1个Analytics账号 可以接入多个网站。


