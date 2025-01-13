---
layout:     post
title:      "使用 Certbot 为 Nginx 网站服务器设置永久免费的 HTTPS 证书"
subtitle:   "使用 Certbot 为 Nginx 网站服务器设置永久免费的 HTTPS 证书"
date:       2025-01-13
author:     "vxiaozhi"
catalog: true
tags:
    - 建站
    - certbot
---

# 使用 Certbot 为 Nginx 网站服务器设置永久免费的 HTTPS 证书

目前流行的设置https证书的方案有2种：

- [acme](https://github.com/acmesh-official/acme.sh) 采用纯Shell实现， 并且有完善的中文文档。【只能支持Nginx配置安装在标准目录，如果自定义了配置目录，则无法使用】
- certbot

本文介绍第二种方式。

参考 [使用Nginx结合CertBot配置HTTPS协议](https://developer.aliyun.com/article/689901)


## Certbot 安装

官网: https://certbot.eff.org

官方安装文档: https://certbot.eff.org/lets-encrypt/centosrhel7-nginx

Certbot 打包在 EPEL Enterprise Linux(企业版 Linux 的扩展包)上。使用 Certbot,必须先开启 EPEL 仓库。
在 RHEL 或 Oracle Linux 中,还要必须开启可选频道。可以执行如下命令安装 Certbot

```
sudo yum install epel-release
sudo yum install certbot
```

## 生成证书

我们需要配置 Nginx 来做服务器域名验证，因为 CertBot 的 standalone 模式虽然可以配置好服务器，但是每次 90 天到期续签的时候，需要让服务停止一下，再启动。因此我们改用 Webroot 配置模式来验证，Webroot 配置模式下 CertBot 会生成一个随机文件，然后 CertBot 服务器通过 HTTP 的方式访问我们服务器上的这个文件进行验证。所以我们需要配置好 Nginx，以便 CertBot 服务器可以访问到这个随机文件。

修改 Nginx 配置，新增一个 server 模块：

```
    server {
        listen       80;
        server_name  your.domain.com; #这里填你要验证的域名

        location ^~ /.well-known/acme-challenge/ {
            default_type "text/plain";
            root     /usr/share/nginx/html/; #这里需要与后文 --webroot -w 后面配置的路径一致
        }
    }
```

ok，重启 Nginx

```
sudo service nginx reload
```

然后执行

```
sudo certbot certonly --webroot -w /usr/share/nginx/html/ -d your.domain.com
```

记得替换 your.domain.com 为你自己的域名。

如果看到有提示：

```
IMPORTANT NOTES:
 - Congratulations! Your certificate and chain have been saved at
   /etc/letsencrypt/live/your.domain.com/fullchain.pem. Your cert
   will expire on 20XX-09-23. To obtain a new or tweaked version of
   this certificate in the future, simply run certbot again. To
   non-interactively renew *all* of your certificates, run "certbot
   renew"
 - If you like Certbot, please consider supporting our work by:

   Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
   Donating to EFF:                    https://eff.org/donate-le
```
证书生成成功！

接着可以开始启用 443 端口

修改 Nginx 的配置文件，新建一个 443 端口的 server 配置：

```
server {
    listen 443 ssl;
    listen [::]:443 ssl ipv6only=on;

    ssl_certificate /etc/letsencrypt/live/your.domain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/your.domain.com/privkey.pem;
    ssl_trusted_certificate /etc/letsencrypt/live/your.domain.com/chain.pem;

    // ... other settings ...
}
```

记得替换 your.domain.com 为你自己的域名哦。

重启 Nginx

```
sudo service nginx reload
```
这时候的网站基本完成免费 HTTPS 证书的设置。成功！

## 删除证书

如果因为种种原因不小心生成了多余的证书，他会存在于我们的服务器中，导致无用的冗余。可是官方其实并没有提供取消授权的方式，我们可以在本地删除授权证书，并且不再续签，便可以释放该证书了，我们需要进入对应的文件夹内，查看自己已经生成的证书域名文件夹，然后依次删除就好，记得替换 your.domain.com 为你要删除的域名哦:

```
cd /etc/letsencrypt/live/
ls
sudo rm -rf /etc/letsencrypt/live/your.domain.com/ 
sudo rm -rf /etc/letsencrypt/archive/your.domain.com/
sudo rm /etc/letsencrypt/renewal/your.domain.com.conf
```

## 设置自动更新

由于这个免费证书的时效只有 90 天，所以我们需要设置自动更新，帮我们自动更新证书的时效。
自动更新可以使用 Linux 系统的 cron 定时任务功能，CentOS 可以使用 crontab 命令

我们先命令行模拟证书更新：

```
sudo certbot renew --dry-run
```

如果有提示下面的内容，表示模拟更新成功

```
-------------------------------------------------------------------------------
Processing /etc/letsencrypt/renewal/your.domain.com.conf
-------------------------------------------------------------------------------
** DRY RUN: simulating 'certbot renew' close to cert expiry
**          (The test certificates below have not been saved.)

Congratulations, all renewals succeeded. The following certs have been renewed:
  /etc/letsencrypt/live/your.domain.com/fullchain.pem (success)
** DRY RUN: simulating 'certbot renew' close to cert expiry
**          (The test certificates above have not been saved.)
```

那么，我们就可以使用crontab -e的命令来启用自动任务，命令行：

```
sudo crontab -e
```

然后会打开打开定时任务配置文件，我们可以按i进入编辑模式，然后输入：

```
30 2 * * * /usr/bin/certbot renew  >> /var/log/le-renew.log
```

上面的执行时间为：每天凌晨2点30分执行renew任务。

现在可以在命令行执行 `/usr/bin/certbot renew >> /var/log/le-renew.log` 看看是否执行正常，如果一切OK，那么配置就成功了！
