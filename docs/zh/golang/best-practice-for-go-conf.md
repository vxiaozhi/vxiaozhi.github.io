# Golang 程序加载配置最佳实践

## 常用配置文件读取方式

### 1. json

- 内置
- [json-iterator for go](https://github.com/json-iterator/go)
- [GJSON ](https://github.com/tidwall/gjson)

### 2. yaml

- [YAML](https://github.com/go-yaml/yaml)

### 3. toml

- [TOML](https://github.com/BurntSushi/toml)

### 4. ini

- [INI](https://github.com/go-ini/ini)


### 5. HCL

- [HCL](https://github.com/hashicorp/hcl) 

## 最佳实践

最好的方式应该是能够同时支持 从 命令行参数、配置文件、环境变量 三种方式加载参数写入到特定的结构中。 

当 三者同时存在时， 命令行参数的优先级最高，配置文件的优先级最低。

可以参考这个项目  [buildkite-agent](https://github.com/buildkite/agent)

## 参考
