---
layout:     post
title:      "python3开发环境搭建"
subtitle:   "python3开发环境搭建"
date:       2025-09-20
author:     "vxiaozhi"
catalog: true
tags:
    - python
---

## 版本选择

建议使用 Python 3.10.x 以上版本，因为 3.8 版本已经不再支持。
例如，在 mac 安装 python3.8报错：

```
==> Fetching downloads for: python@3.8
Error: python@3.8 has been disabled because it is deprecated upstream! It was disabled on 2024-10-14.
```

## Ubuntu 20.04 上安装 Python 3.10

在 Ubuntu 20.04 上安装 Python 3.10 是一个非常常见的需求，因为 20.04 自带的版本是 3.8。有几种可靠的方法，**强烈推荐使用 Deadsnakes PPA**，这是最官方、最便捷的方式。

`Deadsnakes` 是一个专门为 Ubuntu 提供新旧 Python 版本的第三方软件源，维护得很好，非常流行。

1.  **更新系统包列表**
    首先确保你的系统包列表是最新的。
    ```bash
    sudo apt update
    ```

2.  **安装预备依赖**
    安装一些编译和添加 PPA 所需的软件包。
    ```bash
    sudo apt install software-properties-common -y
    ```

3.  **添加 Deadsnakes PPA**
    将包含 Python 3.10 的软件源添加到你的系统中。
    ```bash
    sudo add-apt-repository ppa:deadsnakes/ppa
    ```
    出现提示时，按 `Enter` 键继续。

4.  **再次更新包列表**
    添加 PPA 后，需要再次更新，以便 APT 能识别到新源的软件包。
    ```bash
    sudo apt update
    ```

5.  **安装 Python 3.10**
    现在你可以安装 Python 3.10 解释器和 `pip`。
    ```bash
    sudo apt install python3.10 python3.10-venv python3.10-dev -y
    ```
    - `python3.10`: Python 3.10 解释器
    - `python3.10-venv`: 用于创建 Python 3.10 虚拟环境的模块
    - `python3.10-dev`: 包含开发头文件和静态库，编译某些依赖 C 扩展的包（如 `NumPy`）时必需

### dockerfile 示例

```
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN echo "deb http://mirrors.tencent.com/ubuntu/ focal main restricted universe multiverse \n" \
    "deb http://mirrors.tencent.com/ubuntu/ focal-security main restricted universe multiverse \n" \
    "deb http://mirrors.tencent.com/ubuntu/ focal-updates main restricted universe multiverse \n" \
    "deb-src http://mirrors.tencent.com/ubuntu/ focal main restricted universe multiverse \n" \
    "deb-src http://mirrors.tencent.com/ubuntu/ focal-security main restricted universe multiverse \n" \
    "deb-src http://mirrors.tencent.com/ubuntu/ focal-updates main restricted universe multiverse \n" \
    > /etc/apt/sources.list

RUN apt-get update \
    && apt-get install -y bash \
                   build-essential \
                   zip unzip dnsutils \
                   curl \
                   vim \
                   wget \
                   ca-certificates \
                   libsndfile1-dev \
                   fontconfig \
                   xfonts-utils \
                   ttf-mscorefonts-installer \
                   protobuf-compiler \
                   software-properties-common \
                   && rm -rf /var/lib/apt/lists 

RUN apt remove -y python3-yaml 
RUN add-apt-repository ppa:deadsnakes/ppa && apt update && apt install python3.10 python3.10-venv python3.10-dev -y && rm -rf /var/lib/apt/lists 
RUN python3.10 -m ensurepip --upgrade && python3.10 -m pip install --no-cache-dir --upgrade pip setuptools wheel
RUN mkdir -p /usr/share/fonts/myfonts

RUN mkdir /data
WORKDIR /data

COPY requirements.txt /data/requirements.txt
RUN python3.10 -m pip uninstall -y PyYAML || true
RUN python3.10 -m pip install -r requirements.txt

```


##  Python 3.10 创建虚拟环境？

这是最佳实践，可以为每个项目隔离依赖。

```bash
# 创建名为 'my_venv' 的虚拟环境
python3.10 -m venv my_venv

# 激活虚拟环境
source my_venv/bin/activate

# 激活后，提示符前会出现 (my_venv)
# 此时使用的 python 和 pip 命令都在这个虚拟环境内
(my_venv) $ python --version
Python 3.10.12
(my_venv) $ pip install requests

# 退出虚拟环境
deactivate
```

## Python 3.10 配置静态类型检测

mypy.ini

```
[mypy]
python_version = 3.10
warn_return_any = True
disallow_untyped_defs = False

# 包含的目录
files = server/,  tests/

# 排除的目录
exclude = .venv/|.*/migrations/|.*/__pycache__/


# 忽略 protobuf 相关的模块错误
[mypy-google.*]
follow_imports = skip

[mypy-server.proto.*]
follow_imports = skip

```

