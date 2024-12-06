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

**创建App Version**

AppVersion 和 App 不是一个东西， APPVersion 表示将 APP 和 版本以及平台（Windows/Linux/Mac） 进行绑定后的实体。
管理员可以在界面上通过 Manage application versions 直接修改 AppVersion 的属性值。

AppVersion 的一些属性：

- [AppPlan](https://github.com/BOINC/boinc/wiki/AppPlan) 这个很关键，取值如果填错会导致调度失败,如：`[CRITICAL]   Unknown plan class: xx`
  


### 4. 提交任务

- [JobSubmission](https://boinc.berkeley.edu/trac/wiki/JobSubmission)
- [任务输入输出模板定义](https://boinc.berkeley.edu/trac/wiki/JobTemplates)

- [远程任务提交](https://github.com/BOINC/boinc/wiki/RemoteJobs#python-binding) 

### 状态查看

参考 [Administrative web interfaces](https://boinc.berkeley.edu/trac/wiki/HtmlOps)

管理员：
- http://127.0.0.1.com/{project}_ops/
- 

### 实现原理

- [BOINC Design Documents](https://github.com/BOINC/boinc/wiki/SoftwareDevelopment)

**守护进程和任务**

server 端调用 ./bin/start 后会根据 {project}/config.xml 中的daemons 和 tasks 配置开启守护进程和定时任务，一般会开启如下几个守护进程

- feeder The feeder tries to keep the work array filled.
- transitioner 负责 work unit 的状态轮转，如检测任务是否超时等。
- file_deleter
- **script_assimilator** An assimilator that runs a script to handle completed jobs, so that you can do assimilation in Python, PHP, Perl, bash, etc.
- sample_trivial_validator

常见tasks 有如下：

- run_in_ops ./update_uotd.php
- run_in_ops ./update_forum_activities.php
- update_stats

**核心调度程序**

核心调度程序的入口文件是：`https://github.com/BOINC/boinc/blob/master/sched/sched_main.cpp`
该程序是一个标准的 cgi 程序，没想到吧！

当boinc客户端请求调度任务时，处理该任务的 是 cgi程序，而不是php。后台的cgi程序包括两个： cgi、file_upload_handler。实现代码均在sched目录中。
这也是为什么 当 AppVersion 配置不对时，打印 `[CRITICAL]   Unknown plan class: xx` 的代码位置是在 cpp 代码中而不是 php 中。
这也是为什么 log_boincserver/*.log 均有对应的守护进程，而 log_boincserver/scheduler.log 却没有对应的 scheduler 进程，因为它是 cgi 程序输出的。

php代码只用来实现用于界面逻辑，如用于登录查看服务器状态、管理员查看内部任务状态等。




### 参考：

- [BOINC:使用教程](https://www.equn.com/wiki/BOINC:%E4%BD%BF%E7%94%A8%E6%95%99%E7%A8%8B)
- [Boinc Server搭建](https://boinc.berkeley.edu/trac/wiki/ServerIntro)
- [Boinc Server Docker](https://github.com/marius311/boinc-server-docker)

## ray

## spark
