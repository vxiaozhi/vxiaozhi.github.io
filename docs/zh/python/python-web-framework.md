# Python Web 框架

## django

## FastAPI

**路由**

- [路径参数 定义一般路由](https://fastapi.tiangolo.com/zh/tutorial/path-params/)
- [对路由分组](https://fastapi.tiangolo.com/zh/reference/apirouter/)

**OpenAPI 文档相关**

- [请求体 - 字段](https://fastapi.tiangolo.com/zh/tutorial/body-fields/)
- [元数据和文档 URL](https://fastapi.tiangolo.com/zh/tutorial/metadata/)
- [BaseModel 字段约束的Field定义](https://docs.pydantic.dev/latest/api/fields/)

**中间件**

- [如何使用中间件修改请求及应答包体](https://dev.to/avirgvd/python-fastapi-middleware-to-modify-request-and-response-body-3f7f)

**日志**

参考：[为 FastAPI 配置日志的三种方法](https://cloud.tencent.com/developer/article/2009553) 

第一种，就像写脚本那样记录日志。 具体到fastapi框架中，可以在初始化时建立一个全局的logger，然后其它模块获取该logger即可输出日志。当然最好的方式是像 go Macaron web框架那样， 在中间件中创建一个logger对象然后传递到其它路由中调用，可以fastAPI不支持这种模式。

第二种，记录 uvicorn 的日志

第三种，配置 uvicorn 的日志



**单元测试**

依赖

```
pip install httpx pytest
```

参考

- [Testing](https://fastapi.tiangolo.com/tutorial/testing/)

  
## Sanic

- [Sanic](https://github.com/sanic-org/sanic) Sanic is a Python 3.8+ web server and web framework that's written to go fast. It allows the usage of the async/await syntax added in Python 3.5
