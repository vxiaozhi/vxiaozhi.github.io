# Boinc 任务分配

参考 [AssignedWork](https://github.com/BOINC/boinc/wiki/AssignedWork)

任务分配分两种情况 广播(Broadcast) 和 绑定（targeted jobs）

先从从任务提交命令说起。

```
bin/create_work --appname worker --wu_name worker_nodelete input
```

create_work 的一些重要参数说明：

- --appname name
- --app_version_num N ： 指定应用版本号
- --wu_name name 任务单元名字，不能重复。可以省略，默认不填的话，系统会分配一个不重复的值。
- --wu_template filename ： 指定工作单元输入模板的文件名字，如果不指定默认为： templates/appname_in
- --target_user ID : 将工作单元分配给指定ID的用户。
- --target_host ID target the job to the given host
- --target_nresults n ： 指定工作单元生成的result数量，默认为：2
- --priority n ： 指定优先级
- --broadcast 任务广播给所有主机
- --broadcast_user ID 任务广播给指定用户
- --broadcast_team ID 任务广播给指定team的所有主机
- --stdin 用于读取一个文件列表， 一次提交多个workunit。

广播 和 绑定的区别在于：

- 如果广播的任务失败不会重试， 而绑定的任务（targeted job）则会重试。
- 开启任务广播，需要 config.xml 中添加 <enable_assignment_multi>1</enable_assignment_multi>， 开启绑定则添加 <enable_assignment>1</enable_assignment>

任务绑定的应用场景：

- 当我们需要将某个任务指定给特定主机执行时，则用 --target_host 参数
- 当需要将任务指定给一组主机执行时，可以用 --target_user 参数， 而这一组主机用同一个账号登录即可。

特别说明：

当任务被绑定时， the workunit.transitioner_flags field is set to TRANSITION_NO_NEW_RESULTS（值为：2）. This tells the transitioner to not create instances of the job; 

所以提交一个绑定的任务单元时， 不会直接在result表里不会创建记录， 其记录创建在 assignment 表里，然后当有host被分配到该任务后，再在result表里创建记录。

**提交workunit的最佳实践**

可以参考命令：./bin/sample_work_generator , 该命令是 test_app 自带的任务生成器。主要思路总结如下：

1、将切片文件提前准备好，并进行编号，存储在云端（比如：cos）进行管理。
2、提workunit之前先生成input文件，input文件内容为：切片编号。再提交。
3、为了避免一次提交太多的工作单元导致难以管理， 可以对提交进行限速，具体做法为：提交前先调用 ./bin/wu_check 获取未发送的result的数量，只有result 数量小于设定的阈值（比如最多10）时再进行提交。


## 任务限制

任务限制可以用来限定每个主机上运行的任务实例的数量，通过配置可以用来详细制定cpu、gpu 、project、app等维度的详细控制规则。

实现代码在以下文件中：

```
sched_limit.cpp
sched_limit.h
```

配置时，需要结合 config.xml 中的以下字段：

```
<max_wus_in_progress> N </max_wus_in_progress>
<max_wus_in_progress_gpu> M </max_wus_in_progress_gpu>
```

以及  **config_aux.xml** 中的 max_jobs_in_progress 字段来控制， config_aux.xml格式如下：

```xml
<?xml version="1.0" ?>
<config>
<max_jobs_in_progress>
	<project>
		<total_limit>
			<jobs>N</jobs>
		</total_limit>
		[ <gpu_limit> ]
			<jobs>N</jobs>
			[ <per_proc/> ]
				if set, limit is per processor
		[ <cpu_limit> ]
		...
	</project>
	<app>
		<app_name>name</app_name>
		[ <total_limit> ... ]
		[ <cpu_limit> ... ]
		[ <gpu_limit> ... ]
	</app>
	...
</max_jobs_in_progress>
</config>
```

