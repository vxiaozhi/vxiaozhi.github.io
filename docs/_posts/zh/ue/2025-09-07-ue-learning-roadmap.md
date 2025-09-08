---
layout:     post
title:      "虚幻引擎 UE 学习路线"
subtitle:   "虚幻引擎 UE 学习路线"
date:       2025-09-07
author:     "vxiaozhi"
catalog: true
tags:
    - ue
---

虚幻引擎 UE 学习路线

## 一、启动项目

### 1. Roguelike

- [Action Roguelike C++ Unreal Engine Game](https://github.com/vxiaozhi/ActionRoguelike)

理由：

- 足够简单而且代码开源
- 提供 UE4.x - UE5.x 的支持。
- 有中英文教程
  - [斯坦福课程 UE4 C++ ActionRoguelike游戏实例教程 0.绪论 ](https://www.cnblogs.com/Qiu-Bai/p/17180550.html)

### Step

```
git clone git@github.com:vxiaozhi/ActionRoguelike.git
cd ActionRoguelike
git chekcout UE5.3
```

---

### 2. **CARLA - 自动驾驶模拟器**
- **GitHub 地址**: https://github.com/carla-simulator/carla
- **描述**: CARLA 是一个开源的自动驾驶模拟器，基于 Unreal Engine 构建。它提供了高度可定制的城市环境、交通模拟、传感器模拟（如摄像头、激光雷达）以及用于训练和测试自动驾驶算法的 API。
- **特点**:
   - 支持多种天气和光照条件。
   - 提供真实的物理模拟和交通行为。
   - 兼容 ROS（机器人操作系统）和 Autoware。

---

### 3. **AirSim - 无人机与车辆模拟器**
- **GitHub 地址**: https://github.com/microsoft/AirSim
- **描述**: AirSim 是微软开发的开源模拟器，最初专注于无人机，后来扩展支持车辆模拟。它基于 Unreal Engine（也支持 Unity），提供高保真的物理引擎和传感器模拟，适用于自动驾驶研究和机器学习。
- **特点**:
   - 支持多种车辆类型（汽车、无人机）。
   - 提供逼真的环境渲染和物理模拟。
   - 兼容 Python 和 C++ API，便于集成机器学习框架。

---

### 4. **DeepDrive - 自动驾驶模拟平台**
  - **GitHub 地址**: https://github.com/deepdrive/deepdrive
  - **描述**: DeepDrive 是一个基于 Unreal Engine 的自动驾驶模拟平台，专注于提供大规模数据集和训练环境。它支持端到端的深度学习模型训练，并提供丰富的传感器数据。
  - **特点**:
   - 支持多摄像头和 LiDAR 数据生成。
   - 提供预构建的城市环境和交通场景。
   - 易于与 TensorFlow 或 PyTorch 集成。

---



## 二、把项目改为：UnLua


## 三、把项目改为：UnLua + Python