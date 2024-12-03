# Nginx+PHP-FPM 部署

PHP-FPM 自 PHP 5.3.3 版本之后已经集成在 php 核心代码中了。

代码路径：`https://github.com/php/php-src/blob/master/sapi/fpm/fpm/fpm_main.c`


## Nginx 配置

```
server {
     listen 80;    #http是80，https就是 443 ssl，根据自己情况改，暂时先不讨论ssl
     index index.php index.html index.htm    #这里一定要把index.php加进去
     ########### 中间还有一些默认设置没列出来，大家根据这个内容进行增减##########
     location ~ .php$ {
       include fastcgi.conf;
       fastcgi_pass 127.0.0.1:9000;
       fastcgi_index index.php;
       fastcgi_split_path_info ^(.+.php)(/.+)$;
       fastcgi_param PATH_INFO $fastcgi_path_info;
       fastcgi_param PATH_TRANSLATED $document_root$fastcgi_path_info;
       fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
     }
}
```

## Php-fpm配置

安装

```
apt install php-fpm
```

修改配置

```
vim /etc/php/8.1/fpm/pool.d/www.conf
```

```
listen = 127.0.0.1:9000
listen.allowed_clients = 127.0.0.1
```

重启服务
```
systemctl restart php8.1-fpm
```

## PHP-FPM性能调优

PHP-FPM 是 PHP 版本的 FastCGI 协议的实现，是一个 PHP FastCGI 进程管理器，负责管理一个进程池来处理 Web 服务器的 HTTP 动态请求。其基本工作原理为：服务启动时会先创建一个 master 进程，解析配置文件，初始化执行环境，再创建多个 worker 进程，当接收到一个 HTTP 请求时，master 进程将其转发给某个 worker 进程，worker 负责动态执行 PHP 代码，处理完成后返回给 Web 服务器。

