---
layout:     post
title:      "如何创建 XML 网站地图 (并向 Google 提交)"
subtitle:   "如何创建 XML 网站地图 (并向 Google 提交)"
date:       2025-01-24
author:     "vxiaozhi"
catalog: true
tags:
    - seo
    - sitemap
---

# 网站地图（SiteMap）

站点地图是一个网站所有链接的容器。很多网站的连接层次比较深，爬虫很难抓取到，站点地图可以方便爬虫抓取网站页面，通过抓取网站页面，清晰了解网站的架构，网站地图一般存放在根目录下并命名sitemap，为爬虫指路，增加网站重要内容页面的收录。站点地图就是根据网站的结构、框架、内容，生成的导航网页文件。站点地图对于提高用户体验有好处，它们为网站访问者指明方向，并帮助迷失的访问者找到他们想看的页面。

站点地图（sitemap）一般分为两种方式来记录，xml格式文件或者txt文件，一般两种文件中包含了该网站的所有链接，可以提交给爬虫去爬取，让搜索引擎更快的去收录网站内容

## sitemap 格式

xml格式示例,sitemap.xml

```
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
   <url>
      <loc>http://www.example.com/</loc>
      <lastmod>2005-01-01</lastmod>
      <changefreq>monthly</changefreq>
      <priority>0.8</priority>
   </url>
   <url>
      <loc>http://www.example.com/catalog?item=12&amp;desc=vacation_hawaii</loc>
      <changefreq>weekly</changefreq>
   </url>
   <url>
      <loc>http://www.example.com/catalog?item=73&amp;desc=vacation_new_zealand</loc>
      <lastmod>2004-12-23</lastmod>
      <changefreq>weekly</changefreq>
   </url>
   <url>
      <loc>http://www.example.com/catalog?item=74&amp;desc=vacation_newfoundland</loc>
      <lastmod>2004-12-23T18:00:15+00:00</lastmod>
      <priority>0.3</priority>
   </url>
   <url>
      <loc>http://www.example.com/catalog?item=83&amp;desc=vacation_usa</loc>
      <lastmod>2004-11-23</lastmod>
   </url>
</urlset>
```

txt格式示例,sitemap.txt

```
http://www.example.com/
http://www.example.com/catalog?item=12&amp;desc=vacation_hawaii
http://www.example.com/catalog?item=73&amp;desc=vacation_new_zealand
http://www.example.com/catalog?item=74&amp;desc=vacation_newfoundland
http://www.example.com/catalog?item=83&amp;desc=vacation_usa
```


##  如何创建网站地图

### 方法1 手动编写

### 方法2 手网站地图生成工具

用流行的网站地图生成工具，如：

- [xml-sitemaps.com](https://xml-sitemaps.com)
- [web-site-map.com](https://web-site-map.com)
- [xmlsitemapgenerator.org](https://xmlsitemapgenerator.org)
- [xsitemap.com](https://xsitemap.com)

### 方法3 插件生成

搭建网站的框架如wordpress 、jekyll 都会提供插件来生成 sitemap.xml

例如， jekyll 提供了如下插件：

- [Jekyll Sitemap Generator Plugin](https://github.com/jekyll/jekyll-sitemap)

Jekyll Sitemap 安装流程如下：

- Jekyll version must greater than 3.5.0, run `bundle exec jekyll -v` to show version
- Add gem 'jekyll-sitemap' to your site's Gemfile and run bundle
- Add the following to your site's _config.yml:
  
```
url: "https://example.com" # the base hostname & protocol for your site
plugins:
  - jekyll-sitemap
```

- finally, `sitemap.xml` 将会在网站根目录下生成。




## 提交SiteMap到google

首先，你需要知道网站地图的位置。

如果你使用了插件，那么很有可能网站地图会存放在 domain.com/sitemap.xml。

如果你的网站地图是手动生成的，那么请将它命名为类似 sitemap.xml 这样的文件名，然后上传到网站根目录。这样你就可以通过 domain.com/sitemap.xml 来访问它了。

接着去到 Google 站长工具（Google Search Console）> 网站地图（Sitemaps）> 粘贴网站地图的地址 > 点击“提交”(“Submit”)


## 参考

- [如何创建 XML 网站地图](https://ahrefs.com/blog/zh/how-to-create-a-sitemap/)