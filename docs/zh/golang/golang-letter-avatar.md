# 使用 LetterAvatar 实现纯前端生成字母头像

如何自动给没头像的用户生成一个昵称首字符的彩色头像。参考这个 golang 库：

- [letteravatar](https://github.com/disintegration/letteravatar)

遗憾的是，这个库不支持中文，因此可以将中文字符先转化为拼音再调用这个库。

- [go-pinyin](https://github.com/mozillazg/go-pinyin)
