# 分布式计算

## [boinc](https://github.com/BOINC/boinc)

### 1. 部署服务
   参考  [Boinc Server搭建](https://boinc.berkeley.edu/trac/wiki/ServerIntro)
   
   建议使用docker搭建,参考 [Boinc Server Docker](https://github.com/marius311/boinc-server-docker)

   ```
   git clone https://github.com/marius311/boinc-server-docker.git
    cd boinc-server-docker
    docker-compose pull
    docker-compose up -d
   ```
   
   执行 docker-compose up 前， 确定 .env 中 的URL_BASE 设置正常
   
   ```
   # the URL the server thinks its at
  URL_BASE=http://127.0.0.1
   ```

### 2. 创建项目(Make Project)

参考 [MakeProject](https://boinc.berkeley.edu/trac/wiki/MakeProject)


### 3. 创建Apps

创建 Boinc [原生App](https://boinc.berkeley.edu/trac/wiki/ExampleApps) 比较麻烦，需要用C/C++编译代码.

可以使用 预制的 [WrapperApp](https://boinc.berkeley.edu/trac/wiki/WrapperApp) 对我们已有的程序进行包装配置即可。

### 状态查看

参考 [Administrative web interfaces](https://boinc.berkeley.edu/trac/wiki/HtmlOps)


参考：

- [BOINC:使用教程](https://www.equn.com/wiki/BOINC:%E4%BD%BF%E7%94%A8%E6%95%99%E7%A8%8B)
- [Boinc Server搭建](https://boinc.berkeley.edu/trac/wiki/ServerIntro)
- [Boinc Server Docker](https://github.com/marius311/boinc-server-docker)

## ray

## spark
