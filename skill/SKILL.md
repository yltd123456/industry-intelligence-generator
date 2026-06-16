---
name: industry-research
description: 快速研究一个陌生行业并构建完整的行业认知体系。当用户提到"研究行业"、"了解行业"、"行业调研"、"行业分析"、"行业数据库"、"行业地图"、"进入一个行业"时触发。用户也可通过 /industry-research <行业名> 直接调用。
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

# Industry OS Generator V2-MVP

你是一个行业研究员。输入格式：`<行业名> [市场/地区]`。市场/地区为可选参数，默认"全球"。

## 执行前规则

1. 解析输入，提取行业名和市场/地区。不明确时用 AskUserQuestion 确认。
2. 所有输出写入当前工作目录下的 `{行业名}-Industry/`。
3. 禁止预创建空目录。目录在首次 Write 时自动创建。
4. 禁止将本模块内容写入其他模块目录。
5. 每个文件末尾必须包含来源标注区块：
   ```
   ---
   数据来源: [web-search] / [web-fetch] / [推断,待验证]
   生成时间: YYYY-MM-DD
   ```
6. 数据获取失败降级策略：
   - WebSearch 首次失败 → 换同义关键词重试（最多2轮）
   - WebFetch 返回 404 → 尝试该站首页 URL
   - WebFetch 仍然失败 → 用 WebSearch 获取该品牌/竞品的二手信息
   - 所有工具均失败 → 用已有知识推断内容，来源标注写 `[推断,待验证]`，文件头部加注 `> ⚠️ 本文数据因工具获取失败，由推断生成，需要人工验证`
7. 每个模块必须完成，不得跳过。

---

## 模块清单（15个模块）

以下15个模块必须全部完成。每完成一个模块，在内部进度中标记 ✅。全部 ✅ 后进入 Phase B。

---

### 模块1: Brands（品牌数据库）

**搜索策略**：WebSearch `{行业名} top brands {市场}` + WebSearch `{行业名} leading companies market share {市场}` + WebSearch `{行业名} 品牌 排行`

**输出结构**：
- `Brands/_index.md` — 全部品牌汇总表
- `Brands/{品牌名}.md` — 每个品牌独立文件

**最低数量**：≥15个品牌独立文件

**内容字段**（每个品牌文件必须包含全部）：
- 品牌名称
- 总部
- 官网 URL
- 主要产品（≥2个）
- 价格区间
- 销售渠道（≥2个）
- 估计规模
- 核心卖点（≥1个）
- 创始人背景
- 社媒账号（≥1个，无则写"未找到"）

---

### 模块2: Products（产品数据库）

**搜索策略**：WebSearch `{行业名} product categories market size segments` + WebSearch `{行业名} 市场规模 产品分类`

**输出结构**：
- `Products/_index.md` — 全部产品类型汇总
- `Products/{产品类型名}.md` — 每种产品类型独立文件

**最低数量**：≥5个产品类型文件

**内容字段**（每个产品文件必须包含全部）：
- 产品类型名称
- 市场规模估算（含年份）
- 核心特征
- 优点（≥2条）
- 缺点（≥2条）
- 用户评价摘要
- 爆款品牌（≥2个）
- 增长趋势（上升/平稳/下降 + 原因）

---

### 模块3: Pain-Points（用户痛点数据库）

**搜索策略**：WebSearch `site:reddit.com {行业名} complaints problems` + WebSearch `{行业名} pain points issues` + WebSearch `{行业名} 痛点 抱怨 问题` + WebSearch `site:zhihu.com {行业名} 避坑 踩坑`

**输出结构**：
- `Pain-Points/_index.md` — 全部痛点汇总（按频率排序）

**最低数量**：≥20条痛点条目

**内容字段**（每条痛点在 _index.md 中必须包含全部）：
- 痛点编号
- 痛点名称
- 类型（抱怨/需求/问题/目标）
- 频率（极高/高/中/低）
- 描述（≥2句话）
- 用户原话或典型表达（≥1条）
- 商业机会映射（≥1个）

---

### 模块4: Keywords（关键词数据库）

**搜索策略**：WebSearch `{行业名} keywords SEO search terms` + WebSearch `{行业名} Amazon keywords popular search` + WebSearch `{行业名} 关键词 搜索热词`

**输出结构**：
- `Keywords/_index.md` — 全部关键词按5类意图分组

**最低数量**：≥60个关键词（5类意图每类≥10个）

**内容字段**（每个关键词在表格中必须包含全部）：
- 关键词
- 搜索意图分类（Commercial / Informational / Comparison / Review / Buying-Intent）
- 主要搜索平台（≥1个）
- 预估量级（极高/高/中高/中/低）

---

### 模块5: Supply-Chain（供应链数据库）

**搜索策略**：WebSearch `{行业名} manufacturer OEM ODM factory {市场}` + WebSearch `{行业名} 供应链 代工 工厂` + WebSearch `{行业名} component supplier chipset`

**输出结构**：
- `Supply-Chain/_index.md` — 供应链关键企业汇总

**最低数量**：≥5家关键企业

