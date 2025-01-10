# tproxy（透明代理）

## 什么是透明代理

[tproxy](https://github.com/KatelynHaworth/go-tproxy) 即 transparent（透明） proxy。这里的 transparent（透明）有两层含义：

- 代理对于 client 是透明的，client 端无需进行任何配置。即无需修改请求地址，也无需采用代理协议和代理服务器进行协商。与之相对比的是 socks 代理或者 http 代理，需要在 client 端设置代理的地址，在发起请求时也需要通过代理协议告知代理服务器其需要访问的真实地址。
- 代理对于 server 是透明的，server 端看到的是 client 端的地址，而不是 proxy 的地址。


github上有个叫 [tproxy](https://github.com/kevwan/tproxy) 的项目，但其实实现的并不是透明代理， 而是 用来做 tcp 连接分析的。


## 参考

- [tproxy（透明代理）](https://www.zhaohuabing.com/learning-linux/docs/tproxy/)
- [透明代理(TPROXY)](https://guide.v2fly.org/app/tproxy.html)