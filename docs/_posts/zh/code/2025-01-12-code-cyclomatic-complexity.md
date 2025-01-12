---
layout:     post
title:      "详解圈复杂度"
subtitle:   "详解圈复杂度"
date:       2025-01-12
author:     "vxiaozhi"
catalog: true
tags:
    - code
    - 圈复杂度
---

# 详解圈复杂度

## 什么是圈复杂度？

圈复杂度(Cyclomatic complexity)是一种代码复杂度的衡量标准，在1976年由Thomas J. McCabe, Sr. 提出，目标是为了指导程序员写出更具可测性和可维护性的代码。

它可以用来衡量一个模块判定结构的复杂程度，数量上表现为独立路径条数，也可以理解为覆盖所有可能的情况最少需要的测试用例数量。 

圈复杂度大说明程序代码质量低且难于测试和维护，根据经验，高的圈复杂度和程序出错的可能性和有着很大关系。

代码覆盖率和代码圈复杂度有什么关系呢，下面一个例子说明100%代码覆盖率的单元测试并不表示测试了代码的全部执行路径，

下面的程序：

```
int foo(bool isOK)
{
    const int ZERO = 0;
    int* pInt = NULL;
    if (isOk)
    {
        pInt = &ZERO;
    }
    return *pInt;
}
```


上面代码的圈复杂度为２，如果仅仅测试一种情况: foo(true); 结果是，测试通过，并具有100%的代码覆盖率, 但测试foo(false)就会失败。可见圈复杂度非常重要，良好的测试应该覆盖程序的所有执行路径，即用例的个数至少应该等于方法的圈复杂度。


## 意义

- 提前发现代码缺陷
- 具有更好的可测性&可维护性

## 代码圈复杂度的计算方法

通常采用的计算方法为点边计算法（当然还有节点判定法），计算公式为：

```
V(G) = e – n + 2
```

## 降低圈复杂度的方法

## 圈复杂度计算工具

### 1. [lizard](https://github.com/terryyin/lizard)

### 2. [OCLint](https://github.com/oclint/oclint)

OCLint is a static code analysis tool for improving quality and reducing defects by inspecting C, C++ and Objective-C code.
(它通过检查 C、C++、Objective-C 代码来寻找潜在问题，来提高代码质量并减少缺陷的静态代码分析工具)

It looks for potential problems that aren't visible to compilers, for example:

- Possible bugs - empty if/else/try/catch/finally statements
- Unused code - unused local variables and parameters
- Complicated code - high cyclomatic complexity, NPath complexity and high NCSS
- Redundant code - redundant if statement and useless parentheses
- Code smells - long method and long parameter list
- Bad practices - inverted logic and parameter reassignment

### 3. [CppNcss](https://cppncss.sourceforge.net/)

### 4. [CCCC (C and C++ Code Counter)](https://github.com/sarnold/cccc)

## 参考

- [详解圈复杂度](https://kaelzhang81.github.io/2017/06/18/%E8%AF%A6%E8%A7%A3%E5%9C%88%E5%A4%8D%E6%9D%82%E5%BA%A6/)
- [圈复杂度详解以及解决圈复杂度常用的方法](https://blog.csdn.net/u010684134/article/details/94410027)
