# 分布式计算

## [boinc](https://github.com/BOINC/boinc)

- [Wiki索引](https://boinc.berkeley.edu/trac/wiki/TitleIndex)
    - [config.xml 字段说明](https://boinc.berkeley.edu/trac/wiki/ProjectOptions#Schedulingoptionsandparameters)


### 1. 部署服务

**源码编译安装部署**

参考  [Boinc Server搭建](https://boinc.berkeley.edu/trac/wiki/ServerIntro)


**docker部署**

参考 [Boinc Server Docker](https://github.com/marius311/boinc-server-docker)

### 2. 创建项目(Make Project)

参考 [MakeProject](https://boinc.berkeley.edu/trac/wiki/MakeProject)

项目配置： config.xml 选项说明参考：[Project configuration](https://github.com/BOINC/boinc/wiki/ProjectOptions)


### 3. 创建Apps

创建 Boinc [原生App](https://boinc.berkeley.edu/trac/wiki/ExampleApps) 比较麻烦，需要用C/C++编译代码.

可以使用 预制的 [WrapperApp](https://boinc.berkeley.edu/trac/wiki/WrapperApp) 对我们已有的程序进行包装配置即可。

**创建App Version**

AppVersion 和 App 不是一个东西， APPVersion 表示将 APP 和 版本以及平台（Windows/Linux/Mac） 进行绑定后的实体。
管理员可以在界面上通过 Manage application versions 直接修改 AppVersion 的属性值。

AppVersion 的一些属性：

- [AppPlan](https://github.com/BOINC/boinc/wiki/AppPlan) 这个很关键，取值如果填错会导致调度失败,如：`[CRITICAL]   Unknown plan class: xx`

PlanClass 用来设置 AppVersion 的调度策略。如：

- 是否可以在指定host上运行
- 可以使用哪些 GPU、CPU、内存资源
- 运行速度控制

默认内置了一些预定义的PlanClass，如：mt/nci/vbox_64/cuda 等，如果预定义的不能满足需求，则可以自定义，参考：[AppPlanSpec](https://github.com/BOINC/boinc/wiki/AppPlanSpec)


### 4. 提交任务

提交任务通常需要两步：

```
#! /bin/sh

# 先生成输入文件并暂存， 暂存后会为该文件生成一条下载链接。
bin/stage_file input

# 再提交，每次提交后会在work_unit 中插入一条记录，每提交一个新的任务需要用不同的  wu_name 及 input 名字。
bin/create_work --appname worker --wu_name worker_nodelete input
```

create_work 的一些重要参数说明：

- --appname name  
- --wu_name name 
- --wu_template filename ： 指定工作单元输入模板的文件名字，如果不指定默认为： templates/appname_in
- --target_user ID : 将工作单元分配给指定ID的用户。
- --target_nresults n ： 指定工作单元生成的result数量，默认为：2
- --priority n ： 指定优先级


更多可参考：

- [JobSubmission](https://boinc.berkeley.edu/trac/wiki/JobSubmission)
- [任务输入输出模板定义](https://boinc.berkeley.edu/trac/wiki/JobTemplates)
- [远程任务提交](https://github.com/BOINC/boinc/wiki/RemoteJobs#python-binding) 

### 状态查看

参考 [Administrative web interfaces](https://boinc.berkeley.edu/trac/wiki/HtmlOps)

管理员：
- http://127.0.0.1.com/{project}_ops/
- 

### 常用命令行

- ./bin/start
- ./bin/stop
- ./bin/status
- ./bin/create_work 创建任务单元
- ./bin/make_work 【用于测试阶段】将任务单元进行拷贝并维持 N 个未发送的result。 `make_work --wu_name name [--wu_name name2 ... ] --cushion N`
- ./bin/crypt_prog 生成密钥对
- ./bin/sign_executable 对程序签名
- ./bin/show_shmem 查看当前共享内存队列中的 workunit
- ./bin/script_assimilator 用于处理完成的任务，可以在此处理任务完成的后处理，如对出错任务进行告警、重新调度等。
- ./bin/xadd [PHP脚本] 遍历 config.xml 中的 platform 和app 配置，并将其插入到 db 表中。 
- ./bin/update_versions [PHP脚本] 遍历 app 目录下的文件，检查签名，并将其插入到db表中。 

### 实现原理

- [BOINC Design Documents](https://github.com/BOINC/boinc/wiki/SoftwareDevelopment)
- [客户端调度策略](https://github.com/BOINC/boinc/wiki/ClientSched)
- [后台数据库设计](https://github.com/BOINC/boinc/wiki/DataBase)
- [后端程序Scheduler、Transitioner、Validator等的实现逻辑](https://github.com/BOINC/boinc/wiki/BackendLogic)
- [任务大小的设计权衡](https://github.com/BOINC/boinc/wiki/JobSizeMatching)
- [网络交互概览](https://github.com/BOINC/boinc/wiki/CommIntro)
- [服务端调度协议](https://github.com/BOINC/boinc/wiki/RpcProtocol)

**守护进程和任务**

server 端调用 ./bin/start 后会根据 {project}/config.xml 中的daemons 和 tasks 配置开启守护进程和定时任务，一般会开启如下几个守护进程

以下三个守护进程为必需：

- **feeder** The feeder tries to keep the work array filled. 该程序通过共享内存和cgi进行通信，如果不开启，cgi（log_boincserver/scheduler.log） 会打印如下错误： `[CRITICAL] Can't attach shmem: -144 (feeder not running?)`
- **transitioner** 负责 work unit 的状态轮转，如检测result是否完成（超时或者客户端应答）等。
- **file_deleter** 负责清理临时文件， 如 workunit（工作单元）执行完毕后，对应的输入文件如果不再被引用则会被删除。

以下为可选：

- **script_assimilator** An assimilator that runs a script to handle completed jobs, so that you can do assimilation in Python, PHP, Perl, bash, etc.
- **sample_trivial_validator** [可选]，验证任务结果有效性。

常见tasks 有如下：

- run_in_ops ./update_uotd.php
- run_in_ops ./update_forum_activities.php
- update_stats

**核心调度程序**

核心调度程序的入口文件是：`https://github.com/BOINC/boinc/blob/master/sched/sched_main.cpp`， 该程序是一个标准的 cgi 程序，没想到吧！

当boinc客户端请求调度任务时，处理该任务的 是 cgi程序，而不是php。后台的cgi程序包括两个： cgi、file_upload_handler。实现代码均在sched目录中。

这也是为什么 当 AppVersion 配置不对时，打印 `[CRITICAL]   Unknown plan class: xx` 的代码位置是在 cpp 代码中而不是 php 中。

这也是为什么 log_boincserver/*.log 均有对应的守护进程，而 log_boincserver/scheduler.log 却没有对应的 scheduler 进程，因为它是 cgi 程序输出的。

php代码只用来实现用于界面逻辑，如用于登录查看服务器状态、管理员查看内部任务状态等。


**keys管理**

有两类Keys，且是必需。


用于 APP-Version 签名的密钥对

- keys/code_sign_private
- keys/code_sign_public

用于 文件上传的密钥对， 缺失会导致守护进程 transitioner 启动失败。

- keys/upload_private
- keys/upload_public

### 参考：

- [BOINC:使用教程](https://www.equn.com/wiki/BOINC:%E4%BD%BF%E7%94%A8%E6%95%99%E7%A8%8B)
- [Boinc Server搭建](https://boinc.berkeley.edu/trac/wiki/ServerIntro)
- [Boinc Server Docker](https://github.com/marius311/boinc-server-docker)

## ray

## spark
