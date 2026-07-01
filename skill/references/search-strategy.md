# 搜索策略与行业类型判断

> 本文件在 Phase A 开始时加载一次。包含行业类型判断（决定垂直源优先级）和三级搜索框架（L1→L2→L3）。

## 行业类型判断

判断行业类型，加载对应的垂直数据源优先级：

| 行业类型 | 判断线索 | 垂直源优先 |
|----------|---------|-----------|
| 硬件/消费电子 | 产品含"设备/器具/仪器/配件" | Alibaba, 1688, 企查查, 天眼查 |
| 软件/SaaS | 产品含"平台/工具/应用/服务/软件" | Crunchbase, G2, Capterra, ProductHunt |
| 医疗/健康 | 产品含"诊断/治疗/检测/药物/器械" | FDA 510(k), NMPA, ClinicalTrials.gov, PubMed |
| 食品/饮料 | 产品含"饮品/零食/调味/保健品" | FDA GRAS, 电商评论, 配料表数据库 |
| 金融/保险 | 产品含"保险/贷款/支付/理财/证券" | SEC EDGAR, FINRA, 银保监会, Crunchbase |
| 通用 | 无法明确归类 | 不加载垂直源，使用 L1 通用权威源 |

判断方式：分析行业名关键词。不确定时默认"通用"。

---

## 搜索策略框架（三级结构）

所有模块的搜索策略遵循 L1→L2→L3 降级路径：

### L1 — 权威数据源优先（必须先搜）

| 需要的数据 | 搜索句式 | 目标来源 |
|-----------|---------|---------|
| 市场规模 | `{行业名} market size report 2025 2026` | Statista, Grand View Research, IDC, Mordor Intelligence |
| 公司收入 | `{品牌名} revenue annual report` / `site:sec.gov {品牌名}` | SEC EDGAR, 上市公司年报, Crunchbase |
| 品牌排名 | `{行业名} market share ranking 2025 2026` | Euromonitor, Nielsen, 行业报告站 |
| 产品评论 | `{品牌名} review site:reddit.com` / `{品牌名} review site:amazon.com` | Reddit, Amazon, Wirecutter |
| 监管认证 | `{行业名} FDA clearance` / `{行业名} CE certification requirements` | FDA 510(k) database, CE lookup |
| 供应链 | `{行业名} OEM ODM manufacturer China` | Alibaba, 企查查, 天眼查 |
| 竞品流量 | `{品牌名} website traffic` / `{品牌名} organic keywords` | SimilarWeb, Ahrefs open data |
| 用户痛点 | `site:reddit.com {行业名} complaint` / `site:zhihu.com {行业名} 避坑` | Reddit, 知乎, 贴吧 |
| 内容趋势 | `{行业名} trending content 2026` / `{行业名} viral youtube` | YouTube trending, TikTok creative center |
| 融资数据 | `{品牌名} funding crunchbase` / `site:crunchbase.com {行业名}` | Crunchbase, PitchBook, IT桔子 |

### L2 — 补充搜索（L1 结果不够时使用）

使用泛关键词搜索：
- `{行业名} top brands {市场}`
- `{行业名} 品牌 排行`
- `{行业名} leading companies`

### L3 — 垂直源直达（根据行业类型判断加载）

使用对应行业类型的垂直数据源直接搜索。
