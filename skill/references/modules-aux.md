# 辅助模块字段规范

> 本文件在生成辅助模块（Phase A-aux）前加载。辅助模块共 11 个，搜索配额耗尽时标注"本次未生成"并跳过，不推断填充。

---

## 模块2: Products（产品数据库）[辅助]

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

## 模块4: Keywords（关键词数据库）[辅助]

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

## 模块5: Supply-Chain（供应链数据库）[辅助]

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

## 模块6: Business-Models（商业模式数据库）[辅助]

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

## 模块7: Regulations（监管合规数据库）[辅助]

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

## 模块9: Content-Ecosystem（内容生态数据库）[辅助]

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

## 模块10: Communities（社区数据库）[辅助]

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

## 模块11: Influencers（影响者数据库）[辅助]

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

## 模块12: Trends（行业趋势数据库）[辅助]

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

## 模块14: Knowledge-Map（知识地图）[辅助]

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

## 模块15: Sources（信息源数据库）

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
