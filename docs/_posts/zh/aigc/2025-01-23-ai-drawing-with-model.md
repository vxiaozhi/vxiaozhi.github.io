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

例如：图像生成（Generate images）模型，用户使用次数最多的是 字节跳动的这个 sdxl 模型, 但经过实际验证，flux-schnell的效果要更好：

- [bytedance/sdxl-lightning-4step](https://replicate.com/bytedance/sdxl-lightning-4step)
- [black-forest-labs/flux-schnell](https://replicate.com/black-forest-labs/flux-schnell)
- [black-forest-labs/flux-kontext-max](https://replicate.com/black-forest-labs/flux-kontext-max)

**图片上显示汉字的模型**

- [AnyText](https://github.com/tyxsspa/AnyText)

或者根据人脸生成模型（Use a face to make images）

- [tencentarc/photomaker](https://replicate.com/tencentarc/photomaker)

**[Flux系列开源模型](https://huggingface.co/black-forest-labs)**

- flux-schnell
- FLUX.1-Kontext-dev

## Prompt 生成

Prompt 怎么写呢，这里提供一些方法：

### 方法1：参考别人的Prompt

如可以到C站上寻找满足自己需求的图片，看看对应的Prompt是什么，或者 搜索引擎搜索 Prompt，有很多网站提供高质量的画图Prompt。

- [C站](https://civitai.com/)

### 方法2：专用模型生成Prompt

有一些大模型可以用来根据关键词生成详细的Prompt， 如：

- [kyrick/prompt-parrot](https://replicate.com/kyrick/prompt-parrot)
- [flux-prompt](https://ollama.com/abedalswaity7/flux-prompt) 基于 Llama-3.2 3B 微调的模型

### 方法3：大模型生成Prompt

利用 OpenAI / DeepSeek 等LLM模型， 生成 Prompt。可参考：

- [openwebui prompt](https://openwebui.com/models/?query=prompt)

## 实践

### 1. 个人图像生成

以生成博客个人图像为例，这里记录其生成过程：

先用 deepseek 深度思考(R1) 生成 Prompt。

生成prompt的提示词如下：

```
我想让你为我生成一段详细的画图prompt(只要英文描述即可)： 画一个男士卡通头像，体现"小智晖"这个名字的意义。
```
最终生成的prompt：

```
Create a cheerful and intelligent cartoon portrait of a young man named 'Xiao Zhihui' (小智晖), emphasizing the meaning of his name. 'Zhi' (智) represents wisdom and intellect, while 'Hui' (晖) symbolizes sunshine and radiant energy. Design him with bright, warm-toned circular glasses that reflect tiny sparkles of light to showcase intelligence. Style his hair in soft, windswept brown strands with subtle golden highlights resembling sunrays. Dress him in a modern blue-gray hoodie featuring abstract circuit-pattern embroidery on the sleeves, blending technology with approachability. Add a faint glowing halo effect around his head, transitioning from yellow to orange like a miniature sunrise. Include playful elements: a floating lightbulb icon near his shoulder with a smiling face, and three geometric-shaped paper planes (triangle, hexagon, circle) trailing dotted innovation sparks behind them. Make his expression kind yet mischievous, with one eyebrow slightly raised in curiosity and cheeks glowing soft peach. Use a clean line art style with cel-shaded coloring, keeping background minimal but adding faint concentric circles of light radiating outward. Include two subtle motifs: tiny star constellations reflected in his glasses and sunflower petal shapes integrated into the glow effects. Render in 2D vector-based illustration with smooth gradients, optimized for digital avatar use.
```
分别使用上面两个模型，生成的图片, flux-schnell 模型的效果要更胜一筹。

sdxl-lightning-4step 效果如下：

![sdxl-lightning-4step](/imgs/vxiaozhi-sdxl-lightning-4step.png)


flux-schnell 效果如下：

![flux-schnell](/imgs/vxiaozhi-flux-schnell.webp)

### 2. 英语单词助记图片生成

根据单词的释义，生成一副可帮助记忆单词的图片。

生成prompt的提示词如下：

>You are a master of prompt engineering for image generation models. Respond only with a prompt and nothing else.
>
>Your task is to create a prompt that would be used to generate a mnemonic image helpful in remembering the word "{{ word }}".
>
>Base your answer on your knowledge and the following HTML, which contains definitions and examples of this word from an English Dictionary.
>```html
>{{ definition }}
>```
>
>The prompt must generate an image without any text, so work only with visual cues. Think of something unique, memorable and easy to connect with the word's meaning. You can omit less important or hard-to-visualize definitions. Add additional single-word features to the prompt describing the visual appearance of the scenery and the style of the image. 
>
>Keep it concise and precise while sticking to full sentences. Explain your answer and generate only one prompt. Provide your answer as JSON with the following format:
>```json
>{
>    "explanation": "explain why proposed prompt is suitable for remembering the word '{{ word }}'",
>    "prompt": "your prompt here",
>}
>```
>Use single quotation marks in JSON values. Remember to keep the prompt short and simple. Good luck!

由于 DeepSeek 对 中文语义理解很好，只需要很简短的中文即可表达上述意义，以 regret 单词为例， 提示词如下：

```
根据以下对单词 "regret" 的定义和示例，创建一个用于生成有助于记忆该单词的prompt。
"""
regret	 v. 懊悔；抱歉 n. 懊悔
"""

这个prompt必须仅使用视觉线索来生成图像，因此请专注于独特的、易于与单词含义相关联的事物。
你可以忽略不太重要或难以想象的定义，并添加一些单字特征描述场景和图片风格的视觉外观。保持简洁准确的同时坚持完整的句子。解释你的答案并只生成一个prompt。以以下JSON格式提供你的回答(使用单引号在JSON值中，explanation字段的值用中文，prompt字段的值用英文):
"""json
{
    "explanation": "explain why proposed prompt is suitable for remembering the word 'regret'",
    "prompt": "your prompt here",
}
"""

```

使用 DeepSeek-R1生成的Prompt如下：

```
{
    "explanation": "黄昏象征错过的时光，破碎相框暗示无法挽回的过去，沙漏中的'Sorry'沙字直接关联懊悔的情感，柔和的暗色调强化忧郁氛围。阴影中模糊的人形轮廓避免了具体人物特征，使观者能代入自身经历。",
    "prompt": "A dimly lit room at dusk with a shattered photo frame on wooden floor, golden sand from an hourglass forming the word 'Sorry', soft shadows of a person with lowered head cast on peach-toned walls, in muted watercolor style with blurred edges."
}
```

flux-schnell 效果如下：

![flux-schnell](/imgs/word-regret.png)

![flux-schnell2](/imgs/word-regret-2.png)

## 自动化方案

- [ComfyUI](https://github.com/comfyanonymous/ComfyUI)
- [Stable Diffusion WebUI](https://github.com/AUTOMATIC1111/stable-diffusion-webui)




