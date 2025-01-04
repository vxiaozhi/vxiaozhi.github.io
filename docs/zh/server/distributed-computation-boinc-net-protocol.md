# Boinc 网络通信协议

官网文档这里有作简单介绍：

- [网络交互概览](https://github.com/BOINC/boinc/wiki/CommIntro)

![boinc-net-proto](https://raw.githubusercontent.com/wiki/BOINC/boinc/comm.png)

为了更好的观测到boinc客户端与服务器的通信流程，可以在客户端开启 http_debug http_xfer_debug 调试选项， 当加入到新项目时，可在日志中观察到Boinc客户端和Server之间的通信协议内容。

总结起来，分四个步骤，分别是：

## Step 1. 下载 Master URL

客户端下载 Master URL 页面， 从其中获取调度服务器的域名列表。Master URL 的地址通常为：

- https://{URL_BASE}/{PROJECT}/

同时客户端会在本地文件：master_{project_url}.xml 存储该请求的应答消息内容，方便调试。

该页面中的 head 信息中包含了调度器的列表，客户端会解析给列表获取到调度器的地址。具体实现代码在客户端这个函数中：

```
int SCHEDULER_OP::parse_master_file(PROJECT* p, vector<string> &urls) {
}
```

**加入项目/登录**

在客户端下载 Master URL之前，其实有个登录流程， 即当加入 boinc 项目时， 会触发客户度发起以下请求：

- https://{URL_BASE}/{PROJECT}/get_project_config.php
- https://{URL_BASE}/{PROJECT}/lookup_account.php?email_addr=xxx%40xxx%2Ecom&passwd_hash=f803245bdd0ea825d16d736e72448309

get_project_config.php请求应答会存储在本地文件：get_project_config.xml。

lookup_account.php请求应答会存储在本地文件：lookup_account.xml， 同时如果账号验证成功，会在本地创建文件：account_{project_url}.xml， 里面存储了该账号的key信息。


## Step 2. 发送调度请求

客户端发送请求给调度服务器，调度服务器返回应答消息。 应答消息包含工作单元的输入和输出文件的描述，以及该工作单元的输入输出 URL 列表。

调度请求的url通常如下：

- https://{URL_BASE}/{PROJECT}_cgi/cgi


当收到到调度服务器的应答消息后，客户端会解析该应答消息，调用以下函数进行处理：

```
int CLIENT_STATE::handle_scheduler_reply()

```


## Step3 下载文件。

客户端使用标准的 HTTP GET 请求从一个或多个下载数据服务器下载文件。

下载文件的逻辑一般的web服务器都是支持的， boinc这里直接使用的是 Apache 的文件下载机制，即在 apache 的配置文件中配置好下载对应的目录。 不需要额外的php 或者 cgi 代码。


## Step4 上传结果文件

当计算完成后，客户端上传结果文件。 使用特定的BOINC协议，它保护了数据服务器的 DOS 攻击。

同时客户端再次与调度服务器通信，上报已完成的工作单元，并请求更多工作单元。

上传逻辑相对文件下载逻辑要要复杂些， 因为需要对文件进行校验， 所以 boinc 采用了 cgi 实现的文件上传逻辑。url 路径通常为：

- https://{URL_BASE}/{PROJECT}_cgi/file_upload_handler

上传结果文件相对于boinc任务来说是可选的， 具体取决于 任务 的输出模板文件配置。


