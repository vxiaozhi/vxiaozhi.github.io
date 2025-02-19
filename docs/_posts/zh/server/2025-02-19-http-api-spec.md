---
layout:     post
title:      "HttpAPI规范及生态组件"
subtitle:   "HttpAPI规范及生态组件"
date:       2025-02-19
author:     "vxiaozhi"
catalog: true
tags:
    - server
    - openapi
    - http
---

## 背景
随着业务的增多，越来越多的服务需要提供http协议的API接口供第三方调用， 由于http api并不像trpc协议那样有一个通用的协议规范来定义约束接口， 通常API开发者需要提供一份API文档来说明每个API的详细参数。
如：[腾讯云API文档](https://cloud.tencent.com/document/product/213/15692) 等， 这些文档分散在各个地方，缺乏统一的管理，并且每篇文档的撰写风格也不一样，这就增加了API调用方的接入负担。。。  
总结一下，现有的API管理体系存在这如下缺点： 

- 标准不统一，管理混乱  
- 接口频繁变更，更新不及时  
- 开发者接入体验不友好  
- 人工编写文档耗时长  

## 业界规范
为了解决上述问题，业界制定了一些规范标准(定义了一个与语言无关的标准接口，允许人和计算机发现和理解服务的功能，而无需通过访问源代码、文档或开发者工具)。
最有名的包括： openapi、raml、api bulueprint。

### openapi规范

- [openapi官网](https://www.openapis.org/)
- [各个版本的openapi specification定义文档](https://github.com/OAI/OpenAPI-Specification/blob/main/versions/3.0.0.md)

openapi的前身是Swagger,其官网中也有最新的openAPI的规范定义
- [swagger官网中的openapi specification](https://swagger.io/specification/)

### Raml规范
- [raml官网](https://raml.org/)
- [raml规范文档](https://github.com/raml-org/raml-spec/tree/master/versions)
 
### api bulueprint 规范
- [api blueprint官网](https://apiblueprint.org/)
- [api blueprint 规范描述](https://github.com/apiaryio/api-blueprint/blob/master/API%20Blueprint%20Specification.md)

### RestAPI 设计规范参考
- [一把梭：REST API 全用 POST](https://coolshell.cn/articles/22173.html)
- [微软 Guidelines](https://github.com/microsoft/api-guidelines/blob/vNext/Guidelines.md)
- [Google Guidelines](https://cloud.google.com/apis/design?hl=zh-cn)

## 生态工具
有了API定义规范，即可基于此设计出一系列工具，包括代码生成、API文档生成及展示、API测试、API模拟等。  
![API tools](/imgs/openapi-tools.drawio.png)

 
### 开源工具
|API规范|	API文档化|	API代码生成	|API测试	|API可视化编辑	|其它|
|--------|--------|--------|--------|--------|--------|
|OpenAPI|	[swagger-ui](https://github.com/swagger-api/swagger-ui) [openapi-generator](https://github.com/OpenAPITools/openapi-generator)  [apicurio-studio](https://github.com/Apicurio/apicurio-studio) [redoc](https://github.com/Redocly/redoc) [elements](https://github.com/stoplightio/elements)|	[swagger-codegen](https://github.com/swagger-api/swagger-codegen) [openapi-generator](https://github.com/OpenAPITools/openapi-generator) [scalar](https://github.com/scalar/scalar) |[swagger-ui](https://github.com/swagger-api/swagger-ui)	| [swagger-editor](https://github.com/swagger-api/swagger-editor) [apicurio-studio](https://github.com/Apicurio/apicurio-studio)	| [swagger-faker](https://github.com/reeli/swagger-faker) [go-swagger](https://github.com/go-swagger/go-swagger) [从go源码生成SPEC](https://github.com/go-swagger/go-swagger#generate-a-spec-from-source)|
|Raml|[raml2html](https://github.com/raml2html/raml2html)	|||[playground](https://github.com/raml-org/playground)	|[webapi-parser](https://github.com/raml-org/webapi-parser)|
|API blueprint|	| |	[dredd](https://github.com/apiaryio/dredd)	| |[drakov](https://github.com/Aconex/drakov)|

### 开源产品
#### YApi
YApi 是高效、易用、功能强大的 api 管理平台，旨在为开发、产品、测试人员提供更优雅的接口管理服务。可以帮助开发者轻松创建、发布、维护 API，YApi 还为用户提供了优秀的交互体验，开发人员只需利用平台提供的接口数据写入工具以及简单的点击操作就可以实现接口的管理。

- [github](https://github.com/YMFE/yapi)

#### Rap
- [Rap Web接口管理工具，开源免费](https://github.com/thx/RAP)
- [rap2 阿里妈妈前端团队出品的开源接口管理工具RAP第二代](https://github.com/thx/rap2-delos)

  
### 商业化产品
#### 1.[国内]APIFox
功能比较强大，提供了API设计、开发、测试一体化协作平台。  

[官网](https://apifox.com/)

APIhub中，提供了各大互联网公司常见产品的API文档， 如[企业微信API](https://qiyeweixin.apifox.cn/api-10061204)

#### 2. [国外]RapidAPI

号称世界上最大的API中心。  

[官网](https://rapidapi.com/)

#### 3. [国外]Stoplight
Stoplight 是一款全面的 API 开发平台，包括 API 设计、文档化、测试和发布等环节。它提供了一个直观、易于使用的界面，支持多种 API 设计语言和规范，例如 OpenAPI、Swagger 和 RAML 等。 

[官网](https://stoplight.io/)


## 基于Swagger的API管理方案设计
### swagger生态组件
swagger是OpenAPI的前身，生态组件非常丰富。  

![](/imgs/openapi-swagger.drawio.png)

例如唐僧叨叨的API文件就是基于swagger实现的： 
- [唐僧叨叨的API](https://apidocs.botgate.cn/)
  
 
### 整体架构


![](/imgs/api-arch.drawio.png)


## Swagger一些命令备忘

API可视化
```
docker run --rm -p 80:8080 swaggerapi/swagger-ui
```

可视化编辑API SPEC文件
```
docker run --rm -p 80:8080 swaggerapi/swagger-editor
```

