---
layout:     post
title:      "llama.cpp 使用"
subtitle:   "llama.cpp 使用"
date:       2025-03-08
author:     "vxiaozhi"
catalog: true
tags:
    - llm
---

## Install

```
git clone https://github.com/ggml-org/llama.cpp.git
mkdir build && cd build
cmake .. 
make && make install
```

## GGUF量化


**一、GGUF量化过程**

1.  **原始模型准备**

- 需要完整的FP16或FP32精度模型（如PyTorch格式）
- 常见来源：[HuggingFace](https://zhida.zhihu.com/search?content_id=253093485&content_type=Article&match_order=1&q=HuggingFace&zhida_source=entity)仓库的原始模型文件

1.  **格式转换**

Bashpython3 llama.cpp/convert.py \[原始模型目录\] --outfile \[输出路径\]/phi-2-f16.gguf

将原始模型转换为未量化的GGUF格式（FP16精度）

1.  \*\*量化处理

Bash./llama.cpp/quantize \[输入GGUF文件\] \[输出量化文件\] \[量化类型\]# 示例：./llama.cpp/quantize phi-2-f16.gguf phi-2-Q4_K_M.gguf Q4_K_M

1.  **量化类型解析**

| 量化类型 | 位宽  | 典型大小 | 质量保留 |
| --- | --- | --- | --- |
| Q2_K | 2bit | ~850MB | 最低  |
| Q4_0 | 4bit | ~1.6GB | 基础  |
| Q4_K_M | 4bit | ~1.6GB | 优化版 |
| Q5_K_S | 5bit | ~2.0GB | 平衡  |
| Q6_K | 6bit | ~2.3GB | 准无损 |

**二、命名规范详解**

示例：phi-4-Q4_K_M.gguf

1.  **模型标识**

- 第一部分：基础模型名称（phi-4）
- 可包含架构/版本号（如-2b表示20亿参数）

1.  **量化描述**

- Q：量化标识
- 4：主位宽（4bit）
- K：采用[k-quant](https://zhida.zhihu.com/search?content_id=253093485&content_type=Article&match_order=1&q=k-quant&zhida_source=entity)算法（改进的量化技术）
- M：质量等级（M=Medium，S=Small，L=Large）

1.  **常见量化后缀对照**

Plain TextQ4_0 → 4位基础量化Q4_K_S → 4位k-quant轻量版Q4_K_M → 4位k-quant标准版Q5_K_M → 5位k-quant平衡版Q8_0 → 8位准无损量化

**三、选择建议**

1.  **性能优先**：Q4_K_M（最佳速度/质量平衡）
2.  **显存紧张**：Q2_K（最小体积，质量下降明显）
3.  **质量优先**：Q6_K（接近原始精度）
4.  **折中选择**：Q5_K_M（比Q4提升质量，体积增加有限）

**四、实践技巧**

1.  使用最新版llama.cpp（支持最新量化方法）
2.  验证量化效果：

Bash./llama.cpp/main -m phi-2-Q4_K_M.gguf -p "测试文本" -n 128

1.  组合使用不同量化级别模型：

- 开发调试用Q8_0
- 部署使用Q4_K_M
- 移动端使用Q2_K

## 命令行

启动客户端：

```
llama-cli -m DeepSeek-R1-Distill-Qwen-14B-Uncensored.Q5_K_M.gguf
```

启动服务器：

```
llama-server -m DeepSeek-R1-Distill-Qwen-14B-Uncensored.Q5_K_M.gguf --port 8080
```

启动服务器（并发： 4， 窗口大小： 16384）：

```
llama-server -m DeepSeek-R1-Distill-Qwen-14B-Uncensored.Q5_K_M.gguf -c 16384 -np 4  --port 8080
# Basic web UI can be accessed via browser: http://localhost:8080
# Chat completion endpoint: http://localhost:8080/v1/chat/completions
```



性能测试：

```
llama-bench -m DeepSeek-R1-Distill-Qwen-14B-Uncensored.Q5_K_M.gguf
```
测试结果如下：

| model                          |       size |     params | backend    | threads |          test |                  t/s |
| ------------------------------ | ---------: | ---------: | ---------- | ------: | ------------: | -------------------: |
| qwen2 14B Q5_K - Medium        |   9.78 GiB |    14.77 B | Metal,BLAS |       8 |         pp512 |        114.96 ± 0.08 |
| qwen2 14B Q5_K - Medium        |   9.78 GiB |    14.77 B | Metal,BLAS |       8 |         tg128 |         11.27 ± 0.03 |

build: 3ffbbd5c (4840)


## GGUF 模型推荐

- [Tifa-Deepseek-14b-CoT](https://huggingface.co/ValueFX9507/Tifa-Deepsex-14b-CoT-GGUF-Q4) 本模型基于Deepseek-R1-14B进行深度优化，借助Tifa_220B生成的数据集通过三重训练策略显著增强角色扮演、小说文本生成与思维链（CoT）能力。特别适合需要长程上下文关联的创作场景。
- [DeepSeek-R1-Distill-Qwen-32B-GGUF](https://huggingface.co/bartowski/DeepSeek-R1-Distill-Qwen-32B-GGUF)
- [DeepSeek-R1-Distill-Qwen-14B-Uncensored-GGU](https://huggingface.co/mradermacher/DeepSeek-R1-Distill-Qwen-14B-Uncensored-GGUF)
- [Llamacpp imatrix Quantizations of QwQ-32B by Qwen](https://huggingface.co/bartowski/Qwen_QwQ-32B-GGUF)
