# Linux LD_PRELOAD 技术介绍

##  LD_PRELOAD介绍

LD_PRELOAD是Linux/Unix系统的一个环境变量，它可以影响程序的运行时的链接，它允许在程序运行前定义优先加载的动态链接库。通过这个环境变量，可以在主程序和其动态链接库的中间加载别的动态链接库，甚至覆盖系统的函数库。

具体来说， Linux操作系统的动态链接库在加载过程中，动态链接器会先读取LD_PRELOAD环境变量和默认配置文件/etc/ld.so.preload，并将读取到的动态链接库文件进行预加载。即使程序不依赖这些动态链接库，LD_PRELOAD环境变量和/etc/ld.so.preload配置文件中指定的动态链接库依然会被加载，因为它们的优先级比LD_LIBRARY_PATH环境变量所定义的链接库查找路径的文件优先级要高，所以能够提前于用户调用的动态库载入。

简单来说LD_PRELOAD的加载是最优先级的我们可以用他来做一些有趣的操作(骚操作).

一般情况下，ld-linux.so加载动态链接库的顺序为：

```
LD_PRELOAD > LD_LIBRARY_PATH > /etc/ld.so.cache > /lib > /usr/lib
```

使用LD_PRELOAD可以实现一些特殊的功能，例如：

- 动态库劫持：可以用LD_PRELOAD来劫持程序中的函数，替换为自己编写的函数，实现一些特殊的功能。

- 程序调试：可以用LD_PRELOAD来替换程序中的函数，增加一些调试信息，例如，在程序中调用printf函数时，可以用LD_PRELOAD来替换为自己编写的函数，输出调试信息。

- 库版本控制：可以用LD_PRELOAD来强制程序使用指定版本的共享库，以避免程序在不同版本的环境中产生兼容性问题。

需要注意的是，使用LD_PRELOAD需要注意一些安全和兼容性问题。为了避免程序崩溃或产生意外的行为，替换的函数必须与被替换的函数具有相同的函数原型和行为。在使用LD_PRELOAD时需要注意共享库与程序之间的交互，避免产生意外的结果。



## 应用场景

- 劫持 whoami 这个骚操作能用在什么地方就不用了多说了吧.
- 劫持 strcmp 这个骚操作能用在什么地方也不用了多说了吧.
- 劫持 内存分配函数， 如 tcmalloc 的使用方式
- 在so中调用 主进程中的函数， 如 覆盖率分析中，在so中调用主进程的 `__gcov_flush()` 函数可以做到对被分析的进程零入侵。

## 参考

- [LD_PRELOAD基础用法](https://ivanzz1001.github.io/records/post/linux/2018/04/08/linux-ld-preload)
- [LD_PRELOAD的偷梁换柱之能 ](https://www.cnblogs.com/net66/p/5609026.html)
- [【程序狂魔】掌握LD_PRELOAD轻松进行程序修改和优化的绝佳方法！](https://blog.csdn.net/Long_xu/article/details/128897509)
- [LD_PRELOAD机制在安全领域的攻击面探析](https://xz.aliyun.com/t/13671?time__1311=GqmxuD9DgD00iQD%2F725BK%2B4ZYei%3DNQDnBaoD)
- [干货 | Linux下权限维持实战](https://cloud.tencent.com/developer/article/1895859)
- [Linux 通过LD_PRELOAD实现进程隐藏](https://jiushill.github.io/posts/906527f2.html)