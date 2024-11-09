# Gin 开发后台服务最佳实践

[gin](https://github.com/gin-gonic/gin) 是一个 golang 实现的 http web 框架。

[go 语言框架 gin 的中文文档](https://github.com/skyhee/gin-doc-cn) 介绍了 路由、无缝重启、中间件、db接入常用方法。


## 脚手架项目 

- [gin-vue-admin](https://github.com/flipped-aurora/gin-vue-admin) Vite+Vue3+Gin拥有AI辅助的基础开发平台，支持TS和JS混用。它集成了JWT鉴权、权限管理、动态路由、casbin鉴权、显隐可控组件、分页封装、多点登录拦截、资源权限、上传下载、代码生成器、表单生成器和可配置的导入导出等开发必备功能。

- [go-gin-api](https://github.com/xinliangnote/go-gin-api) 基于 Gin 进行模块化设计的 API 框架，封装了常用功能，使用简单，致力于进行快速的业务研发。比如，支持 cors 跨域、jwt 签名验证、zap 日志收集、panic 异常捕获、trace 链路追踪、prometheus 监控指标、swagger 文档生成、viper 配置文件解析、gorm 数据库组件、gormgen 代码生成工具、graphql 查询语言、errno 统一定义错误码、gRPC 的使用、cron 定时任务 等等。

- [Go Gin Web Server](https://github.com/render-examples/go-gin-web-server)

- [gin-boilerplate](https://github.com/Massad/gin-boilerplate) The fastest way to deploy a restful api's with Gin Framework with a structured project that defaults to PostgreSQL database and JWT authentication middleware stored in Redis

- [Gin-Admin](https://github.com/LyricTian/gin-admin) 基于 GIN + GORM 2.0 + Casbin 2.0 + Wire DI 的轻量级、灵活、优雅且功能齐全的 RBAC 脚手架。

## 中间件

- [gin-swagger](https://github.com/swaggo/gin-swagger) generate RESTful API documentation with Swagger 2.0.
- [CORS](https://github.com/gin-contrib/cors) Official CORS gin's middleware
- [sessions](https://github.com/gin-contrib/sessions) Gin middleware for session management
- [gin-jwt](https://github.com/appleboy/gin-jwt)

## 基于 gin 的应用

- [alist](https://github.com/AlistGo/alist) 一个支持多存储的文件列表/WebDAV程序，使用 Gin 和 Solidjs. 支持本地存储、百度网盘、各大云厂商的 cos 等。