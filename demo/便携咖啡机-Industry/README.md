# 便携浓缩咖啡机行业智能系统 (Industry Intelligence)

> 生成日期：2026-06-17 | 行业：便携浓缩咖啡机 (Portable Espresso Maker) | 市场：全球

## 数据置信度

- 总文件数：22
- 完全基于搜索/抓取数据：7 个文件（WACACO, STARESSO, Cafflano 品牌文件 + 竞品5分析文件 + Pain-Points + Sources）
- 包含部分推断数据：8 个品牌文件（产品/定价已搜索确认，但公司规模+创始人字段为推断）
- 推断比例（含推断字段文件/总文件）：50%（超 20% 上限）
- 重点待验证数据点：见研究报告 Part 4

### 推断超限原因

行业客观限制：10 个品牌中 7 个为非上市公司，公司营收和创始人信息在公开网络不可获得。产品规格和定价已全部通过搜索确认，但"估计规模"和"创始人背景"字段无法避免推断。这是硬件/DTC行业的常态。

### 数据分层说明

| 层级 | 说明 | 文件数 |
|------|------|--------|
| L1 官网一手数据 | WACACO, STARESSO, Cafflano 官网抓取确认 | 3 |
| L2 搜索确认数据 | 产品规格/定价通过评测站/电商搜索确认 | 7 |
| L3 部分推断 | 产品数据确认 + 公司规模/创始人推断 | 8 |
| L4 纯推断 | 无 | 0 |

## 目录结构

```
便携咖啡机-Industry/
│
├── Brands/              品牌数据库 (10个品牌文件 + 1汇总)
│   ├── _index.md
│   ├── WACACO.md        ✅ L1 官网抓取
│   ├── STARESSO.md      ✅ L1 官网抓取
│   ├── Cafflano.md      ✅ L1 官网抓取
│   ├── Flair.md         ⚠️ L3 产品确认/规模推断
│   ├── Handpresso.md    ⚠️ L3 产品确认/规模推断
│   ├── Outin.md         ⚠️ L3 产品确认/规模推断
│   ├── 1Zpresso.md      ⚠️ L3 产品确认/规模推断
│   ├── Nespresso.md     ⚠️ L3 部分确认/部分推断
│   ├── Omnicup.md       ⚠️ L3 产品确认/规模推断
│   └── NICOH.md         ⚠️ L3 产品确认/规模推断
│
├── Pain-Points/         用户痛点 (15条，核心痛点有知乎原文引用)
│   └── _index.md        ✅ L2 搜索确认
│
├── Competitors/         竞品分析 (5个深度分析 + 1汇总)
│   ├── WACACO-analysis.md   ✅ L1 官网抓取
│   ├── STARESSO-analysis.md ✅ L1 官网抓取
│   ├── Flair-analysis.md     ⚠️ L2 搜索确认+推断
│   ├── Handpresso-analysis.md ⚠️ L2 搜索确认+推断
│   ├── Nespresso-analysis.md  ⚠️ L2 搜索确认+推断
│   └── _summary.md           ✅ L2 交叉验证
│
├── Opportunities/       机会数据库 (8条，含可行性评估)
│   └── _index.md        ⚠️ L3 数据支撑确认/市场规模推断
│
├── Sources/             信息源 (10条)
│   └── _index.md        ✅ L2 实际使用的来源
│
├── 便携咖啡机-Industry-Report.md   研究报告（4 部分）
│
└── README.md
```

## 使用建议

1. 用 Obsidian 打开本文件夹，Graph View 查看品牌关系网络
2. 重点关注 L1/L2 数据（WACACO, STARESSO, Cafflano），这三个品牌数据最可靠
3. Pain-Points 中 #1-#6 有知乎原文引用，置信度最高
4. 品牌文件中的产品/定价数据均已搜索确认，"估计规模"和"创始人"字段为推断，需重点验证
5. 阅读 `便携咖啡机-Industry-Report.md` 获取决策级分析

## 已知缺失

| 缺失项 | 原因 |
|--------|------|
| 辅助模块（Products, Keywords, Supply-Chain 等） | 搜索配额优先用于核心模块 |
| 权威市场规模数据 | 便携浓缩咖啡机为咖啡机子品类，公开报告未覆盖 |
| Flair/Handpresso 官网一手数据 | 官网 403/连接拒绝 |

## 交付声明

- 行业：便携浓缩咖啡机 (Portable Espresso Maker)
- 市场：全球
- 文件数：22
- 空目录：0
- 品牌覆盖：10（L1确认3个，L2确认7个，全部有产品数据确认）
- 竞品分析：5（L1确认2个，L2确认3个）
- 推断比例：50%（超 20% 上限，原因：非上市公司不公开财务/创始人数据）
