---
layout:     post
title:      "ComfyUI教程"
subtitle:   "ComfyUI教程"
date:       2025-03-10
author:     "vxiaozhi"
catalog: true
tags:
    - aigc
---

## 安装

参考 gihtub 官网，直接下载桌面安装包：

- [ComfyUI](https://github.com/comfyanonymous/ComfyUI)

这里提供各模型的使用说明：

- [ComfyUI_examples](https://github.com/comfyanonymous/ComfyUI_examples)

## 安装扩展

- [ComfyUI Manager](https://github.com/ltdrdata/ComfyUI-Manager)

这里选用最直接的 Git clone 安装方法：

step1:

```
cd ~/Documents/ComfyUI/custom_nodes
git clone https://github.com/ltdrdata/ComfyUI-Manager comfyui-manager
```
step2:

- Restart ComfyUI

## 模型下载

有两种方式：

- 1. 通过 ComfyUI Manager 下载模型
- 2. 手动下载模型，然后将模型文件放入 `~/Documents/ComfyUI/models/checkpoints` 文件夹中


## Workflow加载

有几种方式：

- 1. 通过 工作流->浏览模板
- 2. 将 包含 工作流的图片，加载到工作流中 或者 拖动图片到工作窗口，会自动打开工作流。 参考： [flux](https://comfyanonymous.github.io/ComfyUI_examples/flux/)
- 3. 下载第三方 workflow，然后拖动到工作流中。

