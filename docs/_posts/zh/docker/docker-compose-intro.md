# docker-compose 简介

## docker-compose 中volumes参数说明

docker-compose 使用数据卷进行持久化

```
    ghost:  
    
      image: ghost
    
      volumes:
    
        - ./ghost/config.js:/var/lib/ghost/config.js

```

使用卷标映射

```
    services:
     mysql:  
      image: mysql
      container_name: mysql
      volumes:
        - mysql:/var/lib/mysql
    ...
    volumes:
     mysql:

```

>第一种情况路径直接挂载到本地，比较直观，但需要管理本地的路径
>第二种使用卷标的方式，比较简洁，但你不知道数据存在本地什么位置，下面说明如何查看docker的卷标

查看所有卷标

```
  docker volume ls 

```

查看具体的volume对应的真实地址

```
 $ docker volume inspect vagrant_mysql

 [
 
    {
 
        "Name": "vagrant_mysql",
        "Driver": "local",
        "Mountpoint": "/var/lib/docker/volumes/vagrant_mysql/_data"
 
    }
 
 ]

```

## 参考

- [Difference between "docker compose" and "docker-compose"](https://stackoverflow.com/questions/66514436/difference-between-docker-compose-and-docker-compose)
- [docker-compose和docker compose的区别](https://www.cnblogs.com/zhaodalei/p/17553269.html)
- [Docker Compose overview](https://docs.docker.com/compose/#install-on-linux)
- [Docker Compose v2 github](https://github.com/docker/compose)
- [docker: 'compose' is not a docker command when installing using convenience scripts](https://github.com/docker/compose/issues/8630)
