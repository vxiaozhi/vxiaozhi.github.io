# Strapi 介绍

Strapi 是一个开源的 Headless CMS（无头内容管理系统）。它允许开发者通过自定义的方式快速构建、管理和分发内容。Strapi 提供了一个强大的后端 API，支持 RESTful 和 GraphQL 两种方式，使得开发者可以方便地将内容分发到任何设备或服务，无论是网站、移动应用还是 IoT 设备。

Strapi 的主要特点包括：

- 灵活性和可扩展性：通过自定义模型、API、插件等，Strapi 提供了极高的灵活性，可以满足各种业务需求。
- 易于使用的 API：Strapi 提供了一个简洁、直观的 API，使得开发者可以轻松地与数据库进行交互。
- 内容管理界面：Strapi 提供了一个易于使用的管理界面，使得用户可以轻松地创建、编辑和发布内容。
- 多语言支持：Strapi 支持多种语言，包括中文、英语、法语、德语等。
- 可扩展性：Strapi 具有高度的可扩展性，可以通过插件和自定义模块、插件来扩展其功能。
- 社区支持：Strapi 拥有一个活跃的社区，提供了大量的文档、示例和插件，使得开发人员可以轻松地解决问题和扩展功能。

主要适用场景：

- 多平台内容分发（ 将内容分发到不同web、h5等不同平台 ）
- 定制化 CMS 需求（ 通过插件等扩展性高度定制 ）
- 快速开发api（API管理界面能够大大加快开发速度，尤其是MVP（最小可行产品）阶段 ）


## 安装

**docker【非官方】**

参考

- [strapi-docker](https://github.com/strapi/strapi-docker)

```
docker run -it -p 1337:1337 -v `pwd`/project-name:/srv/app strapi/strapi
```

启动容器的过程中会安装 js 依赖包，很可能会出现老的依赖包无法下载的问题。

```
$ docker run -it -p 1337:1337 -v `pwd`/project-strapi:/srv/app strapi/strapi
Unable to find image 'strapi/strapi:latest' locally
latest: Pulling from strapi/strapi
1e987daa2432: Pull complete
a0edb687a3da: Pull complete
6891892cc2ec: Pull complete
684eb726ddc5: Pull complete
b0af097f0da6: Pull complete
154aee36a7da: Pull complete
769e77dee537: Pull complete
44a6ee72a664: Pull complete
f374f834ba21: Pull complete
4959172eae3e: Pull complete
1eb96a0de363: Pull complete
4f4fb700ef54: Pull complete
02b141244aae: Pull complete
Digest: sha256:be2aa1b207c74474319873d2a343c572e17273f5c3017c308c4a21bd6e1992e9
Status: Downloaded newer image for strapi/strapi:latest
WARNING: The requested image's platform (linux/amd64) does not match the detected host platform (linux/arm64/v8) and no specific platform was requested
Using strapi 3.6.8
No project found at /srv/app. Creating a new strapi project
Creating a project from the database CLI arguments.
Creating a new Strapi application at /srv/app.
Creating files.
⠹ Installing dependencies: warning url-loader@1.1.2: Invalid bin field for "url-loader".
```

这里开始思考一个问题，为什么要在运行过程中下载依赖呢，为什么官方不提供docker部署方式呢？

继续看完下面的命令行安装方式就明白了。

**命令行方式**

参考

- [使用 strapi 快速构建 API 和 CMS 管理系统](https://cloud.tencent.com/developer/article/2236257)

```
npx create-strapi-app@latest my-api --quickstart --ts
```

strapi创建项目的方式，类似于 boinc 平台。有一个项目的概念。 创建项目后，有可能需要自定义修改项目代码。所以在项目创建之前不适合用docker的方式部署。

## 参考

- [探索开源世界：7款引人入胜的殿堂级CMS，从WordPress到strapi](https://zhuanlan.zhihu.com/p/652732748)
- [Strapi 及其类似产品 & WordPress 的介绍与对比](https://juejin.cn/post/7221545548574261308)
