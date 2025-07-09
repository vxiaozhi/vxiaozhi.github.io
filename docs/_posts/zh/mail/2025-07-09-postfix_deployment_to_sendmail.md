---
layout:     post
title:      "部署postfix服务进行发送邮件"
subtitle:   "部署postfix服务进行发送邮件"
date:       2025-07-09
author:     "vxiaozhi"
catalog: true
tags:
    - mail
    - postfix
---

## 概述

若只需发送邮件（如监控报警、事务通知），无需接收邮件，可采用 ​​Postfix​​ 或 ​​SSMTP​​ 的极简配置，本文介绍如何部署​​Postfix​​ 服务进行发送邮件。

如果需要收发同时支持， 可采用 iRedMail 部署.


以下是 **Postfix 邮件服务器部署的标准化流程**，涵盖从安装到安全加固的完整步骤，适用于生产环境：

---

## 一、基础部署流程

### **1. 环境准备**

**系统要求**：

  - 操作系统：Ubuntu 22.04/CentOS 8（推荐）
  - 硬件：1核2GB内存（支持1000用户/日）
  - 域名：已注册域名（如 `example.com`）
  
**DNS预配置**：

  ```text
  MX记录   → mail.example.com [优先级10]
  A记录    → mail.example.com → 服务器IP
  PTR记录  → 服务器IP反向解析为mail.example.com（需云厂商支持, 阿里云解析DNS不支持）
  ```
用如下命令检测dns配置是否生效：

```
dig +short MX example.com
dig +short A mail.example.com
```


### **2. 安装Postfix**

```bash
# Ubuntu/Debian
sudo apt update && sudo apt install postfix mailutils

# CentOS/RHEL
sudo yum install postfix
```

- 安装时选择 **Internet Site**，输入主域名（如 `example.com`）

### **3. 核心配置（/etc/postfix/main.cf）**

```ini
# 基础参数
myhostname = mail.example.com
mydomain = example.com
myorigin = $mydomain
inet_interfaces = all
mydestination = $myhostname, localhost.$mydomain, localhost

# 网络访问控制
mynetworks = 127.0.0.0/8, [::1]/128, 192.168.1.0/24

# 邮件存储格式
home_mailbox = Maildir/
```

### **4. 启用加密端口**

编辑 `/etc/postfix/master.cf` 取消注释：

```ini
submission inet n - y - - smtpd
  -o smtpd_tls_security_level=encrypt
  -o smtpd_sasl_auth_enable=yes
```

submission 启用后，会在 587 端口监听

---

## **二、安全加固流程**

### **1. TLS证书配置**

```bash
# 使用Let's Encrypt
sudo certbot certonly --standalone -d mail.example.com
```

在 `/etc/postfix/main.cf` 添加：

```ini
smtpd_tls_cert_file=/etc/letsencrypt/live/mail.example.com/fullchain.pem
smtpd_tls_key_file=/etc/letsencrypt/live/mail.example.com/privkey.pem
smtpd_tls_security_level=may
```

### **2. 反垃圾邮件配置**

**SPF记录（DNS TXT）**：

```text
example.com. IN TXT "v=spf1 mx ip4:your_server_ip ~all"
```

**DKIM签名**：

```bash
sudo opendkim-genkey -D /etc/opendkim/keys/ -d example.com -s default
sudo chown opendkim:opendkim /etc/opendkim/keys/default.private
```

SPF 或 DKIM 如果未配置，则邮件可能会被垃圾邮件过滤器拒绝。

```
to=<whutluohui@gmail.com>, relay=gmail-smtp-in.l.google.com[172.253.118.26]:25, delay=2.8, delays=0.02/0.01/0.47/2.3, dsn=5.7.26, status=bounced (host gmail-smtp-in.l.google.com[172.253.118.26] said: 550-5.7.26 Your email has been blocked because the sender is unauthenticated. 550-5.7.26 Gmail requires all senders to authenticate with either SPF or DKIM. 550-5.7.26  550-5.7.26  Authentication results: 550-5.7.26  DKIM = did not pass 550-5.7.26  SPF [agrfactory.com] with ip: [43.134.183.194] = did not pass 550-5.7.26  550-5.7.26  For instructions on setting up authentication, go to 550 5.7.26  https://support.google.com/mail/answer/81126#authentication d9443c01a7336-23c842cfbfdsi187362115ad.51 - gsmtp (in reply to end of DATA command))
```

Postfix集成配置：

```ini
milter_protocol = 2
smtpd_milters = inet:localhost:8891
non_smtpd_milters = inet:localhost:8891
```

### **3. 访问限制**

```ini
smtpd_client_restrictions = permit_mynetworks, reject_unknown_client
smtpd_helo_restrictions = reject_invalid_helo_hostname
smtpd_sender_restrictions = reject_unknown_sender_domain
```

---

## **三、服务验证与测试**

### **1. 启动服务**

```bash
sudo systemctl restart postfix
sudo postfix check  # 检查语法
```

### **2. 发送测试邮件**

```bash
echo "Test Body" | mail -s "Test Subject" user@example.com
echo "Test Body" | mail -s "Test Subject" -r lighthouse@example.com test@gmail.com
```

### **3. 日志监控**

```bash
tail -f /var/log/mail.log  # 实时日志
grep 'status=sent' /var/log/mail.log  # 成功发送记录
```

### **4. 端口验证**

```bash
telnet mail.example.com 25  # SMTP基础测试
openssl s_client -connect mail.example.com:587 -starttls smtp  # TLS加密测试
```

---

## **四、维护与优化**

### **1. 日常维护命令**
```bash
postqueue -p  # 查看邮件队列
postsuper -d ALL  # 清空队列（谨慎使用）
dovecot stats  # 监控IMAP连接数
```

### **2. 性能优化参数（/etc/postfix/main.cf）**

```ini
default_process_limit = 100
smtpd_client_connection_limit = 20
message_size_limit = 50M  # 允许50MB附件
```

### **3. 备份策略**

- **邮件数据**：定时打包 `/home/*/Maildir`
- **配置备份**：
  ```bash
  tar czf postfix_backup_$(date +%F).tar.gz /etc/postfix /etc/opendkim
  ```


