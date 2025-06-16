## **Uniswap v1 PRD**

> PRD 即项目/产品需求文档，作为团队中担任产品经理/项目经理/项目leader 角色的人员完成，用于定义项目/产品的背景、目标、核心功能需求等内容，是项目启动前期最重要的组成部分。

#### **1.项目概述（Project Overview）**

1.1  整体阐述

Uniswap V1 是以太坊上开创性的去中心化交易协议，采用自动做市商（AMM）机制，彻底抛弃了传统中心化撮合和订单簿模式。每一种代币都拥有独立的流动性池，任何人都可以在无需许可的前提下参与资产兑换或为池子注入流动性，获得手续费收益。Uniswap V1 的核心逻辑用一个极简的数学公式完成了价格发现、交易撮合和资产管理等全部功能。

1.2 汇总信息

| 项目       | 说明                                                         |
| ---------- | ------------------------------------------------------------ |
| 产品名称   | UniswapV1                                                    |
| 版本       | v1.0                                                         |
| 核心目标   | 实现 UniswapV1 核心功能（Swap + LP），用于去中心化交易所DEX项目学习、开发 |
| 核心用户   | 数字货币交易者、流动性提供者。                               |
| 区块链网络 | Ethereum Sepolia 测试网                                      |





#### **2.功能范围（ in of scope）**


1. **钱包连接**：MetaMask / WalletConnect，自动检测网络 & 余额。
   
2. **Swap**
   
    - `ethToTokenSwapInput`（ETH → Token）
      
    - `tokenToEthSwapInput`（Token → ETH）
      
    - `tokenToTokenInput`（Token → Token）
    
3. **流动性**
   
    - `addLiquidity`（添加流动性）
      
    - `removeLiquidity`（移除流动性，赎回 ETH & Token）
    
4. **Dashboard**：通过列表展示 Price、Reserve、TVL、24h Volume 等。



#### **3. 用户故事（ Personas & User Stories）**

| Persona                | 关键任务                                   | 成功标准                                                     |
| ---------------------- | ------------------------------------------ | ------------------------------------------------------------ |
| **Trader**             | 用 0.1 ETH 换 DAI                          | 查看最小到账量，Tx 确认后 Token 余额增加                     |
| **Liquidity Provider** | 存入 ETH+DAI 挣手续费                      | 成功获得 LP Token，并在 Positions 看到持仓份额               |
| **User**               | 为自有 ERC‑20 Token 创建池并注入启动流动性 | 新交易对与初始 TVL 成功显示，之后用户可正常进行 Swap / LP 操作 |



#### **4. 功能需求（ Feature  Demands）**

| 模块          | 功能点             | 描述                                                  | 优先级 |
| ------------- | ------------------ | ----------------------------------------------------- | ------ |
| **钱包连接**  | 支持 MetaMask 连接 | 用户连接钱包后显示地址和 ETH 余额。                   | P0     |
| **Swap**      | ETH → ERC20 兑换   | 输入 ETH 数量，输出 ERC20 数量，基于 `x*y=k` 计算。   | P0     |
|               | ERC20 → ETH 兑换   | 输入 ERC20 数量，输出 ETH 数量，基于 `x*y=k` 计算。   | P0     |
|               | ERC20 → ERC20兑换  | 输入 ERC20 数量，输出 ERC20 数量，基于 `x*y=k` 计算。 | P0     |
| **LP**        | 添加流动性         | 存入等值代币，获得 LP Token。                         | P0     |
|               | 移除流动性         | 销毁 LP Token，取回 ETH + ERC20 + 手续费收益。        | P0     |
|               |                    |                                                       |        |
| **Dashboard** | 实时价格 & 池信息  | 显示当前兑换率、池子储备量、用户 LP 份额。            | P1     |



#### 5.功能说明（Feature Description ）

> [Uniswap V1草图预览]: https://modao.cc/proto/7tZXTJ37swwgxk2C0wWtAn/sharing?view_mode=read_only&screen=rbpUmMbzXHsr8IJlf

**5.1 Feature 1 ：钱包连接（Wallet Connect）**

5.1.1 功能点：
支持 MetaMask 连接

5.2.2 功能描述：
用户连接钱包后显示地址，支持后续 Swap、LP 等核心功能使用。

5.3.3 优先级：
P0

**5.2 Feature 2：Swap**

5.2.1 功能点：
ETH → ERC20 兑换
ERC20 → ETH 兑换
ERC20 → ERC20 兑换

5.2.2 功能描述：
输入 ETH 数量，输出 ERC20 数量，基于 xy=k 计算。
输入ERC20 数量，输出 ETH 数量，基于 xy=k 计算。
输入 ERC20 数量，输出ERC20数量，基于 xy=k 计算。

5.2.3 优先级：
P0

#### **5.3 Feature 3 ：LP**

5.3. 1功能点：
添加流动性
移除流动性

5.3.2 功能描述：
存入等值代币，获得 LP Token。
销毁 LP Token，取回 ETH + ERC20 + 手续费收益。

5.3.2 优先级：
P0

#### **5.4 Feature 3 ：LP 信息显示**

5.3. 1功能点：
显示不同池子的信息

5.3.2 功能描述：
列表展示，包含序号#、Pool、Protocol、Fee、TVL、Pool APR、Reward APR、1D vol、30Dvol

5.3.2 优先级：
P1