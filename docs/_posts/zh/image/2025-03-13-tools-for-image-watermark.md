---
layout:     post
title:      "图片加水印的命令行工具"
subtitle:   "图片加水印的命令行工具"
date:       2025-03-13
author:     "vxiaozhi"
catalog: true
tags:
    - image
---

在 Linux 或 macOS 系统中，可以通过命令行工具（如 **ImageMagick** 或 **ffmpeg**）快速为图片添加水印。以下是几种常用方法：

---

### **方法 1：使用 ImageMagick（推荐）**

#### **1. 安装 ImageMagick**

```bash
# Linux (Debian/Ubuntu)
sudo apt-get install imagemagick

# macOS
brew install imagemagick
```

#### **2. 添加文字水印**

```bash
convert input.jpg -font Arial -pointsize 40 -fill "rgba(255,255,255,0.5)" \
-gravity southeast -annotate +20+10 "Your Watermark" output.jpg
```

• **参数说明**：
  • `-font Arial`：指定字体（使用 `convert -list font` 查看可用字体）。
  • `-pointsize 40`：文字大小。
  • `-fill "rgba(255,255,255,0.5)"`：文字颜色和透明度（0=全透明，1=不透明）。
  • `-gravity southeast`：水印位置（`southeast`=右下角，其他选项：`north`, `center` 等）。
  • `-annotate +20+10`：距离边缘的偏移量（水平+20，垂直+10）。

注意，如果 Ubuntu中，可能存在找不到Arial字体的情况， 通过如下命令安装字体：

```
#  安装字体包
sudo apt install ttf-mscorefonts-installer

# 刷新字体缓存

sudo fc-cache -f -v

# 验证安装
fc-list | grep -i "Arial"
```

#### **3. 添加图片水印**

```bash
convert input.jpg watermark.png -gravity center -geometry +0+0 -composite output.jpg
```

• **参数说明**：
  • `watermark.png`：水印图片（支持 PNG 透明背景）。
  • `-geometry +0+0`：水印位置偏移量（`+0+0`=居中，`+20-10`=右20上10）。
  • `-composite`：合并水印和原图。

#### **4. 批量添加水印**
```bash
for file in *.jpg; do
  convert "$file" -font Arial -pointsize 30 -fill "rgba(0,0,0,0.3)" \
  -gravity southeast -annotate +20+10 "Private" "watermarked_${file}"
done
```

---

### **方法 2：使用 ffmpeg**

#### **1. 安装 ffmpeg**

```bash
# Linux
sudo apt-get install ffmpeg

# macOS
brew install ffmpeg
```

#### **2. 添加文字水印**

```bash
ffmpeg -i input.jpg -vf "drawtext=text='Your Watermark':x=10:y=H-th-10:fontsize=24:fontcolor=white@0.5:fontfile=/path/to/font.ttf" -q:v 1 output.jpg
```
• **参数说明**：
  • `x=10:y=H-th-10`：水印位置（左下角，距离左10，下10）。
  • `fontcolor=white@0.5`：颜色和透明度。
  • `fontfile`：指定字体文件路径（必需）。

#### **3. 添加图片水印**

```bash
ffmpeg -i input.jpg -i watermark.png -filter_complex "overlay=10:main_h-overlay_h-10" output.jpg
```
• `overlay=10:main_h-overlay_h-10`：水印位置（左下角，距离左10，下10）。

---

### **方法 3：使用 macOS 自带的 `sips` 和 `textutil`（仅文字水印）**

```bash
# 生成透明背景的水印文字图片
textutil -convert png -font Arial -fontsize 40 -strokeColor "rgba(255,255,255,0.5)" -text "Watermark" -output watermark.png

# 合并水印和原图
sips input.jpg --overlay watermark.png --out output.jpg
```

---

### **常见问题 & 小技巧**

1. **水印位置计算**：
   • 使用 `-gravity` 定位（如 `southeast`=右下角），或通过 `-geometry` 手动调整偏移量。
   • 示例：`-geometry +20-10` 表示右移20像素，上移10像素。

2. **透明度控制**：
   • ImageMagick 使用 `rgba(255,255,255,0.5)`（最后一个值0-1为透明度）。
   • ffmpeg 使用 `white@0.5`（0.5=半透明）。

3. **批量处理**：
   • 使用 `find` 命令处理子目录文件：
     ```bash
     find . -name "*.jpg" -exec convert {} -font Arial -annotate ... {}.watermarked.jpg \;
     ```

4. **优化水印清晰度**：
   • 若水印模糊，尝试提高水印图片分辨率或使用矢量格式（如 SVG）。

---
