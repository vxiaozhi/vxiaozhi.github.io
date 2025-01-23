---
layout:     post
title:      "怎么使用AI大模型画图"
subtitle:   "怎么使用AI大模型画图"
date:       2025-01-23
author:     "vxiaozhi"
catalog: true
tags:
    - aigc
---

## 模型选择

可以在 replicate 网站上寻找合适的绘图模型。 

-  [replicate](https://replicate.com/explore)

例如：图像生成（Generate images）模型，用户使用次数最多的是 字节跳动的这个 sdxl 模型：

- [bytedance/sdxl-lightning-4step](https://replicate.com/bytedance/sdxl-lightning-4step)
- [black-forest-labs/flux-schnell](https://replicate.com/black-forest-labs/flux-schnell)

或者根据人脸生成模型（Use a face to make images）

- [tencentarc/photomaker](https://replicate.com/tencentarc/photomaker)

## Prompt 生成

Prompt 怎么写呢，这里提供一些方法：

### 方法1：参考别人的Prompt

如可以到C站上寻找满足自己需求的图片，看看对应的Prompt是什么，或者 搜索引擎搜索 Prompt，有很多网站提供高质量的画图Prompt。

- [C站](https://civitai.com/)

### 方法2：专用模型生成Prompt

有一些大模型可以用来根据关键词生成详细的Prompt， 如：

- [kyrick/prompt-parrot](https://replicate.com/kyrick/prompt-parrot)

### 方法3：大模型Prompt

利用 OpenAI / DeepSeek 等LLM模型， 生成 Prompt。

## 实践

以生成博客个人图像为例，这里记录其生成过程：

先用 deepseek 深度思考(R1) 生成 Prompt。

prompt：

```
我想让你为我生成一段详细的画图prompt(只要英文描述即可)： 画一个男士卡通头像，体现"小智晖"这个名字的意义。
```

```
Create a cheerful and intelligent cartoon portrait of a young man named 'Xiao Zhihui' (小智晖), emphasizing the meaning of his name. 'Zhi' (智) represents wisdom and intellect, while 'Hui' (晖) symbolizes sunshine and radiant energy. Design him with bright, warm-toned circular glasses that reflect tiny sparkles of light to showcase intelligence. Style his hair in soft, windswept brown strands with subtle golden highlights resembling sunrays. Dress him in a modern blue-gray hoodie featuring abstract circuit-pattern embroidery on the sleeves, blending technology with approachability. Add a faint glowing halo effect around his head, transitioning from yellow to orange like a miniature sunrise. Include playful elements: a floating lightbulb icon near his shoulder with a smiling face, and three geometric-shaped paper planes (triangle, hexagon, circle) trailing dotted innovation sparks behind them. Make his expression kind yet mischievous, with one eyebrow slightly raised in curiosity and cheeks glowing soft peach. Use a clean line art style with cel-shaded coloring, keeping background minimal but adding faint concentric circles of light radiating outward. Include two subtle motifs: tiny star constellations reflected in his glasses and sunflower petal shapes integrated into the glow effects. Render in 2D vector-based illustration with smooth gradients, optimized for digital avatar use.
```
分别使用上面两个模型，生成的图片, flux-schnell 模型的效果要更胜一筹。

sdxl-lightning-4step 效果如下：

![sdxl-lightning-4step](/imgs/vxiaozhi-sdxl-lightning-4step.png)


flux-schnell 效果如下：

![flux-schnell](/imgs/vxiaozhi-flux-schnell.webp)



