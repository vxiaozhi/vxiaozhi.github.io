---
layout:     post
title:      "线性回归"
subtitle:   "线性回归"
date:       2025-04-26
author:     "vxiaozhi"
catalog: true
tags:
    - deeplearning
---

回归（regression）是能为一个或多个自变量与因变量之间关系建模的一类方法。 在自然科学和社会科学领域，回归经常用来表示输入和输出之间的关系。

线性回归（linear regression）可以追溯到19世纪初， 它在回归的各种标准工具中最简单而且最流行。 线性回归基于几个简单的假设： 首先，假设自变量x 和因变量y 之间的关系是线性的， 即y 可以表示为
x中元素的加权和，这里通常允许包含观测值的一些噪声； 其次，我们假设任何噪声都比较正常，如噪声遵循正态分布。

模型参数（model parameters）的求解需要需要两个东西： 

- （1）一种模型质量的度量方式；通常为损失函数（loss function）
- （2）一种能够更新模型以提高模型预测质量的方法。通常包括求 解析解 和 随机梯度下降（stochastic gradient descent） 两种方式。

## 解析解

线性回归刚好是一个很简单的优化问题。 与其他大部分模型不同，线性回归的解可以用一个公式简单地表达出来， 这类解叫作解析解（analytical solution）。 
首先，我们将偏置b 合并到参数w 中，合并方法是在包含所有参数的矩阵中附加一列。 我们的预测问题是最小化 (y-wx)^2 。 这在损失平面上只有一个临界点，这个临界点对应于整个区域的损失极小点。 将损失关于
w的导数设为0，得到解析解.

像线性回归这样的简单问题存在解析解，但并不是所有的问题都存在解析解。 解析解可以进行很好的数学分析，但解析解对问题的限制很严格，导致它无法广泛应用在深度学习里。


## 随机梯度下降

即使在我们无法得到解析解的情况下，我们仍然可以有效地训练模型。 在许多任务上，那些难以优化的模型效果要更好。 因此，弄清楚如何训练这些难以优化的模型是非常重要的。

梯度下降（gradient descent）这种方法几乎可以优化所有深度学习模型。 它通过不断地在损失函数递减的方向上更新参数来降低误差。

梯度下降最简单的用法是计算损失函数（数据集中所有样本的损失均值） 关于模型参数的导数（在这里也可以称为梯度）。 但实际中的执行可能会非常慢：因为在每一次更新参数之前，我们必须遍历整个数据集。 因此，我们通常会在每次需要计算更新的时候随机抽取一小批样本， 这种变体叫做小批量随机梯度下降（minibatch stochastic gradient descent）。

## 二元线性回归模型训练实例

以下是一个完全手写的二元线性回归模型训练实例，包含从数据生成到模型训练的全过程：

- 完全自主实现：
- 不使用任何机器学习框架
- 手动实现梯度计算和参数更新

训练过程​​：

- 手工计算均方误差（MSE）损失
- 手动推导梯度计算公式：
  - ∂Loss/∂w₁ = (2/n)Σ(y_pred - y_true)x₁
  - ∂Loss/∂w₂ = (2/n)Σ(y_pred - y_true)x₂
  - ∂Loss/∂b = (2/n)Σ(y_pred - y_true)
- 参数更新公式：θ = θ - α*∇θ

```
import random

# 数据生成函数（手动创建训练集）
def generate_data(num_samples=100):
    # 真实参数：w1=2, w2=-3, b=5
    w_true = [2, -3]
    b_true = 5
    data = []
    
    for _ in range(num_samples):
        # 生成两个特征（范围0-10）
        x1 = random.uniform(0, 10)
        x2 = random.uniform(0, 10)
        # 计算目标值并添加噪声
        noise = random.gauss(0, 1)  # 高斯噪声
        y = w_true[0]*x1 + w_true[1]*x2 + b_true + noise
        data.append(([x1, x2], y))
    
    return data

# 模型定义
class LinearRegression:
    def __init__(self):
        # 手动初始化参数
        self.w = [random.uniform(-1, 1) for _ in range(2)]  # 权重
        self.b = random.uniform(-1, 1)                     # 偏置项
    
    def predict(self, x):
        # 前向计算：y = w1*x1 + w2*x2 + b
        return self.w[0]*x[0] + self.w[1]*x[1] + self.b
    
    def train(self, data, learning_rate=0.01, epochs=100):
        n = len(data)
        
        for epoch in range(epochs):
            total_loss = 0
            grad_w = [0.0, 0.0]  # 梯度累积
            grad_b = 0.0
            
            # 遍历所有样本
            for x, y_true in data:
                # 计算预测值
                y_pred = self.predict(x)
                
                # 计算损失（MSE）
                loss = (y_pred - y_true)**2
                #print(f"样本：{x} | 真实值：{y_true:.3f} | 预测值：{y_pred:.3f} | 损失：{loss:.3f}")
                total_loss += loss
                
                # 计算梯度（手工求导）
                error = y_pred - y_true
                grad_w[0] += error * x[0]
                grad_w[1] += error * x[1]
                grad_b += error
            
            # 参数更新（批量梯度下降）
            self.w[0] -= learning_rate * (grad_w[0]/n)
            self.w[1] -= learning_rate * (grad_w[1]/n)
            self.b -= learning_rate * (grad_b/n)
            
            # 打印训练进度
            if (epoch+1) % 10 == 0:
                avg_loss = total_loss / n
                print(f"Epoch {epoch+1}/{epochs} | Loss: {avg_loss:.4f}")

# 训练流程
if __name__ == "__main__":
    # 生成训练数据（100个样本）
    train_data = generate_data(10000)
    
    # 初始化模型
    model = LinearRegression()
    print("初始参数：")
    print(f"w1={model.w[0]:.3f}, w2={model.w[1]:.3f}, b={model.b:.3f}")
    
    # 开始训练
    model.train(data=train_data, learning_rate=0.001, epochs=200000)
    
    # 显示最终参数
    print("\n训练后参数：")
    print(f"w1={model.w[0]:.3f} (真实值：2.000)")
    print(f"w2={model.w[1]:.3f} (真实值：-3.000)")
    print(f"b={model.b:.3f} (真实值：5.000)")
    
    # 测试预测
    test_sample = [3.0, 4.0]
    pred = model.predict(test_sample)
    true_value = 2 * 3.0 + (-3)*4.0 + 5
    print(f"\n测试样本预测：{pred:.3f} (真实值：{true_value:.3f})")
```

## 参考

- [李沐 《动手学深度学习》-- 线性回归](https://zh.d2l.ai/chapter_linear-networks/linear-regression.html#)