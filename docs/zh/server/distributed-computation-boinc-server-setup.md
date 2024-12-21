# Boinc 后台服务搭建



## 源码编译安装部署

参考  [Boinc Server搭建](https://boinc.berkeley.edu/trac/wiki/ServerIntro)

**用户和组**

BOINC server programs 运行需要两个不同的用户账号:

- Web账号： 即Apache http服务需要的账号， 调度程序、文件上传以及Web程序使用该账号运行 (不同Linux发行版该账号可能不同，如 Fedora 叫：'apache';  Debian 叫 'www-data').
- 项目账号： 其它程序的运行，主要是任务管理程序， 该账号不建议用root， 可以用一个已经存在的用户账号或者新建一个账号，如 boincadm。

创建用户

```
useradd -m {username}
mkdir -pv /home/{username}
chown {username}:{username} /home/{username}
```

默认情况下， apache Web 服务器用户创建的目录不是所有人都可写的。这会导致问题：例如，当文件上传处理程序在上传层次结构中创建一个目录时，在 Fedora 上它归 (apache, apache) 所有，文件删除程序（以 boincadm 身份运行）将无法删除那里的文件。
因此需要将 web账号添加到 boincadm 组中。

```
$ usermod -a -G boincadm apache
```

给boincadm账号添加sudo权限

```
sudo visudo
```

In this file you have to add another line after the line for notroot. You can use this:

```
{username} ALL=(ALL) ALL
```

**MySQL**

```
mysql -u root -p
CREATE USER 'boincadm'@'localhost' IDENTIFIED BY 'foobar';
GRANT ALL ON *.* TO 'boincadm'@'localhost';
```

**安装及配置Apache 和 PHP**

```
apt-get install apache2 php libapache2-mod-php
```

****

**编译 boinc-server**

所谓的server 其实是 一个cgi调度程序及一堆工具。

```
cd ~
git clone https://github.com/BOINC/boinc.git boinc-src
cd ~/boinc-src
./_autosetup
./configure --disable-client --disable-manager --prefix=/usr/local/boinc/
make
make install
```

编译安装完成后的目录结构如下：

```
$ tree -d /usr/local/boinc/
/usr/local/boinc/
├── include
│   └── boinc
├── lib
│   └── pkgconfig
├── libexec
│   ├── boinc-apps-examples
│   └── boinc-server-maker
│       ├── lib
│       ├── sched
│       ├── tools
│       └── vda
├── share
│   └── boinc-server-maker
│       ├── db
│       └── html
│           ├── inc
│           │   ├── password_compat
│           │   ├── random_compat
│           │   └── ReCaptcha
│           │       └── RequestMethod
│           ├── languages
│           │   └── translations
│           ├── ops
│           │   ├── ffmail
│           │   ├── mass_email
│           │   └── remind_email
│           └── user
│               └── img
│                   └── flags
└── usr
    └── share
        └── boinc-server-maker
            └── py
                └── Boinc


```

其中，核心调度程序cgi 及tools 均在 /usr/local/boinc/libexec/boinc-server-maker/ 目录下：

```
$ tree /usr/local/boinc/libexec/boinc-server-maker/
/usr/local/boinc/libexec/boinc-server-maker/
├── lib
│   ├── crypt_prog
│   └── parse_test
├── sched
│   ├── adjust_user_priority
│   ├── antique_file_deleter
│   ├── assimilator.py
│   ├── census
│   ├── cgi
│   ├── cleanlogs.sh
│   ├── credit_test
│   ├── db_dump
│   ├── db_dump_spec.xml
│   ├── db_purge
│   ├── delete_file
│   ├── feeder
│   ├── file_deleter
│   ├── file_upload_handler
│   ├── get_file
│   ├── makelog.sh
│   ├── make_work
│   ├── message_handler
│   ├── put_file
│   ├── pymw_assimilator.py
│   ├── run_in_ops
│   ├── sample_assimilator
│   ├── sample_bitwise_validator
│   ├── sample_dummy_assimilator
│   ├── sample_substr_validator
│   ├── sample_trivial_validator
│   ├── sample_work_generator
│   ├── sched_driver
│   ├── script_assimilator
│   ├── script_validator
│   ├── show_shmem
│   ├── single_job_assimilator
│   ├── size_regulator
│   ├── start
│   ├── status
│   ├── stop
│   ├── transitioner
│   ├── transitioner_catchup.php
│   ├── trickle_credit
│   ├── trickle_deadline
│   ├── trickle_echo
│   ├── update_stats
│   └── wu_check
├── tools
│   ├── appmgr
│   ├── boinc_submit
│   ├── cancel_jobs
│   ├── create_work
│   ├── dbcheck_files_exist
│   ├── dir_hier_move
│   ├── dir_hier_path
│   ├── grep_logs
│   ├── gui_urls.xml
│   ├── make_project
│   ├── manage_privileges
│   ├── parse_config
│   ├── project.xml
│   ├── query_job
│   ├── remote_submit_test
│   ├── run_in_ops
│   ├── sample_assimilate.py
│   ├── sign_executable
│   ├── stage_file
│   ├── stage_file_native
│   ├── submit_batch
│   ├── submit_buda
│   ├── submit_job
│   ├── update_versions
│   ├── upgrade
│   ├── vote_monitor
│   └── xadd
└── vda
    ├── ssim
    ├── vda
    └── vdad

```

**创建项目**

After installation the BOINC software, you should run the make_project script to create the project.


## docker-compose部署

docker 部署相比较源码安装方式会简单很多。

参考 [Boinc Server Docker](https://github.com/marius311/boinc-server-docker)

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

# 该字段设置为空，则默认创建一个App为空的项目，否则创建一个支持 docker-app 的项目。
TAG=
```

## 最佳实践

上述两种方式均有一定的不足：

- 源代码安装方式：需要安装 Apache + PHP环境，  boinc 对PHP版本由一定要求，如果默认的PHP版本不满足要求，更换版本可能比较麻烦。
- docker-compose安装方式：1、很多时候使用已有的Mysql即可，不想在docker-compose中集成。2、 makeproject其实只需要运行一次，但集成在docker-compose每次启动均会运行，担心会导致副作用，例如可能把已有的project删除掉。

所以最佳的方式是将上面的两种搭建方案相结合。

- 自己搭建MySQL服务器
- 源码编译boinc，使用里面的工具，如make_project python工具等【其实这一步也可以省略】。
- docker镜像只用 docker-compose中的apache，免去自己搭建apache + PHP 的麻烦。

