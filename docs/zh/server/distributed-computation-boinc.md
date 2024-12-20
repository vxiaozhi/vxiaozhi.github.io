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

## 调试记录

服务端调试可参考 [Trouble-shooting a BOINC server](https://boinc.berkeley.edu/trac/wiki/ServerDebug)

**服务端**

- 确保 服务正常运行 `./bin/status`
- 确保 App Plan 正确配置
- 确保有平台对应的 workunit
- 查看调度日志：` tail -f log_boincserver/*.log` 


**客户端**

- 客户端task不运行，可以通过日志查看原因。例如： 客户端能拉取到任务，但是没有运行，也没有向服务端上报状态，可能是程序的输入输出模板(templates/work_in  templates/work_out)配置错误。
- 查看日志: 工具 -> 事件日志
- 设置显示更多类型的日志：选项-> 事件日志选项 。 
- 选中 `http_debug`, 可以查看到客户端与服务通信的详细http协议内容。
