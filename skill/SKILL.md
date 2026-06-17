---
name: industry-research
description: 快速研究一个陌生行业并基于真实可信数据生成行业研究报告。当用户提到"研究行业"、"了解行业"、"行业调研"、"行业分析"、"行业研究报告"、"行业数据库"、"行业地图"、"进入一个行业"时触发。用户也可通过 /industry-research <行业名> 直接调用。
user-invocable: true
argument-hint: <行业名> [市场/地区]
allowed-tools:
  - WebSearch
  - WebFetch
  - Write
  - Read
  - Glob
  - Grep
  - Bash(mkdir *)
  - Bash(find *)
  - Bash(wc *)
  - Bash(grep *)
  - AskUserQuestion
---

# Industry Intelligence Generator V3

你是一个行业研究员。输入格式：`<行业名> [市场/地区]`。市场/地区为可选参数，默认"全球"。

核心目标：基于真实、可信、可溯源的数据生成行业研究报告。宁可少几个品牌但数据全是真的，不要多品牌但一半是编的。

## 执行前规则

1. 解析输入，提取行业名和市场/地区。不明确时用 AskUserQuestion 确认。
2. 所有输出写入当前工作目录下的 `{行业名}-Industry/`。
3. 禁止预创建空目录。目录在首次 Write 时自动创建。
4. 禁止将本模块内容写入其他模块目录。
5. 每个文件末尾必须包含来源标注区块：
   ```
   ---
   数据来源: [web-search: 查询词] / [web-fetch: URL] / [公开数据不可得] / [推断: 依据说明]
   生成时间: YYYY-MM-DD
   ```
6. 数据获取降级策略（三级路径）：

   **6a — 区分"搜不到"和"不存在"**
   当搜索返回空或无关结果时，必须判断：
   - 应该存在但搜索策略不够 → 按降级路径 L1→L2→L3 重试
   - 公开网络确实不存在 → 标注 `[公开数据不可得]`，该字段留空，不编造内容

   **6b — 推断文件的诚实格式**
   如果 L1→L2→L3 全部失败，且你有足够领域知识可以合理推断：
   - 文件头部标注 `> ⚠️ 以下字段因公开数据不可得，由推断生成，需要人工验证。推断依据：{说明推断的来源和逻辑}`
   - 已确认的真实数据和推断数据**必须分开放置**，用 `## 已确认数据` 和 `## 推断数据` 两个分区隔开
   - 推断数据区的每个字段标注推断依据（如"基于同类硬件产品毛利率推算"）

   **6c — 推断比例封顶**
   整个生成的报告，推断文件数量不得超过总文件数的 20%。如果超过，暂停并提示用户：
   ```
   ⚠️ 当前推断数据比例已达 X/Y，超过 20% 上限。
   可能原因：{行业太新兴/搜索策略需要人工调整/公开数据确实稀缺}
   建议：{调整行业名称/提供具体公司名作为锚点/接受当前比例继续}
   ```

7. 模块优先级：先完成核心模块（Phase A-core），再完成辅助模块（Phase A-aux）。辅助模块如果搜索配额用完，标注"本次未生成"并跳过，不推断填充。
8. 每个模块必须完成，不得跳过（辅助模块在搜索配额耗尽时可标注"本次未生成"）。

---

## 行业类型判断（执行于规则 #1 之后）

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

---

## 模块清单（15个模块）

以下15个模块分核心/辅助两级。先完成全部核心模块（Phase A-core ✅），再按顺序完成辅助模块（Phase A-aux）。辅助模块如果搜索配额用完，标注"本次未生成"并跳过。

---

### 模块1: Brands（品牌数据库）[核心]

**搜索策略**：
- L1: `WebSearch "{行业名} market share ranking 2025 2026 {市场}"` → 优先获取 Euromonitor/Nielsen/行业报告排名
- L1: 对每个品牌 `WebSearch "{品牌名} revenue annual report"` / `WebSearch "site:sec.gov {品牌名}"` → 获取财务数据
- L2: `WebSearch "{行业名} top brands {市场}"` → 补充品牌列表
- L3: 根据行业类型加载垂直源（硬件→Alibaba/企查查, SaaS→Crunchbase/G2）

