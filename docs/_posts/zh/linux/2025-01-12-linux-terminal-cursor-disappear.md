---
layout:     post
title:      "解决Linux操作系统下Terminal中光标消失的问题"
subtitle:   "解决Linux操作系统下Terminal中光标消失的问题"
date:       2025-01-12
author:     "vxiaozhi"
catalog: true
tags:
    - terminal
---

# 解决Linux操作系统下Terminal中光标消失的问题

使用Terminal时会偶尔遇到光标消失的问题。


显示光标

```
echo -e "\033[?25h"
```

隐藏光标

```
echo -e "\033[?25l"
```
