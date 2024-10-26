# 代码覆盖率

## Lcov（cov.info） 格式解析

- [LcovParser lcov覆盖率产物解析器](https://github.com/gbfansheng/LcovParser)

## 增量代码覆盖率 

为了保证代码质量，一般会要求提交的源码要有测试用例覆盖，并对测试覆盖率有一定的要求，在实践中不仅会考核存量代码覆盖率（总体覆盖率）还会考核增量代码的覆盖率。
或者说增量覆盖率更有实际意义，测试用例要随源码一并提交，实时保证源码的质量，而不是代码先行，测试用例后补，这有些应付的意思。
对于存量代码覆盖率主流的测试工具（框架）都是默认支持的，配置reporter相关参数，执行完测试用例就会生成测试报告。
对于增量测试覆盖率主流的测试工具一般没有支持，我想计算增量代码貌似不是测试工具该干的事，所以主流测试工具并没有提供这一功能。

那么如果计算增量覆盖率呢？
计算增量测试覆盖率，总共需要3步

- 计算出增量代码的所有行号
- 计算出测试未覆盖的代码的所有行号
- 对比计算增量代码被测试覆盖的比例，得出增量覆盖率

**参考**

- [如何计算增量测试覆盖率](https://juejin.cn/post/6850418111573655565)
- [jacoco-diff 在 jacoco 覆盖率报告的基础上，计算出增量覆盖率](https://github.com/raoweijian/jacoco-diff)
- [增量代码覆盖率](https://github.com/erduoniba/hdcoverage/blob/master/Coverage_Gather.md)

## 平台
- [DiffTestPlatform 基于python编写的代码变更覆盖率平台](https://github.com/hzlifeng1/DiffTestPlatform)
  
## 参考