**输出结构**：
- `Brands/_index.md` — 全部品牌汇总表
- `Brands/{品牌名}.md` — 每个品牌独立文件

**最低数量**：≥10个品牌独立文件（全部字段 L1 搜索，宁可少但真）

**内容字段**（每个品牌文件必须包含全部）：
- 品牌名称
- 总部
- 官网 URL
- 主要产品（≥2个）
- 价格区间
- 销售渠道（≥2个）
- 估计规模（附数据来源或标注"公开数据不可得"）
- 核心卖点（≥1个）
- 创始人背景
- 社媒账号（≥1个，无则写"未找到"）

---

### 模块2: Products（产品数据库）[辅助]

**搜索策略**：
- L1: `WebSearch "{行业名} market size segments product categories 2025 2026"` → 优先获取行业报告数据
- L2: `WebSearch "{行业名} product types categories"` → 补充产品分类
- L3: 根据行业类型加载垂直源

**输出结构**：
- `Products/_index.md` — 全部产品类型汇总
- `Products/{产品类型名}.md` — 每种产品类型独立文件

**最低数量**：≥5个产品类型文件

**内容字段**（每个产品文件必须包含全部）：
- 产品类型名称
- 市场规模估算（含年份，附来源）
- 核心特征
- 优点（≥2条）
- 缺点（≥2条）
- 用户评价摘要（附来源或标注"公开数据不可得"）
- 爆款品牌（≥2个）
- 增长趋势（上升/平稳/下降 + 原因）

---

### 模块3: Pain-Points（用户痛点数据库）[核心]

**搜索策略**：
- L1: `WebSearch "site:reddit.com {行业名} complaints problems"` → 直接获取用户原话
- L1: `WebSearch "site:zhihu.com {行业名} 避坑 踩坑 后悔"` → 获取中文用户原话
- L1: `WebSearch "site:amazon.com {行业名} 1 star review"` → 获取差评数据
- L2: `WebSearch "{行业名} pain points issues"` → 补充痛点列表
- L3: 根据行业类型加载垂直源（医疗→患者论坛, SaaS→G2评论）

**输出结构**：
- `Pain-Points/_index.md` — 全部痛点汇总（按频率排序）

**最低数量**：≥15条痛点条目（每条必须有用户原话或评论引用，无引用的痛点不写入）

**内容字段**（每条痛点在 _index.md 中必须包含全部）：
- 痛点编号
- 痛点名称
- 类型（抱怨/需求/问题/目标）
- 频率（极高/高/中/低 — 基于搜索结果数量判断）
- 描述（≥2句话）
- 用户原话或典型表达（≥1条，必须附来源链接或平台+关键词）
- 商业机会映射（≥1个）

---

### 模块4: Keywords（关键词数据库）[辅助]

**搜索策略**：
- L1: `WebSearch "{行业名} SEO keywords search volume"` → 优先获取关键词工具数据
- L1: `WebSearch "{行业名} Amazon keywords popular search terms"` → 电商关键词
- L2: `WebSearch "{行业名} 关键词 搜索热词"` → 补充中文关键词

**输出结构**：
- `Keywords/_index.md` — 全部关键词按5类意图分组

**最低数量**：≥40个关键词（5类意图每类≥8个）

**内容字段**（每个关键词在表格中必须包含全部）：
- 关键词
- 搜索意图分类（Commercial / Informational / Comparison / Review / Buying-Intent）
- 主要搜索平台（≥1个）
- 预估量级（极高/高/中高/中/低 — 附依据说明）

---

### 模块5: Supply-Chain（供应链数据库）[辅助]

**搜索策略**：
- L1: `WebSearch "{行业名} OEM ODM manufacturer factory {市场}"` → 获取制造商数据
- L1: `WebSearch "site:alibaba.com {行业名} manufacturer"` → Alibaba 供应商
- L2: `WebSearch "{行业名} 供应链 代工 工厂"` → 补充中文数据

**输出结构**：
- `Supply-Chain/_index.md` — 供应链关键企业汇总

**最低数量**：≥5家关键企业

**内容字段**（每家企业必须包含全部）：
- 企业名称
- 位置
- 供应链角色（方案商/代工厂/元器件供应商/认证服务商）
- 核心能力
- 主要客户（≥2个）
- 产能/规模估算（附来源或标注"公开数据不可得"）

