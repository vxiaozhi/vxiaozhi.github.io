# Python 与 bash 脚本共享配置文件的最佳实践

同一个工程的代码中可能会同时包含 python 代码和 bash 脚本， 不可避免的会用到配置文件。一些场景下，这两种语言需要共享相同的配置。 怎么实现呢？ 有两种方案：

1. 使用不同格式的配置文件，如 Bash 使用 .env 作为配置，Python 则用 json 格式作为配置。
2. 使用相同格式的配置文件，如都使用 .env 或 json 格式作为配置。

显然能用第二种方式肯定是最好的， 因为第一种方式需要两份配置文件可能不一致。

那么用什么格式的配置文件让 bash 和 python 不用第三方库都能很方便的读取呢？

经过我的实践，发现其实只要用 Env 文件即可， 假设配置文件名为 env.list 格式如下：

```
# 项目源码根目录
SOURCE_PROJECT_DIR=/data/home/xx/code-coverage

# 每个文件最低代码覆盖率
MIN_COVERAGE_RATE=0.6

# lcov max remove count
LCOV_MAX_REMOVE_COUNT=10
```

## bash

在bash中通过如下方式读取配置

```
#!/bin/bash

source conf/cov.env

...
```

## Python

python, 通过如下方式启动将配置以环境变量方式导出到python进程：

```
#!/bin/bash

env $(grep -v '^#' conf/cov.env | xargs)  python3 src/main.py
```

main.py 中按照常规方式读取环境变量即可。

```
...
source_project_dir = os.environ.get("SOURCE_PROJECT_DIR", "/xxx")
...
```
