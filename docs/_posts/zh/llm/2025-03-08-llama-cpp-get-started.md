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

**DeepSeek系列**

- [Tifa-Deepseek-14b-CoT](https://huggingface.co/ValueFX9507/Tifa-Deepsex-14b-CoT-GGUF-Q4) 本模型基于Deepseek-R1-14B进行深度优化，借助Tifa_220B生成的数据集通过三重训练策略显著增强角色扮演、小说文本生成与思维链（CoT）能力。特别适合需要长程上下文关联的创作场景。
- [DeepSeek-R1-Distill-Qwen-32B-GGUF](https://huggingface.co/bartowski/DeepSeek-R1-Distill-Qwen-32B-GGUF)
- [DeepSeek-R1-Distill-Qwen-14B-Uncensored-GGU](https://huggingface.co/mradermacher/DeepSeek-R1-Distill-Qwen-14B-Uncensored-GGUF)

**QWen系列**

- [Llamacpp imatrix Quantizations of QwQ-32B by Qwen](https://huggingface.co/bartowski/Qwen_QwQ-32B-GGUF)

**Gemma系列**

- [gemma-3-12b](https://huggingface.co/Mungert/gemma-3-12b-it-gguf/tree/main)
- [gemma-3-27b](https://huggingface.co/unsloth/gemma-3-27b-it-GGUF)
  
## 部署实践

**启动服务**

默认上下文大小为 4096

```
llama-server -m DeepSeek-R1-Distill-Qwen-14B-Uncensored.Q5_K_M.gguf
```

```
build: 4840 (3ffbbd5c) with Apple clang version 14.0.0 (clang-1400.0.29.202) for arm64-apple-darwin23.4.0
system info: n_threads = 8, n_threads_batch = 8, total_threads = 10

system_info: n_threads = 8 (n_threads_batch = 8) / 10 | Metal : EMBED_LIBRARY = 1 | CPU : NEON = 1 | ARM_FMA = 1 | FP16_VA = 1 | DOTPROD = 1 | LLAMAFILE = 1 | ACCELERATE = 1 | AARCH64_REPACK = 1 | 

main: HTTP server is listening, hostname: 127.0.0.1, port: 8080, http threads: 9
main: loading model
srv    load_model: loading model 'DeepSeek-R1-Distill-Qwen-14B-Uncensored.Q5_K_M.gguf'
llama_model_load_from_file_impl: using device Metal (Apple M1 Pro) - 21845 MiB free
llama_model_loader: loaded meta data with 44 key-value pairs and 579 tensors from DeepSeek-R1-Distill-Qwen-14B-Uncensored.Q5_K_M.gguf (version GGUF V3 (latest))
llama_model_loader: Dumping metadata keys/values. Note: KV overrides do not apply in this output.
llama_model_loader: - kv   0:                       general.architecture str              = qwen2
llama_model_loader: - kv   1:                               general.type str              = model
llama_model_loader: - kv   2:                               general.name str              = DeepSeek R1 Distill Qwen 14B Uncensored
llama_model_loader: - kv   3:                           general.finetune str              = Uncensored
llama_model_loader: - kv   4:                           general.basename str              = DeepSeek-R1-Distill-Qwen
llama_model_loader: - kv   5:                         general.size_label str              = 14B
llama_model_loader: - kv   6:                            general.license str              = mit
llama_model_loader: - kv   7:                   general.base_model.count u32              = 1
llama_model_loader: - kv   8:                  general.base_model.0.name str              = DeepSeek R1 Distill Qwen 14B
llama_model_loader: - kv   9:          general.base_model.0.organization str              = Deepseek Ai
llama_model_loader: - kv  10:              general.base_model.0.repo_url str              = https://huggingface.co/deepseek-ai/De...
llama_model_loader: - kv  11:                      general.dataset.count u32              = 1
llama_model_loader: - kv  12:                     general.dataset.0.name str              = Uncensor
llama_model_loader: - kv  13:             general.dataset.0.organization str              = Guilherme34
llama_model_loader: - kv  14:                 general.dataset.0.repo_url str              = https://huggingface.co/Guilherme34/un...
llama_model_loader: - kv  15:                               general.tags arr[str,1]       = ["generated_from_trainer"]
llama_model_loader: - kv  16:                          qwen2.block_count u32              = 48
llama_model_loader: - kv  17:                       qwen2.context_length u32              = 131072
llama_model_loader: - kv  18:                     qwen2.embedding_length u32              = 5120
llama_model_loader: - kv  19:                  qwen2.feed_forward_length u32              = 13824
llama_model_loader: - kv  20:                 qwen2.attention.head_count u32              = 40
llama_model_loader: - kv  21:              qwen2.attention.head_count_kv u32              = 8
llama_model_loader: - kv  22:                       qwen2.rope.freq_base f32              = 1000000.000000
llama_model_loader: - kv  23:     qwen2.attention.layer_norm_rms_epsilon f32              = 0.000010
llama_model_loader: - kv  24:                       tokenizer.ggml.model str              = gpt2
llama_model_loader: - kv  25:                         tokenizer.ggml.pre str              = deepseek-r1-qwen
llama_model_loader: - kv  26:                      tokenizer.ggml.tokens arr[str,151665]  = ["!", "\"", "#", "$", "%", "&", "'", ...
llama_model_loader: - kv  27:                  tokenizer.ggml.token_type arr[i32,151665]  = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ...
llama_model_loader: - kv  28:                      tokenizer.ggml.merges arr[str,151387]  = ["Ġ Ġ", "ĠĠ ĠĠ", "i n", "Ġ t",...
llama_model_loader: - kv  29:                tokenizer.ggml.bos_token_id u32              = 151646
llama_model_loader: - kv  30:                tokenizer.ggml.eos_token_id u32              = 151643
llama_model_loader: - kv  31:            tokenizer.ggml.padding_token_id u32              = 151643
llama_model_loader: - kv  32:               tokenizer.ggml.add_bos_token bool             = true
llama_model_loader: - kv  33:               tokenizer.ggml.add_eos_token bool             = false
llama_model_loader: - kv  34:                    tokenizer.chat_template str              = 左大括号百分号 if not add_generation_prompt is de...
llama_model_loader: - kv  35:               general.quantization_version u32              = 2
llama_model_loader: - kv  36:                          general.file_type u32              = 17
llama_model_loader: - kv  37:                                general.url str              = https://huggingface.co/mradermacher/D...
llama_model_loader: - kv  38:              mradermacher.quantize_version str              = 2
llama_model_loader: - kv  39:                  mradermacher.quantized_by str              = mradermacher
llama_model_loader: - kv  40:                  mradermacher.quantized_at str              = 2025-01-25T03:07:17+01:00
llama_model_loader: - kv  41:                  mradermacher.quantized_on str              = marco
llama_model_loader: - kv  42:                         general.source.url str              = https://huggingface.co/nicoboss/DeepS...
llama_model_loader: - kv  43:                  mradermacher.convert_type str              = hf
llama_model_loader: - type  f32:  241 tensors
llama_model_loader: - type q5_K:  289 tensors
llama_model_loader: - type q6_K:   49 tensors
print_info: file format = GGUF V3 (latest)
print_info: file type   = Q5_K - Medium
print_info: file size   = 9.78 GiB (5.69 BPW) 
load: special_eos_id is not in special_eog_ids - the tokenizer config may be incorrect
load: special tokens cache size = 22
load: token to piece cache size = 0.9310 MB
print_info: arch             = qwen2
print_info: vocab_only       = 0
print_info: n_ctx_train      = 131072
print_info: n_embd           = 5120
print_info: n_layer          = 48
print_info: n_head           = 40
print_info: n_head_kv        = 8
print_info: n_rot            = 128
print_info: n_swa            = 0
print_info: n_embd_head_k    = 128
print_info: n_embd_head_v    = 128
print_info: n_gqa            = 5
print_info: n_embd_k_gqa     = 1024
print_info: n_embd_v_gqa     = 1024
print_info: f_norm_eps       = 0.0e+00
print_info: f_norm_rms_eps   = 1.0e-05
print_info: f_clamp_kqv      = 0.0e+00
print_info: f_max_alibi_bias = 0.0e+00
print_info: f_logit_scale    = 0.0e+00
print_info: n_ff             = 13824
print_info: n_expert         = 0
print_info: n_expert_used    = 0
print_info: causal attn      = 1
print_info: pooling type     = 0
print_info: rope type        = 2
print_info: rope scaling     = linear
print_info: freq_base_train  = 1000000.0
print_info: freq_scale_train = 1
print_info: n_ctx_orig_yarn  = 131072
print_info: rope_finetuned   = unknown
print_info: ssm_d_conv       = 0
print_info: ssm_d_inner      = 0
print_info: ssm_d_state      = 0
print_info: ssm_dt_rank      = 0
print_info: ssm_dt_b_c_rms   = 0
print_info: model type       = 14B
print_info: model params     = 14.77 B
print_info: general.name     = DeepSeek R1 Distill Qwen 14B Uncensored
print_info: vocab type       = BPE
print_info: n_vocab          = 151665
print_info: n_merges         = 151387
print_info: BOS token        = 151646 '<｜begin▁of▁sentence｜>'
print_info: EOS token        = 151643 '<｜end▁of▁sentence｜>'
print_info: EOT token        = 151643 '<｜end▁of▁sentence｜>'
print_info: PAD token        = 151643 '<｜end▁of▁sentence｜>'
print_info: LF token         = 198 'Ċ'
print_info: FIM PRE token    = 151659 '<|fim_prefix|>'
print_info: FIM SUF token    = 151661 '<|fim_suffix|>'
print_info: FIM MID token    = 151660 '<|fim_middle|>'
print_info: FIM PAD token    = 151662 '<|fim_pad|>'
print_info: FIM REP token    = 151663 '<|repo_name|>'
print_info: FIM SEP token    = 151664 '<|file_sep|>'
print_info: EOG token        = 151643 '<｜end▁of▁sentence｜>'
print_info: EOG token        = 151662 '<|fim_pad|>'
print_info: EOG token        = 151663 '<|repo_name|>'
print_info: EOG token        = 151664 '<|file_sep|>'
print_info: max token length = 256
load_tensors: loading model tensors, this can take a while... (mmap = true)
load_tensors: offloading 48 repeating layers to GPU
load_tensors: offloading output layer to GPU
load_tensors: offloaded 49/49 layers to GPU
load_tensors: Metal_Mapped model buffer size = 10013.43 MiB
load_tensors:   CPU_Mapped model buffer size =   509.13 MiB
..........................................................................................
llama_init_from_model: n_seq_max     = 1
llama_init_from_model: n_ctx         = 4096
llama_init_from_model: n_ctx_per_seq = 4096
llama_init_from_model: n_batch       = 2048
llama_init_from_model: n_ubatch      = 512
llama_init_from_model: flash_attn    = 0
llama_init_from_model: freq_base     = 1000000.0
llama_init_from_model: freq_scale    = 1
llama_init_from_model: n_ctx_per_seq (4096) < n_ctx_train (131072) -- the full capacity of the model will not be utilized
ggml_metal_init: allocating
ggml_metal_init: found device: Apple M1 Pro
ggml_metal_init: picking default device: Apple M1 Pro
ggml_metal_init: using embedded metal library
ggml_metal_init: GPU name:   Apple M1 Pro
ggml_metal_init: GPU family: MTLGPUFamilyApple7  (1007)
ggml_metal_init: GPU family: MTLGPUFamilyCommon3 (3003)
ggml_metal_init: GPU family: MTLGPUFamilyMetal3  (5001)
ggml_metal_init: simdgroup reduction   = true
ggml_metal_init: simdgroup matrix mul. = true
ggml_metal_init: has residency sets    = false
ggml_metal_init: has bfloat            = true
ggml_metal_init: use bfloat            = false
ggml_metal_init: hasUnifiedMemory      = true
ggml_metal_init: recommendedMaxWorkingSetSize  = 22906.50 MB
ggml_metal_init: skipping kernel_get_rows_bf16                     (not supported)
ggml_metal_init: skipping kernel_mul_mv_bf16_f32                   (not supported)
ggml_metal_init: skipping kernel_mul_mv_bf16_f32_1row              (not supported)
ggml_metal_init: skipping kernel_mul_mv_bf16_f32_l4                (not supported)
ggml_metal_init: skipping kernel_mul_mv_bf16_bf16                  (not supported)
ggml_metal_init: skipping kernel_mul_mv_id_bf16_f32                (not supported)
ggml_metal_init: skipping kernel_mul_mm_bf16_f32                   (not supported)
ggml_metal_init: skipping kernel_mul_mm_id_bf16_f32                (not supported)
ggml_metal_init: skipping kernel_flash_attn_ext_bf16_h64           (not supported)
ggml_metal_init: skipping kernel_flash_attn_ext_bf16_h80           (not supported)
ggml_metal_init: skipping kernel_flash_attn_ext_bf16_h96           (not supported)
ggml_metal_init: skipping kernel_flash_attn_ext_bf16_h112          (not supported)
ggml_metal_init: skipping kernel_flash_attn_ext_bf16_h128          (not supported)
ggml_metal_init: skipping kernel_flash_attn_ext_bf16_h256          (not supported)
ggml_metal_init: skipping kernel_flash_attn_ext_vec_bf16_h128      (not supported)
ggml_metal_init: skipping kernel_flash_attn_ext_vec_bf16_h256      (not supported)
ggml_metal_init: skipping kernel_cpy_f32_bf16                      (not supported)
ggml_metal_init: skipping kernel_cpy_bf16_f32                      (not supported)
ggml_metal_init: skipping kernel_cpy_bf16_bf16                     (not supported)
llama_kv_cache_init: kv_size = 4096, offload = 1, type_k = 'f16', type_v = 'f16', n_layer = 48, can_shift = 1
llama_kv_cache_init:      Metal KV buffer size =   768.00 MiB
llama_init_from_model: KV self size  =  768.00 MiB, K (f16):  384.00 MiB, V (f16):  384.00 MiB
llama_init_from_model:        CPU  output buffer size =     0.58 MiB
llama_init_from_model:      Metal compute buffer size =   368.00 MiB
llama_init_from_model:        CPU compute buffer size =    18.01 MiB
llama_init_from_model: graph nodes  = 1686
llama_init_from_model: graph splits = 2
common_init_from_params: setting dry_penalty_last_n to ctx_size = 4096
common_init_from_params: warming up the model with an empty run - please wait ... (--no-warmup to disable)
srv          init: initializing slots, n_slots = 1
slot         init: id  0 | task -1 | new slot n_ctx_slot = 4096
main: model loaded
main: chat template, chat_template: 【此处模版信息会影响jekyll引擎解析，作删除处理】, example_format: 'You are a helpful assistant

<｜User｜>Hello<｜Assistant｜>Hi there<｜end▁of▁sentence｜><｜User｜>How are you?<｜Assistant｜>'
main: server is listening on http://127.0.0.1:8080 - starting the main loop
srv  update_slots: all slots are idle

```

上下文窗口能设置的大小和系统显存有关，当上下文窗口设置太大时，启动会报错，如下：

```
# 设置上下文大小为 64K
llama-server -m DeepSeek-R1-Distill-Qwen-14B-Uncensored.Q5_K_M.gguf -c 64000
```

```
build: 4840 (3ffbbd5c) with Apple clang version 14.0.0 (clang-1400.0.29.202) for arm64-apple-darwin23.4.0
system info: n_threads = 8, n_threads_batch = 8, total_threads = 10

system_info: n_threads = 8 (n_threads_batch = 8) / 10 | Metal : EMBED_LIBRARY = 1 | CPU : NEON = 1 | ARM_FMA = 1 | FP16_VA = 1 | DOTPROD = 1 | LLAMAFILE = 1 | ACCELERATE = 1 | AARCH64_REPACK = 1 | 

main: HTTP server is listening, hostname: 127.0.0.1, port: 8080, http threads: 9
main: loading model
srv    load_model: loading model 'DeepSeek-R1-Distill-Qwen-14B-Uncensored.Q5_K_M.gguf'
llama_model_load_from_file_impl: using device Metal (Apple M1 Pro) - 21845 MiB free
llama_model_loader: loaded meta data with 44 key-value pairs and 579 tensors from DeepSeek-R1-Distill-Qwen-14B-Uncensored.Q5_K_M.gguf (version GGUF V3 (latest))
llama_model_loader: Dumping metadata keys/values. Note: KV overrides do not apply in this output.
llama_model_loader: - kv   0:                       general.architecture str              = qwen2
llama_model_loader: - kv   1:                               general.type str              = model
llama_model_loader: - kv   2:                               general.name str              = DeepSeek R1 Distill Qwen 14B Uncensored
llama_model_loader: - kv   3:                           general.finetune str              = Uncensored
llama_model_loader: - kv   4:                           general.basename str              = DeepSeek-R1-Distill-Qwen
llama_model_loader: - kv   5:                         general.size_label str              = 14B
llama_model_loader: - kv   6:                            general.license str              = mit
llama_model_loader: - kv   7:                   general.base_model.count u32              = 1
llama_model_loader: - kv   8:                  general.base_model.0.name str              = DeepSeek R1 Distill Qwen 14B
llama_model_loader: - kv   9:          general.base_model.0.organization str              = Deepseek Ai
llama_model_loader: - kv  10:              general.base_model.0.repo_url str              = https://huggingface.co/deepseek-ai/De...
llama_model_loader: - kv  11:                      general.dataset.count u32              = 1
llama_model_loader: - kv  12:                     general.dataset.0.name str              = Uncensor
llama_model_loader: - kv  13:             general.dataset.0.organization str              = Guilherme34
llama_model_loader: - kv  14:                 general.dataset.0.repo_url str              = https://huggingface.co/Guilherme34/un...
llama_model_loader: - kv  15:                               general.tags arr[str,1]       = ["generated_from_trainer"]
llama_model_loader: - kv  16:                          qwen2.block_count u32              = 48
llama_model_loader: - kv  17:                       qwen2.context_length u32              = 131072
llama_model_loader: - kv  18:                     qwen2.embedding_length u32              = 5120
llama_model_loader: - kv  19:                  qwen2.feed_forward_length u32              = 13824
llama_model_loader: - kv  20:                 qwen2.attention.head_count u32              = 40
llama_model_loader: - kv  21:              qwen2.attention.head_count_kv u32              = 8
llama_model_loader: - kv  22:                       qwen2.rope.freq_base f32              = 1000000.000000
llama_model_loader: - kv  23:     qwen2.attention.layer_norm_rms_epsilon f32              = 0.000010
llama_model_loader: - kv  24:                       tokenizer.ggml.model str              = gpt2
llama_model_loader: - kv  25:                         tokenizer.ggml.pre str              = deepseek-r1-qwen
llama_model_loader: - kv  26:                      tokenizer.ggml.tokens arr[str,151665]  = ["!", "\"", "#", "$", "%", "&", "'", ...
llama_model_loader: - kv  27:                  tokenizer.ggml.token_type arr[i32,151665]  = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ...
llama_model_loader: - kv  28:                      tokenizer.ggml.merges arr[str,151387]  = ["Ġ Ġ", "ĠĠ ĠĠ", "i n", "Ġ t",...
llama_model_loader: - kv  29:                tokenizer.ggml.bos_token_id u32              = 151646
llama_model_loader: - kv  30:                tokenizer.ggml.eos_token_id u32              = 151643
llama_model_loader: - kv  31:            tokenizer.ggml.padding_token_id u32              = 151643
llama_model_loader: - kv  32:               tokenizer.ggml.add_bos_token bool             = true
llama_model_loader: - kv  33:               tokenizer.ggml.add_eos_token bool             = false
llama_model_loader: - kv  34:                    tokenizer.chat_template str              = 左大括号百分号 if not add_generation_prompt is de...
llama_model_loader: - kv  35:               general.quantization_version u32              = 2
llama_model_loader: - kv  36:                          general.file_type u32              = 17
llama_model_loader: - kv  37:                                general.url str              = https://huggingface.co/mradermacher/D...
llama_model_loader: - kv  38:              mradermacher.quantize_version str              = 2
llama_model_loader: - kv  39:                  mradermacher.quantized_by str              = mradermacher
llama_model_loader: - kv  40:                  mradermacher.quantized_at str              = 2025-01-25T03:07:17+01:00
llama_model_loader: - kv  41:                  mradermacher.quantized_on str              = marco
llama_model_loader: - kv  42:                         general.source.url str              = https://huggingface.co/nicoboss/DeepS...
llama_model_loader: - kv  43:                  mradermacher.convert_type str              = hf
llama_model_loader: - type  f32:  241 tensors
llama_model_loader: - type q5_K:  289 tensors
llama_model_loader: - type q6_K:   49 tensors
print_info: file format = GGUF V3 (latest)
print_info: file type   = Q5_K - Medium
print_info: file size   = 9.78 GiB (5.69 BPW) 
load: special_eos_id is not in special_eog_ids - the tokenizer config may be incorrect
load: special tokens cache size = 22
load: token to piece cache size = 0.9310 MB
print_info: arch             = qwen2
print_info: vocab_only       = 0
print_info: n_ctx_train      = 131072
print_info: n_embd           = 5120
print_info: n_layer          = 48
print_info: n_head           = 40
print_info: n_head_kv        = 8
print_info: n_rot            = 128
print_info: n_swa            = 0
print_info: n_embd_head_k    = 128
print_info: n_embd_head_v    = 128
print_info: n_gqa            = 5
print_info: n_embd_k_gqa     = 1024
print_info: n_embd_v_gqa     = 1024
print_info: f_norm_eps       = 0.0e+00
print_info: f_norm_rms_eps   = 1.0e-05
print_info: f_clamp_kqv      = 0.0e+00
print_info: f_max_alibi_bias = 0.0e+00
print_info: f_logit_scale    = 0.0e+00
print_info: n_ff             = 13824
print_info: n_expert         = 0
print_info: n_expert_used    = 0
print_info: causal attn      = 1
print_info: pooling type     = 0
print_info: rope type        = 2
print_info: rope scaling     = linear
print_info: freq_base_train  = 1000000.0
print_info: freq_scale_train = 1
print_info: n_ctx_orig_yarn  = 131072
print_info: rope_finetuned   = unknown
print_info: ssm_d_conv       = 0
print_info: ssm_d_inner      = 0
print_info: ssm_d_state      = 0
print_info: ssm_dt_rank      = 0
print_info: ssm_dt_b_c_rms   = 0
print_info: model type       = 14B
print_info: model params     = 14.77 B
print_info: general.name     = DeepSeek R1 Distill Qwen 14B Uncensored
print_info: vocab type       = BPE
print_info: n_vocab          = 151665
print_info: n_merges         = 151387
print_info: BOS token        = 151646 '<｜begin▁of▁sentence｜>'
print_info: EOS token        = 151643 '<｜end▁of▁sentence｜>'
print_info: EOT token        = 151643 '<｜end▁of▁sentence｜>'
print_info: PAD token        = 151643 '<｜end▁of▁sentence｜>'
print_info: LF token         = 198 'Ċ'
print_info: FIM PRE token    = 151659 '<|fim_prefix|>'
print_info: FIM SUF token    = 151661 '<|fim_suffix|>'
print_info: FIM MID token    = 151660 '<|fim_middle|>'
print_info: FIM PAD token    = 151662 '<|fim_pad|>'
print_info: FIM REP token    = 151663 '<|repo_name|>'
print_info: FIM SEP token    = 151664 '<|file_sep|>'
print_info: EOG token        = 151643 '<｜end▁of▁sentence｜>'
print_info: EOG token        = 151662 '<|fim_pad|>'
print_info: EOG token        = 151663 '<|repo_name|>'
print_info: EOG token        = 151664 '<|file_sep|>'
print_info: max token length = 256
load_tensors: loading model tensors, this can take a while... (mmap = true)
load_tensors: offloading 48 repeating layers to GPU
load_tensors: offloading output layer to GPU
load_tensors: offloaded 49/49 layers to GPU
load_tensors: Metal_Mapped model buffer size = 10013.43 MiB
load_tensors:   CPU_Mapped model buffer size =   509.13 MiB
..........................................................................................
llama_init_from_model: n_seq_max     = 1
llama_init_from_model: n_ctx         = 64000
llama_init_from_model: n_ctx_per_seq = 64000
llama_init_from_model: n_batch       = 2048
llama_init_from_model: n_ubatch      = 512
llama_init_from_model: flash_attn    = 0
llama_init_from_model: freq_base     = 1000000.0
llama_init_from_model: freq_scale    = 1
llama_init_from_model: n_ctx_per_seq (64000) < n_ctx_train (131072) -- the full capacity of the model will not be utilized
ggml_metal_init: allocating
ggml_metal_init: found device: Apple M1 Pro
ggml_metal_init: picking default device: Apple M1 Pro
ggml_metal_init: using embedded metal library
ggml_metal_init: GPU name:   Apple M1 Pro
ggml_metal_init: GPU family: MTLGPUFamilyApple7  (1007)
ggml_metal_init: GPU family: MTLGPUFamilyCommon3 (3003)
ggml_metal_init: GPU family: MTLGPUFamilyMetal3  (5001)
ggml_metal_init: simdgroup reduction   = true
ggml_metal_init: simdgroup matrix mul. = true
ggml_metal_init: has residency sets    = false
ggml_metal_init: has bfloat            = true
ggml_metal_init: use bfloat            = false
ggml_metal_init: hasUnifiedMemory      = true
ggml_metal_init: recommendedMaxWorkingSetSize  = 22906.50 MB
ggml_metal_init: skipping kernel_get_rows_bf16                     (not supported)
ggml_metal_init: skipping kernel_mul_mv_bf16_f32                   (not supported)
ggml_metal_init: skipping kernel_mul_mv_bf16_f32_1row              (not supported)
ggml_metal_init: skipping kernel_mul_mv_bf16_f32_l4                (not supported)
ggml_metal_init: skipping kernel_mul_mv_bf16_bf16                  (not supported)
ggml_metal_init: skipping kernel_mul_mv_id_bf16_f32                (not supported)
ggml_metal_init: skipping kernel_mul_mm_bf16_f32                   (not supported)
ggml_metal_init: skipping kernel_mul_mm_id_bf16_f32                (not supported)
ggml_metal_init: skipping kernel_flash_attn_ext_bf16_h64           (not supported)
ggml_metal_init: skipping kernel_flash_attn_ext_bf16_h80           (not supported)
ggml_metal_init: skipping kernel_flash_attn_ext_bf16_h96           (not supported)
ggml_metal_init: skipping kernel_flash_attn_ext_bf16_h112          (not supported)
ggml_metal_init: skipping kernel_flash_attn_ext_bf16_h128          (not supported)
ggml_metal_init: skipping kernel_flash_attn_ext_bf16_h256          (not supported)
ggml_metal_init: skipping kernel_flash_attn_ext_vec_bf16_h128      (not supported)
ggml_metal_init: skipping kernel_flash_attn_ext_vec_bf16_h256      (not supported)
ggml_metal_init: skipping kernel_cpy_f32_bf16                      (not supported)
ggml_metal_init: skipping kernel_cpy_bf16_f32                      (not supported)
ggml_metal_init: skipping kernel_cpy_bf16_bf16                     (not supported)
llama_kv_cache_init: kv_size = 64000, offload = 1, type_k = 'f16', type_v = 'f16', n_layer = 48, can_shift = 1
llama_kv_cache_init:      Metal KV buffer size = 12000.00 MiB
llama_init_from_model: KV self size  = 12000.00 MiB, K (f16): 6000.00 MiB, V (f16): 6000.00 MiB
llama_init_from_model:        CPU  output buffer size =     0.58 MiB
llama_init_from_model:      Metal compute buffer size =  5165.00 MiB
llama_init_from_model:        CPU compute buffer size =   135.01 MiB
llama_init_from_model: graph nodes  = 1686
llama_init_from_model: graph splits = 2
common_init_from_params: setting dry_penalty_last_n to ctx_size = 64000
common_init_from_params: warming up the model with an empty run - please wait ... (--no-warmup to disable)
ggml_metal_graph_compute: command buffer 1 failed with status 5
error: Insufficient Memory (00000008:kIOGPUCommandBufferCallbackErrorOutOfMemory)
llama_graph_compute: ggml_backend_sched_graph_compute_async failed with error -1
llama_decode: failed to decode, ret = -3
srv          init: initializing slots, n_slots = 1
slot         init: id  0 | task -1 | new slot n_ctx_slot = 64000
main: model loaded
main: chat template, chat_template: 【此处模版信息会影响jekyll引擎解析，作删除处理】, example_format: 'You are a helpful assistant

<｜User｜>Hello<｜Assistant｜>Hi there<｜end▁of▁sentence｜><｜User｜>How are you?<｜Assistant｜>'
main: server is listening on http://127.0.0.1:8080 - starting the main loop
srv  update_slots: all slots are idle

```