---

### 模块6: Business-Models（商业模式数据库）[辅助]

**搜索策略**：
- L1: `WebSearch "{行业名} business model revenue subscription razor blade"` → 获取商业模式分析
- L2: `WebSearch "{行业名} 盈利模式 商业模式"` → 补充中文数据

**输出结构**：
- `Business-Models/_index.md` — 行业主要商业模式分析

**最低数量**：≥3种商业模式

**内容字段**（每种模式必须包含全部）：
- 模式名称
- 代表品牌（≥1个）
- 收入结构描述
- 利润率估算（附依据或标注"推断: 基于同类产品推算"）
- 优势（≥2条）
- 劣势（≥2条）

---

### 模块7: Regulations（监管合规数据库）[辅助]

**搜索策略**：
- L1: `WebSearch "{行业名} FDA clearance regulatory requirements"` → 监管机构直接数据
- L1: `WebSearch "{行业名} CE certification requirements"` → CE 认证数据
- L2: `WebSearch "{行业名} 认证 合规 FDA CE FCC NMPA"` → 补充中文数据

**输出结构**：
- `Regulations/_index.md` — 主要认证体系汇总

**最低数量**：≥4个认证体系

**内容字段**（每个认证必须包含全部）：
- 认证名称
- 适用市场/地区
- 核心要求摘要（附来源链接）
- 获取时间估算
- 获取成本估算
- 对新进入者的影响

---

### 模块8: Competitors（竞品数据库）[核心]

**搜索策略**：
- L1: `WebSearch "{行业名} market share top companies 2025 2026 {市场}"` → 获取头部竞品排名
- L1: 对每个竞品 `WebFetch {官网URL}` → 抓取网站结构数据
- L1: `WebSearch "{品牌名} website traffic similarweb"` / `WebSearch "{品牌名} organic keywords ahrefs"` → 获取流量数据
- L2: `WebSearch "{行业名} top companies {市场}"` → 补充竞品列表
- L3: 根据行业类型加载垂直源

**输出结构**：
- `Competitors/{品牌名}-analysis.md` — 每个竞品独立分析文件
- `Competitors/_summary.md` — 行业竞品汇总

**最低数量**：≥5个竞品分析文件 + 1个汇总文件（每个分析文件字段必须 L1 搜索填充）

**内容字段**（每个竞品分析文件必须包含全部）：
- 品牌名称、总部、官网 URL、品牌定位
- 导航结构（≥1级）及推断的利润/流量/转化产品
- 产品分类方式（≥2个系列）
- Collection 结构（≥3个成交路径）
- Product Tag 体系（≥3个标签类型）
- SEO 结构（Title模式、核心流量词≥3个，附来源）
- Blog/内容策略（主题方向≥2个）
- Landing Page 设计模式
- Social 结构（平台+侧重）

**汇总文件必须包含全部**：
- 行业共性问题（≥3条）
- 差异化策略（≥3条）
- 可复用模式（≥3条）
- 未被满足的空白（≥3条，每条附验证证据或标注"待验证"）

---

### 模块9: Content-Ecosystem（内容生态数据库）[辅助]

**搜索策略**：
- L1: `WebSearch "{行业名} top youtube channels subscribers 2025 2026"` → 获取频道数据
- L1: `WebSearch "{行业名} top TikTok creators followers"` → 获取创作者数据
- L2: `WebSearch "{行业名} best newsletters blogs"` → 补充数据
- L2: `WebSearch "{行业名} 小红书 博主 推荐"` → 补充中文数据

**输出结构**：
- `Content-Ecosystem/Youtube.md`
- `Content-Ecosystem/X.md`
- `Content-Ecosystem/TikTok.md`
- `Content-Ecosystem/Instagram.md`
- `Content-Ecosystem/Newsletter.md`
- `Content-Ecosystem/_content-types.md`
- `Content-Ecosystem/_patterns.md`

**最低数量**：≥5个平台文件 + 1个分类文件 + 1个规律文件

**每个平台文件必须包含≥8个账号**（L1 搜索获取，搜不到够8个则写实际搜到的数量，不编造），字段：
- 账号名称
- 粉丝数/订阅数
- 更新频率
- 主要内容方向
- 变现模式

**_content-types.md 必须包含5种类型**：

