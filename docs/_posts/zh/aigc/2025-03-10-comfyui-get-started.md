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

## 术语解释

- VAE：变分自动编码器
- CLIP模型： 全称 Contrastive Language-Image Pre-Training（对比性语言-图像预训练模型


## 安装

参考 gihtub 官网，直接下载桌面安装包：

- [ComfyUI](https://github.com/comfyanonymous/ComfyUI)

这里提供各模型的使用说明：

- [ComfyUI_examples](https://github.com/comfyanonymous/ComfyUI_examples)

## 安装扩展

- [ComfyUI Manager](https://github.com/ltdrdata/ComfyUI-Manager) 【可忽略】最新版本（0.4.29）已默认内置该扩展。

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

## GGUF

默认的模型，如 [Flux-schnell]() 会消耗显存较大， 在 Mac M1 32G 上出一张 1024*1024 的图，大概耗时 7~8 分钟。内存+显存 大约 28G。

而使用 GGUF 量化模型可以大大减少 显存的消耗。使用 flux-schnell-gguf-Q4 量化模型，出一张 1024*1024 的图，耗时减少至3分钟。内存+显存 降低到 8G 左右。

支持 量化模型， 需要先安装 GGUF 插件:

- [ComfyUI-GGUF](https://github.com/city96/ComfyUI-GGUF)

### 安装步骤如下

- 下载 ComfyUI-GGUF 到 `~/Documents/ComfyUI/custom_nodes` 文件夹中
```
git clone https://github.com/city96/ComfyUI-GGUF
```

- 安装依赖(具体Python版本及路径可以通过 ComfyUI 日志查看）

```
./.venv/bin/python -m pip install  -r custom_nodes/ComfyUI-GGUF/requirements.tx
```

- 更新插件（Manager -> Update All Custom Nodes）
- 重启 ComfyUI

### 下载依赖模型

- [FLUX.1-schnell-gguf](https://huggingface.co/city96/FLUX.1-schnell-gguf) 放置到ComfyUI/models/unet/ 文件下
- [FLUX.1-schnell-vae](https://huggingface.co/black-forest-labs/FLUX.1-schnell/blob/main/ae.safetensors) 放在ComfyUI/models/vae/ 文件夹中
- [clip-vit-large-patch14/pytorch_model.bin](https://huggingface.co/openai/clip-vit-large-patch14/blob/main/pytorch_model.bin) 放到 ComfyUI/models/clip/ 目录中
- [t5-v1_1-xxl-encoder-bf16/model.safetensors](https://huggingface.co/city96/t5-v1_1-xxl-encoder-bf16/blob/main/model.safetensors) 放到 ComfyUI/models/clip/ 目录中

### 加载 workflow 

参考：[flux_schnell_gguf.json](https://github.com/vxiaozhi/ComfyUI-GGUF/blob/main/flux_schnell_gguf.json)

## 其它模型

**SDXL-Lightning**

在 [SDXL-Lightning huggingface](https://huggingface.co/ByteDance/SDXL-Lightning) 上不仅提供模型下载，而且贴心的提供了 Workflow Json 文件，直接拖到 ComfyUI 中即可使用。

## API 访问

由于ComfyUI没有官方的API文档，所以想要去利用ComfyUI开发一些web应用会比 a1111 webui这种在fastapi加持下有完整交互式API文档的要困难一些，而且不像a1111 sdwebui 对很多pipeline都有比较好的封装，基本可以直接用。

comfyui里，API 接口需要同时使用 普通http 和 websocket 两种协议。

- websocket 接口用来查询任务的状态信息。
- http 接口用来执行任务，查询任务结果。

可以参考这篇文章分析：[ComfyUI开发指南](https://zhuanlan.zhihu.com/p/687537814)

另外官方代码仓库也提供了几个脚本供参考：

- [basic_api_example.py](https://github.com/comfyanonymous/ComfyUI/blob/master/script_examples/basic_api_example.py) 提供执行任务功能
- [websockets_api_example.py](https://github.com/comfyanonymous/ComfyUI/blob/master/script_examples/websockets_api_example.py) 提供完整的执行任务、查询任务状态、获取结果并下载功能。
- [websockets_api_example_ws_images.py](https://github.com/comfyanonymous/ComfyUI/blob/master/script_examples/websockets_api_example_ws_images.py) 提供完整的执行任务、查询任务状态、获取结果并下载功能，但是结果以图片的形式返回。