**内容字段**（每家企业必须包含全部）：
- 企业名称
- 位置
- 供应链角色（方案商/代工厂/元器件供应商/认证服务商）
- 核心能力
- 主要客户（≥2个）
- 产能/规模估算

---

### 模块6: Business-Models（商业模式数据库）

**搜索策略**：WebSearch `{行业名} business model subscription razor blade` + WebSearch `{行业名} 盈利模式 商业模式 硬件 软件 订阅`

**输出结构**：
- `Business-Models/_index.md` — 行业主要商业模式分析

**最低数量**：≥3种商业模式

**内容字段**（每种模式必须包含全部）：
- 模式名称
- 代表品牌（≥1个）
- 收入结构描述
- 利润率估算
- 优势（≥2条）
- 劣势（≥2条）

---

### 模块7: Regulations（监管合规数据库）

**搜索策略**：WebSearch `{行业名} FDA CE FCC certification regulatory` + WebSearch `{行业名} 认证 合规 FDA CE FCC NMPA`

**输出结构**：
- `Regulations/_index.md` — 主要认证体系汇总

**最低数量**：≥4个认证体系

**内容字段**（每个认证必须包含全部）：
- 认证名称
- 适用市场/地区
- 核心要求摘要
- 获取时间估算
- 获取成本估算
- 对新进入者的影响

---

### 模块8: Competitors（竞品数据库）

**搜索策略**：WebSearch `{行业名} top companies market share {市场}` → 筛选≥5个头部竞品 → 对每个竞品 WebFetch 其官网

**输出结构**：
- `Competitors/{品牌名}-analysis.md` — 每个竞品独立分析文件
- `Competitors/_summary.md` — 行业竞品汇总

**最低数量**：≥5个竞品分析文件 + 1个汇总文件

**内容字段**（每个竞品分析文件必须包含全部）：
- 品牌名称、总部、官网 URL、品牌定位
- 导航结构（≥1级）及推断的利润/流量/转化产品
- 产品分类方式（≥2个系列）
- Collection 结构（≥3个成交路径）
- Product Tag 体系（≥3个标签类型）
- SEO 结构（Title模式、核心流量词≥3个）
- Blog/内容策略（主题方向≥2个）
- Landing Page 设计模式
- Social 结构（平台+侧重）

**汇总文件必须包含全部**：
- 行业共性问题（≥3条）
- 差异化策略（≥3条）
- 可复用模式（≥3条）
- 未被满足的空白（≥3条）

---

### 模块9: Content-Ecosystem（内容生态数据库）

**搜索策略**：WebSearch `{行业名} top youtube channels` + WebSearch `{行业名} top TikTok creators` + WebSearch `{行业名} top X accounts influencers` + WebSearch `{行业名} best newsletters blogs` + WebSearch `{行业名} 小红书 博主 推荐` + WebSearch `{行业名} trending viral content 2026`

**输出结构**：
- `Content-Ecosystem/Youtube.md`
- `Content-Ecosystem/X.md`
- `Content-Ecosystem/TikTok.md`
- `Content-Ecosystem/Instagram.md`
- `Content-Ecosystem/Newsletter.md`
- `Content-Ecosystem/_content-types.md`
- `Content-Ecosystem/_patterns.md`

**最低数量**：≥5个平台文件 + 1个分类文件 + 1个规律文件

**每个平台文件必须包含≥10个账号**，字段：
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
- 反复爆的选题（≥3类）
- 反复爆的结构（≥3种）
- 反复爆的标题模式（≥3种）
- 持续有效的类型（≥2种）

---

### 模块10: Communities（社区数据库）

**搜索策略**：WebSearch `{行业名} subreddit community forum` + WebSearch `{行业名} discord server` + WebSearch `{行业名} 论坛 社群 贴吧`

**输出结构**：
- `Communities/_index.md` — 全部社区汇总

**最低数量**：≥10个社区

**内容字段**（每个社区必须包含全部）：
- 社区名称
- 所属平台
- 成员数/关注数
- 活跃度评估（极高/高/中/低）
- 主要讨论方向（≥1个）

---

### 模块11: Influencers（影响者数据库）

**搜索策略**：WebSearch `{行业名} top influencers KOL` + WebSearch `{行业名} 博主 KOL 推荐` + WebSearch `{行业名} influencer marketing case`

**输出结构**：
- `Influencers/_index.md` — 全部影响者汇总

**最低数量**：≥20位影响者

**内容字段**（每位影响者必须包含全部）：
- 姓名/账号名
- 主平台
- 粉丝数
- 专业领域
- 合作价位估算（无公开信息写"未公开"）

---

### 模块12: Trends（行业趋势数据库）

**搜索策略**：WebSearch `{行业名} industry trends forecast 2025 2026 2027` + WebSearch `{行业名} 行业趋势 预测 2026`

**输出结构**：
- `Trends/_index.md` — 全部趋势汇总

**最低数量**：≥6条趋势

**内容字段**（每条趋势必须包含全部）：
- 趋势名称
- 驱动力（≥1个）
- 对行业的影响（≥1个）
- 时间线（当前/1-3年/3-5年）
- 机会窗口（≥1个）

---

### 模块13: Opportunities（机会数据库）

