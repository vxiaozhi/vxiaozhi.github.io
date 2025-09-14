---
layout:     post
title:      "行为树算法"
subtitle:   "行为树算法"
date:       2025-09-14
author:     "vxiaozhi"
catalog: true
tags:
    - gamedev
    - 行为树
---

行为树(Behavior Tree)​​ 是一种用于描述AI行为的树状数据结构，通过节点之间的层次关系来组织复杂的行为逻辑。

## 开源项目

- [BehaviorTree.CPP](https://github.com/BehaviorTree/BehaviorTree.CPP)
- [PyTrees](https://github.com/splintered-reality/py_trees)


## 🌳 基本结构

### 节点类型：

1. **控制节点(Composites)** - 决定执行流程
   - `Sequence` (顺序)：所有子节点成功才算成功
   - `Selector` (选择)：直到一个子节点成功
   - `Parallel` (并行)：同时执行多个子节点

2. **执行节点(Behaviours)** - 具体行为
   - `Action`：执行具体动作
   - `Condition`：检查条件

3. **装饰节点(Decorators)** - 修饰行为
   - 重复、取反、超时等修饰

## ⚡ 工作方式

- **自顶向下**执行
- **从左到右**遍历
- 每个节点返回三种状态：
  - ✅ `SUCCESS` (成功)
  - 🔄 `RUNNING` (执行中)
  - ❌ `FAILURE` (失败)


## 📊 简单示例

```
Selector (主行为)
├── Sequence (遇到敌人)
│   ├── Condition (发现敌人?)
│   └── Action (攻击)
└── Sequence (日常巡逻)
    ├── Action (移动)
    └── Action (观察)
```
