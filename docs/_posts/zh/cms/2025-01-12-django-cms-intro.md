---
layout:     post
title:      "django-cms"
subtitle:   "django-cms"
date:       2025-01-12
author:     "vxiaozhi"
catalog: true
tags:
    - cms
---

# django-cms 

由 Django 编写的企业级 CMS，它功能实用、安全可靠，支持拖拽上传图片、轮播图、Docker 部署等功能，可轻松进行二次开发，多用于构建企业官网，比如：国家地理等网站就是基于它开发而成。

- [django-cms-quickstart](https://github.com/django-cms/django-cms-quickstart)

```
git clone git@github.com:django-cms/django-cms-quickstart.git
cd django-cms-quickstart
docker compose build web
docker compose up -d database_default
docker compose run --rm web python manage.py migrate
docker compose run --rm web python manage.py createsuperuser
docker compose up -d
```

Then open http://django-cms-quickstart.127.0.0.1.nip.io:8000 (or just http://127.0.0.1:8000) in your browser.
