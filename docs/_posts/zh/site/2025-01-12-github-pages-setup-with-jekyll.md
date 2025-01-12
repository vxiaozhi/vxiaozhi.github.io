---
layout:     post
title:      "Github Pages + jekyll 搭建个人网站和博客"
subtitle:   "Github Pages + jekyll 搭建个人网站和博客"
date:       2025-01-12
author:     "vxiaozhi"
catalog: true
tags:
    - 建站
    - jekyll
---

# Github Pages + jekyll 搭建个人网站和博客


Jekyll 是 Github Pages 官方支持的静态网站生成工具，优点是在可以直接github上使用vscode online编辑md，提交后，github会承担生成html的工作。除了Jekyll， 还有其它一些工具方案，如：

- hugo， 参考：https://github.com/erikluo/erikluo.github.io/tree/main/hugo_blog
- vuepress ，参考： https://github.com/rd163/wmxiaozhi-articles/tree/main
- 纯js， 动态将md渲染成html， 参考：https://erikluo.github.io/#/

如果采用非jekyll方案， 需要在文档目录下新建一个 `.nojekyll` 文件。

nojekyll搭建参考：

- [Github Pages + jekyll 全面介绍极简搭建个人网站和博客](https://zhuanlan.zhihu.com/p/51240503)

实例参考：

- https://github.com/Huxpro/huxpro.github.io
- https://github.com/qiubaiying/qiubaiying.github.io

## 总结如下

**设置主题**

详细设置步骤及支持的默认主题参考：

- [Adding a theme to your GitHub Pages site using Jekyll](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/adding-a-theme-to-your-github-pages-site-using-jekyll)
- [Supported themes](https://pages.github.com/themes/)

实例 _config.yml 如下：

```
title: Minimal theme
logo: /assets/img/logo.png
description: Minimal is a theme for GitHub Pages.
show_downloads: true
google_analytics:
theme: jekyll-theme-minimal
```

注意：如果使用了github内置的主题(即设置了theme字段且其值为内置的名字)，github就会把你仓库的内容和内置主题内容合并到一起编译成静态网页。

**站点目录结构**

参考：[jekyll 站点目录结构](https://jekyllcn.com/docs/structure/)

jekyll 站点目录结构通常如下， 上述主题无一例外也都采用了如下的结构进行文件组织。

```
.
├── _config.yml
├── _data
│   └── members.yml
├── _drafts
│   ├── begin-with-the-crazy-ideas.md
│   └── on-simplicity-in-technology.md
├── _includes
│   ├── footer.html
│   └── header.html
├── _layouts
│   ├── default.html
│   └── post.html
├── _posts  这里放的就是你的文章了。文件格式很重要，必须要符合: YEAR-MONTH-DAY-title.MARKUP。 
│   ├── 2007-10-29-why-every-programmer-should-play-nethack.md
│   └── 2009-04-26-barcamp-boston-4-roundup.md
├── _sass
│   ├── _base.scss
│   └── _layout.scss
├── _site
├── .jekyll-cache
│   └── Jekyll
│       └── Cache
│           └── [...]
├── .jekyll-metadata
└── index.html # can also be an 'index.md' with valid front matter
```


**_layouts模板配置**

**目录配置**

**Markdown格式**

参考如下：

```
---
layout:     post
title:      "Blender简介"
subtitle:   "Blender简介"
date:       2025-01-10
author:     "vxiaozhi"
header-img: "imgs/home-bg.jpg"
catalog: true
tags:
    - 3d
    - blender
---
```

**本地预览**

1. Run script/bootstrap to install the necessary dependencies
2. Run bundle exec jekyll serve to start the preview server
3. Visit localhost:4000 in your browser to preview the theme

由于Jekyll对ruby版本有一定要求，建议使用docker方式运行：

```
# 建议使用 ruby 镜像，不要用 jekyll镜像
#docker run -it --rm -p 4000:4000 -v $PWD:/app -w /app jekyll/jekyll bash

# ruby 的具体使用版本可以在主题的 .github 中的action配置中看到。
docker run -it --rm -p 4000:4000 -v $PWD:/app -w /app ruby:3.2.0 bash
```

```
gem install bundler jekyll
./script/bootstrap
bundle exec jekyll serve --host 0.0.0.0
```

如果使用jekyll镜像，在ruby版本不对的情况下，会报如下错误：
```
fde67d60000-7fde67d63000 rw-p 00000000 00:00 0 
7ffc11a21000-7ffc12220000 rw-p 00000000 00:00 0                          [stack]
7ffc12244000-7ffc12247000 r--p 00000000 00:00 0                          [vvar]
7ffc12247000-7ffc12248000 r-xp 00000000 00:00 0                          [vdso]
ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0                  [vsyscall]


/usr/jekyll/bin/bundle: line 34:   299 Aborted                 (core dumped) su-exec jekyll $exe "$@"
```









