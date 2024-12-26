# Boinc 网络通信协议

官网文档这里有作简单介绍：

- [网络交互概览](https://github.com/BOINC/boinc/wiki/CommIntro)

![]()


The client downloads the page from project's master URL. From XML tags embedded in this page, it obtains a list of domain names of schedulers.

客户端下载 Master URL 页面， 从其中获取调度服务器的域名列表。

The client exchanges request and reply messages with a scheduling server. The reply message contains, among other things, descriptions of work to be performed, and lists of URLs of the input and output files of that work.
客户端发送请求给调度服务器，调度服务器返回应答消息。 应答消息包含工作单元的输入和输出文件的描述，以及该工作单元的输入输出 URL 列表。

The client downloads files (application programs and data files) from one or more download data servers. This uses standard HTTP GET requests, perhaps with Range commands to resume incomplete transfers.
客户端使用标准的 HTTP GET 请求从一个或多个下载数据服务器下载文件。

After the computation is complete, the client uploads the result files. This uses a BOINC-specific protocol that protects against DOS attacks on data servers.
当计算完成后，客户端上传结果文件。 使用特定的BOINC协议，它保护了数据服务器的 DOS 攻击。

The client then contacts a scheduling server again, reporting the completed work and requesting more work.
客户端再次与调度服务器通信，上报已完成的工作单元，并请求更多工作单元。

## 加入项目/登录

## 调度请求

```
int CLIENT_STATE::handle_scheduler_reply()

```

客户端开启 http_debug http_xfer_debug 调试选项， 当加入项目时，可以观察到Boinc客户端和Server之间的通信协议如下：

```
Fetching configuration file from https://gzboinc.woa.com/3drender/get_project_config.php
https://gzboinc.woa.com/3drender/lookup_account.php?email_addr=erikluo%40tencent%2Ecom&passwd_hash=f803245bdd0ea825d16d736e72448309
 Fetching scheduler list
 HTTP_OP::init_post(): https://gzboinc.woa.com/3drender_cgi/cgi
```






## 文件下载

## 文件上传
