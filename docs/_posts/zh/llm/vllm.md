# vLLM

vLLM 是一个快速且易于使用的库，用于 LLM 推理和服务，和 HuggingFace 无缝集成。区别于 chatglm.cpp 和 llama.cpp，仅是在 GPU 上的模型推理加速，没有 CPU 上的加速。

在吞吐量方面，vLLM 的性能比 HuggingFace Transformers  （HF） 高出 24 倍，文本生成推理 （TGI） 高出 3.5 倍。

可以使用 ray 框架实现分布式推理：https://vllm.readthedocs.io/en/latest/serving/distributed_serving.html


## 参考

- [使用vLLM加速大语言模型推理](https://cloud.tencent.com/developer/article/2328353)
- [vllm github地址](https://github.com/vllm-project/vllm)
