# 基本安装

Gitbook的安装及命令行的快速功能预览说明。

## Node.js安装

![Node.js](../imgs/node.js.png)

> Node.js是一个基于Chrome Javascript运行时建立的一个平台，用来方便的搭建快速的，易于扩展的网络应用。

> Node.js借助事件驱动，非阻塞I/O模型变得轻量和高效，非常适合run across distributed devices的data-intensivede 的实时应用。

Node.js的安装，请参考：

[在 Windows、Mac OS X 與 Linux 中安裝 Node.js 網頁應用程式開發環境](http://www.gtwang.org/2013/12/install-node-js-in-windows-mac-os-x-linux.html)

安装完成之后，可以通过下面的命令来验证一下Node.js是否安装成功。

```zsh
$ node -v
v0.10.33
```

## Gitbook安装

Gitbook是使用NPM来进行安装的，可以在命令行中输入下面的命令进行安装：

```bash
$ npm install gitbook -g
```

安装完成之后，你可以使用下面的命令来检验是否安装成功

```bash
$ gitbook -V
1.5.0
```

如果你看到了上面类似的版本信息，则表示你已经安装成功了。



