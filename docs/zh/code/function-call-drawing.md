# 函数调用关系绘制

## 简介

cflow是一款静态分析C语言代码的工具，通过它可以生成函数调用关系。

该工具能够生成两种图：直接图和反向图。直接图以main函数(main)开始，递归地显示它调用的所有函数。相反，反向图是一组子图，以相反的顺序为每个函数的调用者绘制图表。由于它们的树状外观，图也可以称为树。

除了这两种输出模式之外，cflow还能够生成输入文件中遇到的所有符号的一个交叉引用列表。

该工具还提供了对输出中出现的符号的详细控制，允许省略用户不感兴趣的符号。输出图的确切外观也是可配置的。

- 官网：https://www.gnu.org/software/cflow/
- 下载：http://ftp.gnu.org/gnu/cflow/
- 手册：https://www.gnu.org/software/cflow/manual/index.html


## 参考

- [GNU cflow](https://www.gnu.org/software/cflow/)
- [使用 cflow 绘制函数的调用图](https://blog.csdn.net/qq_23599965/article/details/88839012)
