
| ID   | 模块             | 前端流程                                                 | 合约接口 (V1)      | MoSCoW |
| ---- | ---------------- | -------------------------------------------------------- | ------------------ | ------ |
| F‑01 | 钱包连接         | 连接按钮 → 获取地址/链 ID                                | —                  | Must   |
| F‑02 | ETH→Token Swap   | 输入 ETH → 估价 → Swap                                   | `ethToTokenSwap`   | Must   |
| F‑03 | Token→ETH Swap   | 输入 Token → 估价 → Swap                                 | `tokenToEthSwap`   | Must   |
| F‑04 | Token→Token Swap | 输入 Token → 估价 → Swap                                 | `tokenToTokenSwap` | Must   |
| F‑05 | Add Liquidity    | 输入 Token 数量 → 自动计算所需 ETH → 提交                | `addLiquidity`     | Must   |
| F‑06 | Remove Liquidity | 输入 LP 数量 → 提交                                      | `removeLiquidity`  | Must   |
| F‑07 | Dashboard 指标   | 监听 `TokenPurchase` & `EthPurchase` 事件或查询 Subgraph | -                  | Must   |
| F‑08 | 交易反馈         | Pending / 成功 / 失败 → 展示 TxHash                      | —                  | Must   |