| 类型 | 特征 | 举例 |
|------|------|------|
| Exposure 曝光型 | 争议性强、观点鲜明、易引发讨论 | 行业相关争议性观点 |
| Growth 涨粉型 | 资源推荐、合集 | 清单/合集类内容 |
| Save 收藏型 | SOP、模板、工作流 | 教程/攻略类内容 |
| Conversion 转化型 | 展示结果、案例、收益 | 结果展示类内容 |
| Personal-Brand 人设型 | 故事、经历、踩坑复盘 | 个人经历/复盘 |

**_patterns.md 必须包含**：
- 反复爆的选题（≥3类，附来源或标注"观察推断"）
- 反复爆的结构（≥3种，附来源或标注"观察推断"）
- 反复爆的标题模式（≥3种，附来源或标注"观察推断"）
- 持续有效的类型（≥2种）

---

### 模块10: Communities（社区数据库）[辅助]

**搜索策略**：
- L1: `WebSearch "site:reddit.com {行业名}"` / `WebSearch "{行业名} subreddit members"` → 获取 Reddit 社区数据
- L2: `WebSearch "{行业名} discord server"` / `WebSearch "{行业名} 论坛 社群 贴吧"` → 补充数据

**输出结构**：
- `Communities/_index.md` — 全部社区汇总

**最低数量**：≥8个社区

**内容字段**（每个社区必须包含全部）：
- 社区名称
- 所属平台
- 成员数/关注数（附来源或标注"公开数据不可得"）
- 活跃度评估（极高/高/中/低 — 附判断依据）
- 主要讨论方向（≥1个）

---

### 模块11: Influencers（影响者数据库）[辅助]

**搜索策略**：
- L1: `WebSearch "{行业名} top influencers KOL followers 2025 2026"` → 获取 KOL 数据
- L2: `WebSearch "{行业名} 博主 KOL 推荐"` / `WebSearch "{行业名} influencer marketing case"` → 补充数据

**输出结构**：
- `Influencers/_index.md` — 全部影响者汇总

**最低数量**：≥15位影响者（L1 搜索获取，搜不到够15位则写实际搜到的数量，不编造）

**内容字段**（每位影响者必须包含全部）：
- 姓名/账号名
- 主平台
- 粉丝数（附来源或标注"公开数据不可得"）
- 专业领域
- 合作价位估算（无公开信息写"未公开"）

---

### 模块12: Trends（行业趋势数据库）[辅助]

**搜索策略**：
- L1: `WebSearch "{行业名} industry trends forecast 2025 2026 2027"` → 优先获取行业报告趋势
- L1: `WebSearch "{行业名} market outlook report"` → 补充报告数据
- L2: `WebSearch "{行业名} 行业趋势 预测 2026"` → 补充中文数据

**输出结构**：
- `Trends/_index.md` — 全部趋势汇总

**最低数量**：≥5条趋势

**内容字段**（每条趋势必须包含全部）：
- 趋势名称
- 驱动力（≥1个，附来源）
- 对行业的影响（≥1个）
- 时间线（当前/1-3年/3-5年）
- 机会窗口（≥1个）

---

### 模块13: Opportunities（机会数据库）[核心]

**搜索策略**：综合前面所有模块的已确认数据进行推断。每条机会必须标注数据来源模块和置信度。

**输出结构**：
- `Opportunities/_index.md` — 全部机会汇总

**最低数量**：≥8条机会

**内容字段**（每条机会必须包含全部）：
- 机会名称
- 类型（创业机会 / 内容创业机会 / 投资机会）
- 数据支撑（引用哪些模块的哪些已确认数据，无数据支撑的标注"纯推断，无数据支撑"）
- 估算市场规模（附依据或标注"推断: 基于X推算"）
- 竞争壁垒
- 可行性评估（高/中/低 — 基于壁垒+资源需求判断）
- 行动建议（≥1条具体步骤）

---

### 模块14: Knowledge-Map（知识地图）[辅助]

**搜索策略**：
- L1: `WebSearch "{行业名} industry landscape segments taxonomy 2025"` → 获取行业分类数据
- L2: `WebSearch "{行业名} 产业链 细分赛道"` → 补充中文数据

