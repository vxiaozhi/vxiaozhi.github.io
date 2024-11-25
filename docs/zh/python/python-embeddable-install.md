# Python embeddable 版本安装过程记录

- 操作系统： Win11
- Python版本： Python 3.10


## Step 1: 安装Python3.10

从下载列表 [Python3.10](https://www.python.org/downloads/release/python-3100/) 可以看出，Installer版本的安装文件大小比Embeddable版本大很多。

```
Windows installer (32-bit) 25.9M
Windows embeddable package (64-bit)  8.1M
```

下好之后，解压到一个文件夹就行，这时候进去这个文件夹，是不会看到 "Scripts"，也不会看到 "Lib/site-packages"。所以这个python本身不带pip。 

```
$ tree
.
├── LICENSE.txt
├── _asyncio.pyd
├── _bz2.pyd
├── _ctypes.pyd
├── _decimal.pyd
├── _elementtree.pyd
├── _hashlib.pyd
├── _lzma.pyd
├── _msi.pyd
├── _multiprocessing.pyd
├── _overlapped.pyd
├── _queue.pyd
├── _socket.pyd
├── _sqlite3.pyd
├── _ssl.pyd
├── _uuid.pyd
├── _zoneinfo.pyd
├── libcrypto-1_1.dll
├── libffi-7.dll
├── libssl-1_1.dll
├── pyexpat.pyd
├── python.cat
├── python.exe
├── python3.dll
├── python310._pth
├── python310.dll
├── python310.zip
├── pythonw.exe
├── select.pyd
├── sqlite3.dll
├── unicodedata.pyd
├── vcruntime140.dll
├── vcruntime140_1.dll
└── winsound.pyd

0 directories, 34 files
```

可以打开一个cmd窗口验证一下，运行python打开console，然后如下退出 （或者按Ctrl+z）：

```
import sys
sys.exit() 
```

## Step 2: 安装pip

- [get-pip.py github](https://github.com/pypa/get-pip)

下载安装程序 (get-pip.py)[https://bootstrap.pypa.io/get-pip.py]，把它保存成为文件 "get-pip.py"，放在随便一个目录即可。然后在cmd命令行进入到该路径，执行 python get-pip.py，之后会看到，该脚本把pip, setuptools, wheel三个东西都装好了，默认安装到了 "Lib\site-packages\" 路径，并添加了 "Scripts\" 里面的几个执行文件。

本以为pip已经可以用了，但这时候无论是执行 "pip"，还是执行 "python -m pip"，都失败，说找不到mudule pip。这时候想通过配置 "PYTHONPATH" 环境变量来指向site-packages文件夹，但不起效，原因未知。

最后找到文件 "python310._pth"，在原有的内容下面添加一行 (注意：路径可用相对路径，即相对于python.exe的路径；反斜杠不用转义处理):

```
Lib\site-packages\
```

这一行指向新安装的pip等模块所在的site-packages文件夹。保存后新开个cmd窗口再执行pip，就没问题了。

## Step 3: 验证

关于验证系统python的module查找路径，可以执行 python -m site，它会输出当前python的模块寻址路径，可用于检验你的路径配置。
