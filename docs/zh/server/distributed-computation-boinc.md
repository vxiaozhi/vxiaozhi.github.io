# 分布式计算平台-Boinc 


## App 定义

- [Boinc App介绍](https://github.com/BOINC/boinc/wiki/BOINC-apps-(introduction))

BOINC中, 'app' 是程序的抽象， 每个App由一个唯一的名字标识。

app version 是一个特定的App版本。 AppVersion = Platform + VersionNumber + version.xml + Input/Output Templates。

## 最佳实践

AppVersion的更新以及任务单元的创建通常会是一个高频的操作。提供的命令行只能在本地操作：

- ./bin/update_versions
- ./bin/create_work

这样会带来很多不便。最佳的办法是：

AppVersion 可以打包后采用第三方云存储如cos进行管理， 本地实现一个定时脚本，定时检测如果由最新AppVersion则拉取到本地，然后进行签名、更新等操作。

任务单元的创建，虽然Boinc官方提供了python远程提交等方式，但是使用起来很麻烦。官方也没有说明 Python 库要如何安装。我认为这里不如自己封装一个HTTP API来实现远程调用，可以部署一个 WebHook Server 如：[golang webhook](https://github.com/adnanh/webhook), 来实现远程调用命令行。
这样也几乎是不用开发，通过配置即可实现。


## 示例

以 Wrapper 为例，记录其部署流程。

假设我们的程序名为： worker.exe, 其运行过程还依赖于当前目录下 _internal/*.dll. 

**创建如下目录结构**

```
apps/
   worker/
      1.0/
         windows_intelx86/
```
注意： windows_intelx86 要根据不同平台设置不同值， 例如：win64位应该是：windows_x86_64. 当前支持的所有平台可在 project.xml 查询到并配置。

`

**创建 job**
worker_job_1.0.xml

```
<job_desc>
    <task>
        <application>worker</application>
        <command_line>10</command_line>
    </task>
 <unzip_input>
       <zipfilename>internal.zip</zipfilename>
    </unzip_input>
</job_desc>
```

**修改 version.xml**
内容如下：
```
<version>
   <file>
      <physical_name>wrapper_26016_windows_x86_64.exe</physical_name>
      <main_program/>
   </file>
   <file>
      <physical_name>dtm-worker.exe</physical_name>
      <logical_name>worker</logical_name>
   </file>
   <file>
      <physical_name>_internal.zip</physical_name>
      <logical_name>internal.zip</logical_name>
   </file>
   <file>
      <physical_name>worker_job_1.0.xml</physical_name>
      <logical_name>job.xml</logical_name>
   </file>
</version>
```

**sign**

```
./bin/sign_executable apps/worker/1.0/windows_x86_64/worker.exe code_sign_private > apps/worker/1.0/windows_x86_64/woker.exe.sig
./bin/sign_executable apps/worker/1.0/windows_x86_64/_internal.zip code_sign_private > apps/worker/1.0/windows_x86_64/_internal.zip.sig

./bin/sign_executable apps/worker/1.0/windows_x86_64/worker_job_1.0.xml code_sign_private > apps/worker/1.0/windows_x86_64/worker_job_1.0.xml.sig
```

**Update**

```
./bin/update_versions
```

**提交任务**

```
vi input.txt
./bin/stage_file input.txt
./bin/create_work --appname worker --wu_name worker_nodelete input.txt
```

## 调试方法论

服务端调试可参考 [Trouble-shooting a BOINC server](https://boinc.berkeley.edu/trac/wiki/ServerDebug)

客户端调试相对更简单， 因为Boinc客户端会将每次请求应答的信息及状态信息保存在本地数据目录（默认C:\ProgramData\BOINC）中，包括：

- stderrdae.txt/stdoutdae.txt 日志信息
- client_state.xml 客户端状态
- account_{project_url}.xml 加入项目成功后的账号信息
- get_project_config.xml 调用 get_project_config.php 请求返回的信息
- lookup_account.xml 调用 lookup_account.php 请求返回的信息
- master_{project_url}.xml 拉取项目主页返回的信息，该信息中包含调度器列表url。
- sched_reply_{project_url}.xml 调度请求信息
- sched_request_{project_url}.xml 调度应答信息

**服务端**

- 确保 服务正常运行 `./bin/status`
- 确保 App Plan 正确配置
- 确保有平台对应的 workunit
- 查看调度日志：` tail -f log_boincserver/*.log`
- 查看源码中的调度逻辑看调度条件是否满足。
- 开启调试日志 在config.xml config标签下开启模块调试开关，如：` <debug_version_select>1</debug_version_select>`

调度条件源码分析：
```
// sched_check.cpp check_memory() 检查内存决定任务是否被调度
static inline int check_memory(WORKUNIT& wu) {
    double diff = wu.rsc_memory_bound - g_wreq->usable_ram;
    if (diff > 0) {
        char message[256];
        sprintf(message,
            "%s needs %0.2f MB RAM but only %0.2f MB is available for use.",
            find_user_friendly_name(wu.appid),
            wu.rsc_memory_bound/MEGA, g_wreq->usable_ram/MEGA
        );
        add_no_work_message(message);

        if (config.debug_send_job) {
            log_messages.printf(MSG_NORMAL,
                "[send_job] [WU#%lu %s] needs %0.2fMB RAM; [HOST#%lu] has %0.2fMB, %0.2fMB usable\n",
                wu.id, wu.name, wu.rsc_memory_bound/MEGA,
                g_reply->host.id, g_wreq->ram/MEGA, g_wreq->usable_ram/MEGA
            );
        }
        g_wreq->mem.set_insufficient(wu.rsc_memory_bound);
        g_reply->set_delay(DELAY_NO_WORK_TEMP);
        return INFEASIBLE_MEM;
    }
    return 0;
}

// Fast checks (no DB access) to see if the job can be sent to the host.
// Reasons why not include:
// 1) the host doesn't have enough memory;
// 2) the host doesn't have enough disk space;
// 3) based on CPU speed, resource share and estimated delay,
//    the host probably won't get the result done within the delay bound
// 4) app isn't in user's "approved apps" list
//
// If the job is feasible, return 0 and fill in wu.delay_bound
// with the delay bound we've decided to use.
//
int wu_is_infeasible_fast(
    WORKUNIT& wu,
    int res_server_state, int res_priority, double res_report_deadline,
    APP& app, BEST_APP_VERSION& bav
) {
// ... ...
}
```


**客户端**

- 客户端task不运行，可以通过日志查看原因。例如： 客户端能拉取到任务，但是没有运行，也没有向服务端上报状态，可能是程序的输入输出模板(templates/work_in  templates/work_out)配置错误。
- 查看日志: 工具 -> 事件日志
- 设置显示更多类型的日志：选项-> 事件日志选项 。 
- 选中 `http_debug`, 可以查看到客户端与服务通信的详细http协议内容。

代码分析，客户端核心代码全在 client/ 目录下：

```
// 主循环逻辑微码
int boinc_main_loop() {
    //... ...
    // client main loop; poll interval is 1 sec
    while (1) {
        gstate.poll_slow_events() ->  scheduler_rpc_poll()  
 }
 // ...
```

```
// 有限状态机轮询函数
// Poll the client's finite-state machines
// possibly triggering state transitions.
// Returns true if something happened
// (in which case should call this again immediately)
// Called every POLL_INTERVAL (1 sec)
//
bool CLIENT_STATE::poll_slow_events() {
}

// cs_scheduler.cpp
// Called once/sec.
// Initiate scheduler RPC activity if needed and possible
//
bool CLIENT_STATE::scheduler_rpc_poll() {
  // ...
   scheduler_op->poll();
  // ...
}

bool SCHEDULER_OP::poll() {
   switch(state) {
    case SCHEDULER_OP_STATE_GET_MASTER:  // 获取 master文件，并解析出调度器url
    case SCHEDULER_OP_STATE_RPC:   // 处理RPC请求
    {
     retval = start_rpc(cur_proj);  // RPC请求
     retval = gstate.handle_scheduler_reply(cur_proj, scheduler_url); RPC应答
    }
   }
}
```

**任务状态查看**

- 对志愿者：http://{URL_BASE}/server_status.php 注意该页面获取到的状态信息是有延迟的，默认延迟一个小时，因为内部使用了缓存。
- 对管理员：http://{URL_BASE}/{project}_ops/
 
## 调试记录

**客户端拉取不到任务**

客户端拉取不到任务，事件日志选项开启 work_fetch_debug, Boinc Manager 事件日志每分钟会刷新打印如下log：

```
2024/12/20 12:40:47 |  | [work_fetch] ------- start work fetch state -------
2024/12/20 12:40:47 |  | [work_fetch] target work buffer: 8640.00 + 43200.00 sec
2024/12/20 12:40:47 |  | [work_fetch] --- project states ---
2024/12/20 12:40:47 | 3drender | [work_fetch] REC 1.167 prio -1.000 can request work
2024/12/20 12:40:47 |  | [work_fetch] --- state for CPU ---
2024/12/20 12:40:47 |  | [work_fetch] shortfall 829440.00 nidle 16.00 saturated 0.00 busy 0.00
2024/12/20 12:40:47 | 3drender | [work_fetch] share 0.000 project is backed off  (resource backoff: 33257.53, inc 38400.00)
2024/12/20 12:40:47 |  | [work_fetch] --- state for NVIDIA GPU ---
2024/12/20 12:40:47 |  | [work_fetch] shortfall 51840.00 nidle 1.00 saturated 0.00 busy 0.00
2024/12/20 12:40:47 | 3drender | [work_fetch] share 0.000 no applications
2024/12/20 12:40:47 |  | [work_fetch] --- state for Intel GPU ---
2024/12/20 12:40:47 |  | [work_fetch] shortfall 51840.00 nidle 1.00 saturated 0.00 busy 0.00
2024/12/20 12:40:47 | 3drender | [work_fetch] share 0.000 no applications
2024/12/20 12:40:47 |  | [work_fetch] ------- end work fetch state -------
2024/12/20 12:40:47 | 3drender | choose_project: scanning
2024/12/20 12:40:47 | 3drender | can't fetch CPU: project is backed off
2024/12/20 12:40:47 | 3drender | can't fetch NVIDIA GPU: no applications
2024/12/20 12:40:47 | 3drender | can't fetch Intel GPU: no applications
2024/12/20 12:40:47 |  | [work_fetch] No project chosen for work fetch

```
经排查，是由 Boinc 的失败退避机制导致的，参考

- [Thread 'Way to adjust/disable project backoff'](https://boinc.n-helix.com/forum_thread.php?id=12633)
- [Low-latency computing](https://github.com/BOINC/boinc/wiki/LowLatency)

解决办法是在服务端 config.xml中添加如下配置： `<next_rpc_delay>5</next_rpc_delay>`,表示5秒后发起下次rpc查询。

注意：

- 如果一开始没有设置 next_rpc_delay ，那么退避时间可能会比较久，那么当添加该值后，客户端并不会立即获取到该值，客户端需要等到下次调度请求的返回值中拿到该值再更新。 目前没有办法在后台强制控制客户端更新该配置，只能手动在客户端项目标签下点击更新。
- 所以最好是一开始就设置该值为一个较小的值。