**搜索策略**：综合前面所有模块的发现进行推断，无需单独搜索

**输出结构**：
- `Opportunities/_index.md` — 全部机会汇总

**最低数量**：≥10条机会

**内容字段**（每条机会必须包含全部）：
- 机会名称
- 类型（创业机会 / 内容创业机会 / 投资机会）
- 估算市场规模
- 竞争壁垒
- 行动建议（≥1条具体步骤）

---

### 模块14: Knowledge-Map（知识地图）

**搜索策略**：WebSearch `{行业名} industry landscape segments taxonomy` + WebSearch `{行业名} 产业链 细分赛道`

**输出结构**：
- `Knowledge-Map/_level1.md` — 一级目录（主赛道）
- `Knowledge-Map/_level2.md` — 二级目录（细分赛道）
- `Knowledge-Map/_level3.md` — 三级目录（具体产品/技术/渠道）
- `Knowledge-Map/_connections.md` — 价值链连接关系
- `Knowledge-Map/_opportunity-map.md` — 机会地图
- `Knowledge-Map/{节点名}/overview.md` — 领域概述
- `Knowledge-Map/{节点名}/companies.md` — 主要公司
- `Knowledge-Map/{节点名}/tools.md` — 主要工具/产品
- `Knowledge-Map/{节点名}/trends.md` — 发展趋势
- `Knowledge-Map/{节点名}/opportunities.md` — 机会分析

**最低数量**：≥80%二级节点拥有知识卡片目录（每个目录含≥3个文件）

**内容字段**：
- _level1.md：一级赛道列表，每个赛道一行说明
- _level2.md：二级目录树 + 每个节点的1句话说明
- _level3.md：三级目录树 + 每个节点的1句话说明
- _connections.md：价值链流程图（ASCII） + 至少3组上下游关系描述
- _opportunity-map.md：≥4个领域分析（竞争最激烈/增长最快/创业机会最大/内容供给不足），每个领域≥2条分析
- 知识卡片每个文件≥3行实质内容

---

### 模块15: Sources（信息源数据库）

**搜索策略**：汇总研究过程中实际使用的所有信息来源

**输出结构**：
- `Sources/_index.md` — 全部信息源汇总

**最低数量**：≥10条信息源

**内容字段**（每条信息源必须包含全部）：
- 信息源名称
- 类型（YouTube频道 / X账号 / Reddit社区 / 行业报告 / 新闻站 / 官网 / 其他）
- URL
- 主要价值（1句话说明该源提供什么信息）
- 更新频率

---

## Phase B: 审计与补全（不可跳过）

所有15个模块 ✅ 后，必须执行以下审计。

### B1. 空目录扫描

```bash
find {行业名}-Industry -type d -empty
```

通过标准：输出为空（0个空目录）

### B2. 数量达标检查

逐项核对模块清单中每个 ≥N 下界：

| 模块 | 最低数量 | 实际数量 | 通过 |
|------|---------|---------|------|
| Brands 独立文件 | ≥15 | ? | ☐ |
| Products 独立文件 | ≥5 | ? | ☐ |
| Pain-Points 条目 | ≥20 | ? | ☐ |
| Keywords 条目 | ≥60 | ? | ☐ |
| Supply-Chain 企业 | ≥5 | ? | ☐ |
| Business-Models 模式 | ≥3 | ? | ☐ |
| Regulations 认证 | ≥4 | ? | ☐ |
| Competitors 分析文件 | ≥5 | ? | ☐ |
| Content-Ecosystem 平台文件 | ≥5 | ? | ☐ |
| Communities 社区 | ≥10 | ? | ☐ |
| Influencers 影响者 | ≥20 | ? | ☐ |
| Trends 趋势 | ≥6 | ? | ☐ |
| Opportunities 机会 | ≥10 | ? | ☐ |
| Knowledge-Map 知识卡片覆盖率 | ≥80% | ? | ☐ |
| Sources 信息源 | ≥10 | ? | ☐ |

通过标准：全部 ☐ 变为 ✅

### B3. README 一致性

```bash
find {行业名}-Industry -type f | wc -l
```

对比 README.md 中声明的文件总数。
通过标准：完全一致

### 审计结果处理

任一检查未通过 → 补全缺失内容 → 重新执行 B1-B3（最多2轮）
第2轮仍有未通过项 → 在 README.md 末尾追加"已知缺失"区块，列出未达标项及原因
全部通过 → 输出交付声明：

```
✅ 行业研究完成
行业：{行业名} | 市场：{市场}
文件数：{N} | 空目录：0
品牌覆盖：{X} | 竞品分析：{N} | 知识卡片覆盖率：{Z}%
```

---

## 收尾：生成 README.md

在根目录生成 `README.md`，包含：

1. 行业名、市场、生成日期
2. 完整目录树（仅列出实际存在的目录和文件）
3. 各子库的简要说明和实际文件数量
4. 使用建议（如何用 Obsidian 打开、如何持续更新）
5. 交付声明（审计通过后填入）

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

对行业核心 Blog 和 News 站点接入 RSS 阅读器。kscc 可定期 WebFetch 检查目标站点更新。
