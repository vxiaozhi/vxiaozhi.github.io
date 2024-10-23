# Linux 中C/C++代码通过函数名称字符串发起调用

分两种情况：

## 1. 函数实现在so 中

```
  // 打开动态链接库
    void* handle = dlopen("demo.so", RTLD_LAZY);
    if (!handle) {
        fprintf(stderr, "无法打开动态链接库: %s\n", dlerror());
        return ;
    }

    // 获取函数地址
    void (*myFunction)() = dlsym(handle, "__gcov_dump");
    if (!myFunction) {
        fprintf(stderr, "无法获取函数地址: %s\n", dlerror());
        dlclose(handle);
        return ;
    }
    fprintf(stderr, "gcov_dump addr:%p\n", myFunction);

    // 调用函数
    myFunction();

    // 关闭动态链接库
    dlclose(handle);
```

## 2. 函数实现在主模块中

主模块（编译成 .out 的那个二进制模块）当中的符号，和普通的动态库 `.so`当中的不同。普通的动态库中的符号，只要没有`static` 限制为未局部的，都会成为导出符号，出现在 `.dynsym` 当中。但是，**主模块呢，只有在其他模块，比如 `A .so`中使用和主模块中同名的符号（不论这个符号在`A.so` 还是 `B.so` 当中是否有定义）**，主模块的符号才会成为导出符号，出现在 `.dynsym` 当中。

这个动作由链接器完成，使用 `-Wl,--export-dynamic` 链接器选项即可，或者使用 `-rdynamic` 选项来表达相同的含义。

```
‘-rdynamic’ or ‘-Wl, –-export-dynamic’
```

## 参考

- [通过函数名称字符串发起调用/函数名反射](https://blog.csdn.net/zhouguoqionghai/article/details/121703985)