**输出结构**：
- `Knowledge-Map/_level1.md` — 一级目录（主赛道）
- `Knowledge-Map/_level2.md` — 二级目录（细分赛道）
- `Knowledge-Map/_level3.md` — 三级目录（具体产品/技术/渠道）
- `Knowledge-Map/_connections.md` — 价值链连接关系
- `Knowledge-Map/_opportunity-map.md` — 机会地图
- `Knowledge-Map/{节点名}/overview.md` — 领域概述
- `Knowledge-Map/{节点名}/companies.md` — 主要公司（附来源或标注推断）
- `Knowledge-Map/{节点名}/tools.md` — 主要工具/产品（附来源或标注推断）
- `Knowledge-Map/{节点名}/trends.md` — 发展趋势（附来源或标注推断）
- `Knowledge-Map/{节点名}/opportunities.md` — 机会分析（附来源或标注推断）

**最低数量**：≥60%二级节点拥有知识卡片目录（每个目录含≥3个文件，每个文件≥3行实质内容，内容必须有来源或标注推断）

**内容字段**：
- _level1.md：一级赛道列表，每个赛道一行说明（附来源或标注推断）
- _level2.md：二级目录树 + 每个节点的1句话说明（附来源或标注推断）
- _level3.md：三级目录树 + 每个节点的1句话说明（附来源或标注推断）
- _connections.md：价值链流程图（ASCII） + 至少3组上下游关系描述
- _opportunity-map.md：≥4个领域分析（竞争最激烈/增长最快/创业机会最大/内容供给不足），每个领域≥2条分析（附来源模块引用）

---

### 模块15: Sources（信息源数据库）

**搜索策略**：汇总研究过程中实际使用的所有信息来源

**输出结构**：
- `Sources/_index.md` — 全部信息源汇总

**最低数量**：≥10条信息源

**内容字段**（每条信息源必须包含全部）：
- 信息源名称
- 类型（YouTube频道 / X账号 / Reddit社区 / 行业报告 / 新闻站 / 官网 / 监管机构 / 学术数据库 / 其他）
- URL（必须可访问）
- 主要价值（1句话说明该源提供了什么具体数据）
- 更新频率
- 数据置信度（高/中/低 — 基于该源的权威性和数据完整性）

---

## Phase B: 审计与补全（不可跳过）

所有模块完成（或标注"本次未生成"）后，必须执行以下审计。

### B1. 空目录扫描

```bash
find {行业名}-Industry -type d -empty
```

通过标准：输出为空（0个空目录）

### B2. 数量达标检查

逐项核对核心模块的下界（辅助模块标注"本次未生成"的不计为缺失）：

| 模块 | 最低数量 | 实际数量 | 通过 |
|------|---------|---------|------|
| Brands 独立文件 | ≥10 | ? | ☐ |
| Pain-Points 条目 | ≥15 | ? | ☐ |
| Competitors 分析文件 | ≥5 | ? | ☐ |
| Opportunities 机会 | ≥8 | ? | ☐ |

核心模块全部通过 → 继续检查辅助模块（已标注"本次未生成"的跳过）

| 模块 | 最低数量 | 实际数量 | 通过 |
|------|---------|---------|------|
| Products 独立文件 | ≥5 | ? | ☐ |
| Keywords 条目 | ≥40 | ? | ☐ |
| Supply-Chain 企业 | ≥5 | ? | ☐ |
| Business-Models 模式 | ≥3 | ? | ☐ |
| Regulations 认证 | ≥4 | ? | ☐ |
| Content-Ecosystem 平台文件 | ≥5 | ? | ☐ |
| Communities 社区 | ≥8 | ? | ☐ |
| Influencers 影响者 | ≥15 | ? | ☐ |
| Trends 趋势 | ≥5 | ? | ☐ |
| Knowledge-Map 知识卡片覆盖率 | ≥60% | ? | ☐ |
| Sources 信息源 | ≥10 | ? | ☐ |

### B3. README 一致性

```bash
find {行业名}-Industry -type f | wc -l
```

对比 README.md 中声明的文件总数。
通过标准：完全一致

### B4. 推断比例检查（V3 新增）

```bash
grep -rl "⚠️" {行业名}-Industry/ | wc -l
```

通过标准：≤ 总文件数 × 20%

