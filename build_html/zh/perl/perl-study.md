# Perl 语言学习

## Perl 背景

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

## 开源项目参考

- [lcov](https://github.com/linux-test-project/lcov)
- [mojo web框架](https://github.com/mojolicious/mojo)
- [Dancer2 轻量级web框架](https://github.com/PerlDancer/Dancer2)
- [MySQLTuner mysql性能调优工具](https://github.com/major/MySQLTuner-perl)

## 参考

- [Perl 教程](https://www.runoob.com/perl/perl-tutorial.html)
