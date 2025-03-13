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
## PNG 转 JPG

### **方法 1：使用 `convert` 命令（ImageMagick 工具）**

1. **安装 ImageMagick**（如果未安装）：
   ```bash
   # Linux (Debian/Ubuntu)
   sudo apt-get install imagemagick

   # macOS (通过 Homebrew)
   brew install imagemagick
   ```

2. **单文件转换**：
   ```bash
   convert input.png -background white -flatten output.jpg
   ```
   • `-background white`：将透明背景替换为白色（JPEG 不支持透明通道）。
   • `-quality 85`：可选项，设置压缩质量（默认 92，范围 1-100）。

3. **批量转换当前目录下所有 PNG 文件**：
   ```bash
   for file in *.png; do
     convert "$file" -background white -flatten "${file%.png}.jpg"
   done
   ```

### **方法 2：使用 `ffmpeg`**

1. **安装 ffmpeg**（如果未安装）：
   ```bash
   # Linux (Debian/Ubuntu)
   sudo apt-get install ffmpeg

   # macOS
   brew install ffmpeg
   ```

2. **转换单个文件**：
   ```bash
   ffmpeg -i input.png -q:v 2 output.jpg
   ```
   • `-q:v 2`：设置质量（值越小质量越高，范围 1-31）。

---

### **方法 3：使用 macOS 自带的 `sips` 命令**

仅适用于 macOS 系统：

```bash
sips -s format jpeg input.png --out output.jpg
```

**批量转换**：
```bash
mkdir jpg_images  # 创建输出目录
for file in *.png; do
  sips -s format jpeg "$file" --out "jpg_images/${file%.png}.jpg"
done
```

---

### **常见问题**

1. **保留原始尺寸和清晰度**：默认会保持原图分辨率，如需调整尺寸可添加 `-resize WIDTHxHEIGHT`（例如 `-resize 800x600`）。
2. **透明背景处理**：JPEG 不支持透明通道，务必使用 `-background 颜色 -flatten` 填充背景色。
3. **保留 EXIF 信息**：默认会保留，如需清除可添加 `-strip` 参数。

---