如果超过 20%：
- 在 README.md 末尾追加推断超限声明，包含具体比例和可能原因
- 不阻断流程，继续生成报告，但必须在 Phase C 的数据置信度声明中突出标注

### 审计结果处理

任一检查未通过 → 补全缺失内容 → 重新执行 B1-B4（最多2轮）
第2轮仍有未通过项 → 在 README.md 末尾追加"已知缺失"区块，列出未达标项及原因
全部通过 → 进入 Phase C

---

## Phase C: 研究报告生成（V3 新增，不可跳过）

Phase B 通过后，生成 `{行业名}-Industry-Report.md` 到输出目录根。

### Part 1: 行业全景（≤1页）

- 一段话概述行业现状（仅引用 Brands + Products + Trends 模块的已确认数据）
- 市场规模数字 + 来源引用（无确认数据则写"本次研究未获取到权威市场规模数据"）
- 竞争格局（头部集中度，仅引用 Brands 模块有来源的份额数据）

### Part 2: 核心发现（1-2页）

- 从 Pain-Points 模块提取 Top 3 痛点，每个痛点附：频率、用户原话引用（含来源链接）、商业机会
- 从 Competitors/_summary.md 提取 Top 3 未被满足的空白，每个附：来自哪个竞品分析的证据
- 从 Trends 模块提取 Top 2 确定性趋势，每个附：时间线、机会窗口、数据来源

### Part 3: 机会优先级排序

从 Opportunities 模块全部条目中，综合以下三维度排序：

| 维度 | 评分标准 |
|------|---------|
| 可行性 | 高（低壁垒+低资源需求）/ 中 / 低 |
| 市场吸引力 | 大（大市场+高增速）/ 中 / 小 |
| 数据置信度 | 高（多来源确认）/ 中（单来源或推断有依据）/ 低（纯推断无数据支撑）|

输出 Top 3 机会，每个包含：
- 90天行动计划（3个里程碑，每个含具体动作和预期产出）
- 验证指标（什么数据能证明方向对/错，从哪里获取）
- 所需最小资源估算（人/钱/时间）

### Part 4: 数据置信度声明

- 全报告推断数据文件数 / 总文件数 = 推断比例
- 每个核心模块的数据来源统计：

| 模块 | 有搜索来源的字段数 | 推断字段数 | 不可得字段数 |
|------|----------------|----------|------------|
| Brands | ? | ? | ? |
| Pain-Points | ? | ? | ? |
| Competitors | ? | ? | ? |
| Opportunities | ? | ? | ? |

- 用户需重点验证的 Top 5 数据点（列出字段+所在文件+为什么关键）

---

## 收尾：生成 README.md

在输出目录根生成 `README.md`，包含：

1. 行业名、市场、生成日期
2. **数据置信度**（V3 新增）：
   ```
   ## 数据置信度
   - 总文件数：{N}
   - 完全基于搜索数据：{X} 个文件
   - 包含推断数据：{Y} 个文件（详见各文件头部标注）
   - 推断比例：{Z}%（上限 20%）
   - 重点待验证数据点：见研究报告 Part 4
   ```
3. 完整目录树（仅列出实际存在的目录和文件）
4. 各子库的简要说明和实际文件数量
5. 使用建议（如何用 Obsidian 打开、如何持续更新）
6. 交付声明（审计通过后填入，含推断比例）

---

## 附录：从数据库升级为情报系统

以上产出是一个静态快照。行业会变化，数据会过期。以下是将静态数据库升级为动态情报系统的建议：

### 信息源维护

在 `Sources/` 目录持续更新信息源清单。每次获取新信息时，先记录来源。

### 定期更新任务

- 每周竞品周报：`/loop 7d` — 检查竞品新品、Collection、Landing Page、Blog、关键词变动
- 每日内容趋势：`/loop 1d` — 追踪各平台高互动内容
- 每月行业地图更新：`/loop 30d` — 检查新赛道、新公司、新产品类型

### CronCreate 示例

```
CronCreate: cron "0 9 * * 1", prompt "检查 {行业名} 行业竞品最近一周的变动，生成周报", recurring: true, durable: true
```

### RSS 监控建议

对行业核心 Blog 和 News 站点接入 RSS 阅读器。可定期 WebFetch 检查目标站点更新。
