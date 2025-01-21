---
layout:     post
title:      "macOS的defaults命令"
subtitle:   "macOS的defaults命令"
date:       2025-01-21
author:     "vxiaozhi"
catalog: true
tags:
    - mac
---

# 1. macOS的defaults命令

/usr/bin/defaults 是 Mac OS X系统默认配置的设置命令。 

以下是它的manual介绍：

```
 Defaults allows users to read, write, and delete Mac OS X user defaults from a command-line shell. Mac OS X applications and other programs use the
 defaults system to record user preferences and other information that must be maintained when the applications aren't running (such as default font
 for new documents, or the position of an Info panel). Much of this information is accessible through an application's Preferences panel, but some of
 it isn't, such as the position of the Info panel. You can access this information with defaults

 Note: Since applications do access the defaults system while they're running, you shouldn't modify the defaults of a running application. If you
 change a default in a domain that belongs to a running application, the application won't see the change and might even overwrite the default.

 User defaults belong to domains, which typically correspond to individual applications. Each domain has a dictionary of keys and values representing
 its defaults; for example, "Default Font" = "Helvetica". Keys are always strings, but values can be complex data structures comprising arrays,
 dictionaries, strings, and binary data. These data structures are stored as XML Property Lists.

 Though all applications, system services, and other programs have their own domains, they also share a domain named NSGlobalDomain.  If a default
 isn't specified in the application's domain, but is specified in NSGlobalDomain, then the application uses the value in that domain.
```

在macOS和iOS开发中我们可以通过Defaults来进行一些信息的管理，实现对于一些数据的暂存，因为它最终是存储到文件的，所以可以实现跨进程、线程和跨控制器等进行数据的传递和处理。因为NSUserDefaults是属于Foundation.framework，所以它是跨平台的，除了macOS和iOS还可用于tvOS和watchOS。具体的Api，大家可以参考Apple的开发文档。而macOS下的/usr/bin/defaults命令用来管理用户对于程序预设值，这些预设值可以确保离线存储，哪怕程序停止运行，一般这些值会在程序的偏好设置里找到对应的UI操作来进行修改。也可以通过/usr/bin/defaults命令进行增、删、改、查。

## defaults命令使用

下边我们通过 /usr/bin/defaults 命令操作用户预设来演示对应的应用程序的行为影响。

比如在Finder标题栏显示完整路径,可以使用

```
defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES
killall Finder
```

改变截屏图片的保存位置

```
defaults write com.apple.screencapture location 存放位置
killall SystemUIServer
```

显示Mac隐藏文件

```
defaults write com.apple.finder AppleShowAllFiles True
```

默认情况下，程序坞会将用户未设置「在程序坞中保留」，却已经打开的应用程序显示出来。时间久了，那些不活跃的「应用程序」一直显示在「程序坞」中，就会令「程序坞」变得杂乱。可以通过下面的命令，可以让「程序坞」只显示已打开应用，以减少不必要的干扰。

只显示已打开的应用程序的命令：

```
defaults write com.apple.dock static-only -boolean true; killall Dock
```

恢复为默认设置的命令：

```
defaults delete com.apple.dock static-only; killall Dock
```
