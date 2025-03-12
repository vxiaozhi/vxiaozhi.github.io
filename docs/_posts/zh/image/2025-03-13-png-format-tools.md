---
layout:     post
title:      "png 格式工具"
subtitle:   "png 格式工具"
date:       2025-03-13
author:     "vxiaozhi"
catalog: true
tags:
    - image
---


## 工具示例：ImageMagick

PNG 格式支持多种预定义的文本块类型（如 tEXt, iTXt, zTXt），用于存储文本信息（如作者、版权、描述等）。这些数据块会被大多数图片查看器和编辑器保留。

```
# 添加文本元数据
convert input.png -set "Description" "这是附加的注释" output.png

# 添加多个字段（如作者、版权）
convert input.png -set "Artist" "John Doe" -set "Copyright" "2024" output.png
```

## 查看元数据

```
identify -verbose output.png
```

## 压缩

安装：

```
# Linux
sudo apt-get install pngquant

# macOS
brew install pngquant
```

用法：
```
pngquant --quality=80-90 input.png --output output.png
```