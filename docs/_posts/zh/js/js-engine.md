# JS引擎

## 1. JavaScriptCore

JavaScriptCore 是 WebKit 默认的内嵌 JS 引擎，wikipedia 上都没有独立的词条，只在 WebKit 词条的三级目录[1]里介绍了一下，个人感觉还是有些不像话，毕竟也是老牌 JS 引擎了。

由于 WebKit 是 Apple 率先开源的，所以 WebKit 引擎运用在 Apple 自家的 Safari 浏览器和 WebView 上，尤其是 iOS 系统上，因为 Apple 的限制，所有的网页只能用 WebKit 加载，所以 WebKit 在 iOS 上达到了事实垄断，作为 WebKit 模块一部分的 JSC，顺着政策春风，也「基本」垄断了 iOS 平台的 JS 引擎份额。

垄断归垄断，其实 JSC 的性能还是可以的。

很多人不知道 JSC 的 JIT 功能其实比 V8 还要早，放在十几年前是最好的 JS 引擎，只不过后来被 V8 追了上来。而且 JSC 有个重大利好，在 iOS7 之后，JSC 作为一个系统级的 Framework 开放给开发者使用，也就是说，如果你的 APP 使用 JSC，只需要在项目里 import 一下，包体积是 0 开销的！这点在今天讨论的 JS 引擎中，JSC 是最能打的。

## 2. V8

V8，我想我不用过多解释了，JavaScript 能有如今的地位，V8 功不可没。性能没得说，开启 JIT 后就是业内最强（不止是 JS），有很多介绍 V8 的文章，我这里就不多描述了，我们这里说说 V8 在移动端的表现。

同样作为 Google 家的产品，每一台 Android 手机上都安装了基于 Chromium 的 WebView，V8 也一并捆绑了。但是 V8 和 Chromium 捆绑的太紧密了，不像 iOS 上的 JavaScriptCore 封装为系统库可以被所有 App 调用。这就导致你想在 Android 上用 V8 还得自己封装，社区比较出名的项目是 J2V8[5]，提供了 V8 的 Java bindings 案例。

V8 性能没得说，Android 上可以开启 JIT，但这些优势都是有代价的：开启 JIT 后内存占用高，并且 V8 的包体积也不小（大概 7 MB 左右），如果作为只是画 UI 的 Hybrid 系统，还是有些奢侈了。

## 3. Hermes 

Hermes 是 FaceBook 2019 年中旬开源的一款 JS 引擎，从 release[11] 记录可以看出，这个是专为 React Native 打造的 JS 引擎，可以说从设计之初就是为 Hybrid UI 系统打造。

Hermes 一开始推出就是要替代原来 RN Android 端的 JS 引擎，即 JavaScriptCore（因为 JSC 在 Android 端表现太拉垮了）。我们可以理一下时间线，FaceBook 自从 2019-07-12 宣布 Hermes 开源[12]后，jsc-android[13] 的维护信息就永远的停在了 2019-06-25[14]，这个信号暗示得非常的明显：JavaScriptCore Android 我们不再维护啦，大家都去用我们做的 Hermes 啊。

最近 Hermes 已经计划伴随 React Native 0.64 版本登录 iOS 平台了，但是 RN 版本更新 blog 还没有出，大家可以看看我之前对 Apple 开发者协议的解读：Apple Agreement 3.3.2 规范解读，在这里我就不多说了。

Hermes 的特点主要是两个，一个是不支持 JIT，一个是支持直接生成/加载字节码，我们在下面分开讲一下。

Hermes 不支持 JIT 的主要原因有两个：加入 JIT 后，JS 引擎启动的预热时间会变长，一定程度上会加长首屏 TTI[15]（页面首次加载可交互时间），现在的前端页面都讲究一个秒开，TTI 还是个挺重要的测量指标。另一个问题上 JIT 会增加包体积和内存占用，Chrome 内存占用高 V8 还是要承担一定责任的。

因为不支持 JIT，Hermes 在一些 CPU 密集计算的领域就不占优势了，所以在 Hybrid 系统里，最优的解决方案就是充分发挥 JavaScript 胶水语言的作用，CPU 密集的计算（例如矩阵变换，参数加密等）放在 Native 里做，算好了再传递给 JS 表现在 UI 上，这样可以兼顾性能和开发效率。

Hermes 最引人瞩目的就是支持生成字节码了，我在之前的博文《? 跨端框架的核心技术到底是什么？》也提到过，Hermes 加入 AOT 后，Babel、Minify、Parse 和 Compile 这些流程全部都在开发者电脑上完成，直接下发字节码让 Hermes 运行就行。

## 4. QuickJS 

- [QuickJS 一个小型并且可嵌入的Javascript引擎](https://github.com/quickjs-zh/QuickJS)

正式介绍 QuickJS 前我们先说说它的作者：Fabrice Bellard。

软件界一直有个说法，一个高级程序员创造的价值可以超过 20 个平庸的程序员，但 Fabrice Bellard 不是高级程序员，他是天才，在我看来他的创造力可以超过 20 个高级程序员，我们可以顺着时间轴[20]理一下他创造过些什么：

- 1997年，发布了最快速的计算圆周率的算法，此算法是 Bailey-Borwein-Plouffe 公式的变体，前者的时间复杂度是O(n^3)，他给优化成了O(n^2)，使得计算速度提高了43%，这是他在数学上的成就
- 2000 年，发布了 FFmpeg，这是他在音视频领域的一个成就
- 2000，2001，2018 三年三度获得国际混淆 C 代码大赛
- 2002 年，发布了TinyGL，这是他在图形学领域的成就
- 2005 年，发布了 QEMU，这是他在虚拟化领域的成就
- 2011 年，他用 JavaScript 写了一个 PC 虚拟机 Jslinux，一个跑在浏览器上的 Linux 操作系统
- 2019 年，发布了 QuickJS，一个支持 ES2020 规范的 JS 虚拟机
  
当人和人之间的差距差了几个数量级后，羡慕嫉妒之类的情绪就会转变为崇拜了，Bellard 就是一个这样的人。

收复一下心情，我们来看一下 QuickJS 这个项目。QuickJS 继承了 Fabrice Bellard 作品的一贯特色——小巧而又强大。

QuickJS 体积非常小，只有几个 C 文件，没有乱七八糟的第三方依赖。但是他的功能又非常完善，JS 语法支持到 ES2020[21]，Test262[22] 的测试显示，QuickJS 的语法支持度比 V8 还要高。


## 参考

- [V8、JSCore、Hermes、QuickJS，hybrid开发JS引擎怎么选](https://cloud.tencent.com/developer/article/1801742)
