# 图书项目结构

```README.md```和```SUMMARY.md```
是Gitbook项目必备的两个文件，也就是一本最简单的gitbook也必须含有这两个文件，它们在一本Gitbook中具有不同的用处。

## README.md 与 SUMMARY编写

## 使用语法

在Gitbook中所有文字的编写都使用```Markdown```语法。

## README.md

这个文件相对于是一本Gitbook的简介，比如我们这本书的```README.md``` :

```
# Gitbook 使用入门


> GitBook 是一个基于 Node.js 的命令行工具，可使用 Github/Git 和 Markdown 来制作精美的电子书。

本书将简单介绍如何安装、编写、生成、发布一本在线图书。
```

## SUMMARY.md

这个文件相对于是一本书的目录结构。比如我们这本书的```SUMMARY.md``` :


```
# Summary

* [Introduction](README.md)
* [基本安装](howtouse/README.md)
   * [Node.js安装](howtouse/nodejsinstall.md)
   * [Gitbook安装](howtouse/gitbookinstall.md)
   * [Gitbook命令行速览](howtouse/gitbookcli.md)
* [图书项目结构](book/README.md)
   * [README.md 与 SUMMARY编写](book/file.md)
   * [目录初始化](book/prjinit.md)
* [图书输出](output/README.md)
   * [输出为静态网站](output/outfile.md)
   * [输出PDF](output/pdfandebook.md)
* [发布](publish/README.md)
   * [发布到Github Pages](publish/gitpages.md)
* [结束](end/README.md)
```

```SUMMARY.md```基本上是列表加链接的语法。链接中可以使用目录，也可以使用。

## 目录初始化

当```SUMMARY.md```创建完毕之后，我们可以使用Gitbook的命令行工具将这个目目录结构生成相应地目录及文件

```bash
$ gitbook init

$ ls
README.md    SUMMARY.md    book    end    howtouse    output    publish

$tree
.
├── LICENSE
├── README.md
├── SUMMARY.md
├── book
│   ├── README.md
│   ├── file.md
│   └── prjinit.md
├── howtouse
│   ├── Nodejsinstall.md
│   ├── README.md
│   ├── gitbookcli.md
│   └── gitbookinstall.md
├── output
│   ├── README.md
│   ├── outfile.md
│   └── pdfandebook.md
└── publish
    ├── README.md
    └── gitpages.md
```

我们可以看到，gitbook给我们生成了与```SUMMARY.md```所对应的目录及文件。

每个目录中，都有一个```README.md```文件，用于描述这一章的说明。



