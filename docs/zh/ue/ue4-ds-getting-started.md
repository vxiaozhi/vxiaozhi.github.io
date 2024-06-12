 
# UnrealEngine-4.23.1 引擎编译安装及Dedicated Server服务搭建

本文将详细介绍如何在 Windows 操作系统上 编译安装UnrealEngine-4.23.1引擎，并搭建ds服务。
 
**为什么要编译安装 UnrealEngine？**

官方文档这里有说明：[Setting Up Dedicated Servers](https://docs.unrealengine.com/4.27/en-US/InteractiveExperiences/Networking/HowTo/DedicatedServers/)， 只有编码编译方式才能支持 ds。
除此之外，源码编译安装使您能够在开发过程中进行更深入的调试和优化，可以在代码级别上调查问题，并进行性能优化。
 
 
## 引擎编译安装

### 关联 Github 账号

进入虚幻官网个人账号页面的[【应用与账户】](https://www.epicgames.com/account/connections)，将 Github 账号与 UlrealEngine 账号关联，关联成功后的页面如下：

![epic-account](https://wmxiaozhi.github.io/picx-images-hosting/picx-imgs/2024/epic-account.jpg)

接着刷新 github 个人主页，接受来自 EpicGame 的邀请函：

![epic_invite](https://wmxiaozhi.github.io/picx-images-hosting/picx-imgs/2024/epic_invite.jpg)

此时你已经成功成为 EpicGame 的成员啦~

### 下载源码

访问UnrealEngine，下载UnrealEngine-4.23.1的源码压缩包。 github地址：  

https://github.com/EpicGames/UnrealEngine/tree/4.23.1-release ，
 
###  解压源码

解压源码压缩包，得到UnrealEngine-4.23.1的源码目录。

### 配置编译环境

在源码目录下，运行以下命令，配置编译环境：

```
Setup.bat
```
 
执行 Setup.bat 之前先 下载：Commit.gitdeps.xml ,并把文件替换到 Engine/Build/Commit.gitdeps.xml

 （下载地址：https://github.com/EpicGames/UnrealEngine/releases/tag/4.23.1-release）

备注： 该步骤必须，否则会出现会出错， 这里是原因说明：

```
IMPORTANT
Per a previous announcement on GitHub Disruption. To remedy related download errors, a new Commit.gitdeps.xml file is attached to this release as an Asset. Please replace the existing Engine/Build/Commit.gitdeps.xml with the attached file.
```

 
### 编译引擎

在配置好的编译环境下，运行以下命令，生成 Visual Studio 项目文件：

```
GenerateProjectFiles.bat 
```

执行完成，会生成 UE4.sln， 用Visual Studio 2017 打开编译。

![ue4_ds_1a](https://wmxiaozhi.github.io/picx-images-hosting/picx-imgs/2024/ue4_ds_1a.jpg)

生成 UE4：

![ue4_ds_2a](https://wmxiaozhi.github.io/picx-images-hosting/picx-imgs/2024/ue4_ds_2a.jpg)
 
编译时间会较久， 根据电脑配置不同，大概在 20分钟-2个小时， 编译完成后，生成的最终可执行文件路径为：
``` 
UnrealEngine-4.23.1-release\Engine\Binaries\Win64\UE4Editor.exe
```
 
## ds服务搭建

### 创建游戏工程

这里 以 创建一个第三人称游戏项目为例
注意： 必需选择 C++ 项目， 如果选择 蓝图 项目， 那么生成的项目目录中 没有 Source 目录， 无法直接 设置 服务器 target。

![ue4_ds_3a](https://wmxiaozhi.github.io/picx-images-hosting/picx-imgs/2024/ue4_ds_3a.jpg)

### 设置服务器target

![ue4_ds_4a](https://wmxiaozhi.github.io/picx-images-hosting/picx-imgs/2024/ue4_ds_4a.jpg)

```
// Copyright 1998-2019 Epic Games, Inc. All Rights Reserved.

using UnrealBuildTool;
using System.Collections.Generic;

public class ThirdPersonGameServerTarget : TargetRules
{
	public ThirdPersonGameServerTarget(TargetInfo Target) : base(Target)
	{
		Type = TargetType.Server;
		ExtraModuleNames.Add("ThirdPersonGame");
	}
}
```
 
 
### 编译

编译之前， 重新生成项目文件：

![ue4_ds_5a](https://wmxiaozhi.github.io/picx-images-hosting/picx-imgs/2024/ue4_ds_5a.jpg)
 

 
依次选择 Development Client, Development Editor, Development Server, 并进行编译。 

![ue4_ds_6a](https://wmxiaozhi.github.io/picx-images-hosting/picx-imgs/2024/ue4_ds_6a.jpg)

### 设置地图
 
再内容浏览器中， 找到 ThirdPersonExampMap，重命名为：ThirdPersonServerMap，我们后面会将其作为server的启动地图。
 
![ue4_ds_7a](https://wmxiaozhi.github.io/picx-images-hosting/picx-imgs/2024/ue4_ds_7a.jpg)
 
在相同目录下，创建一个新的关卡地图，并命名为： ClientEntryMap。

![ue4_ds_8a](https://wmxiaozhi.github.io/picx-images-hosting/picx-imgs/2024/ue4_ds_8a.jpg)
 
打开该关卡蓝图

![ue4_ds_9a](https://wmxiaozhi.github.io/picx-images-hosting/picx-imgs/2024/ue4_ds_9a.jpg)

 
添加新的节点， 表示当BeginPlay事件出发时， 主动连接服务器打开关卡。

![ue4_ds_10a](https://wmxiaozhi.github.io/picx-images-hosting/picx-imgs/2024/ue4_ds_10a.jpg)

 
修改GameMode 为如下：
![ue4_ds_11a](https://wmxiaozhi.github.io/picx-images-hosting/picx-imgs/2024/ue4_ds_11a.jpg)
 
打开项目设置，找到 Maps & Modes ，然后展开默认模式。将它们更改为以下内容：

![ue4_ds_12a](https://wmxiaozhi.github.io/picx-images-hosting/picx-imgs/2024/ue4_ds_12a.jpg)

 
Packaging 中去包含我们要打包的地图列表。将要打包的 ClientEntryMap 和 ThirdPersonServerMap添加进去。

![ue4_ds_13a](https://wmxiaozhi.github.io/picx-images-hosting/picx-imgs/2024/ue4_ds_13a.jpg)

### 打包

![ue4_ds_14a](https://wmxiaozhi.github.io/picx-images-hosting/picx-imgs/2024/ue4_ds_14a.jpg)
 
选择一个目录来打包项目：

![ue4_ds_15a](https://wmxiaozhi.github.io/picx-images-hosting/picx-imgs/2024/ue4_ds_15a.jpg)

 
### 测试
 
将 步骤 Development Server 中编译生成的文件拷贝到 这个目录下：ThirdPersonGame\package\WindowsNoEditor\ThirdPersonGame\Binaries\Win64
 
启动 Server， 注意加上log 参数， 否则 server 会直接在后台启动，无法直接查看log。

```
ThirdPersonGameServer.exe -log
```

启动成功后，可以看到 ，默认在 7777 端口监听：

![ue4_ds_16a](https://wmxiaozhi.github.io/picx-images-hosting/picx-imgs/2024/ue4_ds_16a.jpg)

 
在 UEEdittor 中 进入关卡， 点击 播放， 启动一个客户端， 连接服务器成功后，会出现一个人物模型。 

![ue4_ds_17a](https://wmxiaozhi.github.io/picx-images-hosting/picx-imgs/2024/ue4_ds_17a.jpg)

 
双击 再启动一个客户端 实例， 此时能看到另一个客户端的人物模型。

![ue4_ds_18a](https://wmxiaozhi.github.io/picx-images-hosting/picx-imgs/2024/ue4_ds_18a.jpg)

 
服务端也打印了 客户端连接的日志信息。 

![ue4_ds_19a](https://wmxiaozhi.github.io/picx-images-hosting/picx-imgs/2024/ue4_ds_19a.jpg)
 
### 快捷键

客户端打开后， 默认会全屏模式， 支持的快捷键：

- ~， 会启动调试模式，下方会有一个命令行窗口，输入 exit。 可退出游戏。
- F11 ： 在全屏和非全屏模式切换。

![ue4_ds_20a](https://wmxiaozhi.github.io/picx-images-hosting/picx-imgs/2024/ue4_ds_20a.jpg)
 
## 总结
以上就是 UnrealEngine-4.23.1 引擎编译安装及ds服务搭建的详细步骤。
 
