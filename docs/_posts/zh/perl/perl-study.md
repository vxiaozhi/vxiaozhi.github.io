# Perl 语言学习

## [Perl](https://github.com/Perl/perl5) 背景

Perl全称为"Practical Extraction and Reporting Language"，意为实用提取和报告语言。

Perl由Larry Wall在1987年创建，其灵感来自于C、sed、awk、shell脚本以及许多其他编程语言的特性。

Perl的哲学是“让每件事都有不止一种方法去做”，并且它的代码通常被称为“程序员的瑞士军刀”。

## Perl 特点

- perl语法类似于C语言（perl源于Unix），语句由逗号划分，代码层次使用花括号{}划分，但是不必声明变量类型；
- 标量变量（$name），数组（@name），哈希结构（%name），类型标识符，文件句柄没有标识符；
- 哈希结构可以使用列表创建，但不要以为它也是由圆括号括起来的；在使用键时，用花括号。（特别注意）
- 数字之间比较用（==、>=、<=、!=），字符串之间比较则用（eq、gt、lt、ge、le）
- print函数，不一定需要括号。几种情况：print $name(直接输出) ；print ‘$name’（基本不用，错误的，原样输出）；          print “$name”（有时会用，会自动替换）; print 函数在做文件输入时（文件句柄），不能有逗号，只能用空格。
- @_ 是函数传参时放置参数的数组，可以从中取实参；$_ 是默认参数的意思，指的是在不指定的情况下，程序处理的上一个变量；shift 是将数组的第一个元素 $array[0] 移走, 并将这个元素回传(return) （堆栈一节有详细讲解）。
- shift函数是取数组的第一个元素，缺省就取@_的第一个函数，这句一般用在程序的开头，用于接收程序的参数，或者子函数的开头，用于接收子函数的参数。
- 句柄和文件的关系，文件必须被打开，并赋与句柄，才能操作；有的句柄可以直接使用，如STDIN、STDERR；广义上，标量变量就是一种代表数据的句柄。
- perl中数值和字符串可以随意的使用递增和递减运算符。

## Perl 模块安装

从 1994 年 10 月 17 日发布的 Perl 5.000 起，Perl 增加了模块的概念，用来提供面向对象编程的能力。这是 Perl 语言发展史上的一个里程碑。此后，广大自由软件爱好者开发了大量功能强大、构思精巧的 Perl 模块，极大地扩展了 Perl 语言的功能。

CPAN，Comprehensive Perl Archive Network（https://www.cpan.org/) 是 Perl 模块最大的集散地，包含了现今公布的几乎所有的 perl 模块。CPAN 从 1995 年 10 月 26 日开始创建，截止 2019 年 4 月该网站已经囊括了超过 13,750 位作者编写的 180,202 个 Perl 模块，其镜像分布在全球在 257 台服务器上。

Perl 作为生物信息数据预处理、文本处理和格式转换中的一把瑞士军刀，其强大和重要性不言而喻。今天，我们在这里主要介绍一下各种平台下 perl 模块的安装方法。以安装 Bio::SeqIO 模块为例。

### 1、Linux 下安装 Perl 模块

Linux/Unix下安装Perl模块有两种方法：手工安装和自动安装。
第一种方法是从 CPAN 上下载您需要的模块，手工编译、安装。第二种方法是使用 CPAN 模块自动完成下载、编译、安装的全过程。

**手工安装**

以 BioPerl-1.7.5 为例：

```
$ tar xvzf BioPerl-1.7.5.tar.gz
$ cd BioPerl-1.7.5
perl Makefile.PL (PREFIX=/home/shenweiyan/perl_modules)
make

# 测试模块(这步可有可无)
make test

make install

# 验证是否安装成功，如果下面的命令没有给出任何输出，那就没问题
perl -MBio::SeqIO -e1
```

**自动安装**

Linux/Unix 下自动安装 Perl 模块主要有两种方法：

- 一是利用 perl -MCPAN -e 'install 模块' 安装；
- 二是直接使用 cpan 的命令执行安装。

这两种方法都是通过与 CPAN 进行交互，然后执行对应模块的自动安装，本质上都是一样的。初次运行CPAN时需要做一些设置，运行下面的命令即可：

```
perl -MCPAN -e shell
```

## 开源项目参考

- [lcov](https://github.com/linux-test-project/lcov)
- [mojo web框架](https://github.com/mojolicious/mojo)
- [Dancer2 轻量级web框架](https://github.com/PerlDancer/Dancer2)
- [MySQLTuner mysql性能调优工具](https://github.com/major/MySQLTuner-perl)

## 参考

- [Perl 教程](https://www.runoob.com/perl/perl-tutorial.html)
