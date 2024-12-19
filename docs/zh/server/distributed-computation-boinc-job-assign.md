# Boinc 任务分配

参考 [AssignedWork](https://github.com/BOINC/boinc/wiki/AssignedWork)

任务分配分两种情况 广播(Broadcast) 和 绑定（targeted jobs）

先从从任务提交命令说起。

```
bin/create_work --appname worker --wu_name worker_nodelete input
```

create_work 的一些重要参数说明：

- --appname name
- --wu_name name
- --wu_template filename ： 指定工作单元输入模板的文件名字，如果不指定默认为： templates/appname_in
- --target_user ID : 将工作单元分配给指定ID的用户。
- --target_host ID target the job to the given host
- --target_nresults n ： 指定工作单元生成的result数量，默认为：2
- --priority n ： 指定优先级
- --broadcast 任务广播给所有主机
- --broadcast_user ID 任务广播给指定用户
- --broadcast_team ID 任务广播给指定team的所有主机

广播 和 绑定的区别在于：

- 如果广播的任务失败不会重试， 而绑定的任务（targeted job）则会重试。
- 开启任务广播，需要 config.xml 中添加 <enable_assignment_multi>1</enable_assignment_multi>， 开启绑定则添加 <enable_assignment>1</enable_assignment>

任务绑定的应用场景：

- 当我们需要将某个任务指定给特定主机执行时，则用 --target_host 参数
- 当需要将任务指定给一组主机执行时，可以用 --target_user 参数， 而这一组主机用同一个账号登录即可。

特别说明：

当任务被绑定时， the workunit.transitioner_flags field is set to TRANSITION_NO_NEW_RESULTS（值为：2）. This tells the transitioner to not create instances of the job; 

所以提交一个绑定的任务单元时， 不会直接在result表里不会创建记录， 其记录创建在 assignment 表里，然后当有host被分配到该任务后，再在result表里创建记录。

