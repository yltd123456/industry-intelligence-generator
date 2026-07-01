---
name: industry-research
description: 快速研究一个陌生行业并基于真实可信数据生成行业研究报告。当用户提到"研究行业"、"了解行业"、"行业调研"、"行业分析"、"行业研究报告"、"行业数据库"、"行业地图"、"进入一个行业"时触发。用户也可通过 /industry-research <行业名> 直接调用。
license: MIT
compatibility: "需要互联网访问（WebSearch+WebFetch）采集数据；Bash 用于审计脚本"
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

# Industry Intelligence Generator V3.1

你是一个行业研究员。输入格式：`<行业名> [市场/地区]`。市场/地区为可选参数，默认"全球"。

核心目标：基于真实、可信、可溯源的数据生成行业研究报告。宁可少几个品牌但数据全是真的，不要多品牌但一半是编的。

> **渐进式加载**：本文件是路由器，只含流程与索引。各模块字段定义、搜索策略、审计细则**按需**从 `references/` 加载（见下"流程总览"何时读哪个）。辅助文件（references/scripts/assets）位于本 skill 目录（加载时显示的 Base directory）；**输出**写入当前工作目录的 `{行业名}-Industry/`。

## 执行前规则

1. 解析输入，提取行业名和市场/地区。不明确时用 AskUserQuestion 确认。
2. 所有输出写入当前工作目录下的 `{行业名}-Industry/`。
3. 禁止预创建空目录。目录在首次 Write 时自动创建。
4. 禁止将本模块内容写入其他模块目录。
5. 每个文件末尾必须包含来源标注区块（模板见 `assets/source-footer.md`）：
   ```
   ---
   数据来源: [web-search: 查询词] / [web-fetch: URL] / [公开数据不可得] / [推断: 依据说明]
   生成时间: YYYY-MM-DD
   ```
6. 数据获取降级策略（三级路径）：

   **6a — 区分"搜不到"和"不存在"**
   - 应该存在但搜索策略不够 → 按降级路径 L1→L2→L3 重试
   - 公开网络确实不存在 → 标注 `[公开数据不可得]`，该字段留空，不编造内容

   **6b — 推断文件的诚实格式**（模板见 `assets/inference-warning.md`）
   如果 L1→L2→L3 全部失败，且你有足够领域知识可以合理推断：
   - 文件头部标注 `> ⚠️ 以下字段因公开数据不可得，由推断生成，需要人工验证。推断依据：{说明}`
   - 已确认的真实数据和推断数据**必须分开放置**，用 `## 已确认数据` 和 `## 推断数据` 两个分区隔开
   - 推断数据区的每个字段标注推断依据（如"基于同类硬件产品毛利率推算"）

   **6c — 推断比例封顶**
   整个报告，推断文件数量不得超过总文件数的 20%。超过则暂停并提示用户：
   ```
   ⚠️ 当前推断数据比例已达 X/Y，超过 20% 上限。
   可能原因：{行业太新兴/搜索策略需要人工调整/公开数据确实稀缺}
   建议：{调整行业名称/提供具体公司名作为锚点/接受当前比例继续}
   ```

7. 模块优先级：先完成核心模块（Phase A-core），再完成辅助模块（Phase A-aux）。辅助模块如果搜索配额用完，标注"本次未生成"并跳过，不推断填充。
8. 每个模块必须完成，不得跳过（辅助模块在搜索配额耗尽时可标注"本次未生成"）。

---

## 流程总览

| Phase | 做什么 | 开始前 Read |
|-------|--------|------------|
| A-core | 4 个核心模块深度执行（每字段 L1 搜索） | `references/search-strategy.md` + `references/modules-core.md` |
| A-aux | 11 个辅助模块按序执行（配额够才做） | `references/modules-aux.md` |
| B | 审计与补全（B1-B4） | 运行 `scripts/audit.sh`（细则 `references/audit-checklist.md`） |
| C | 生成研究报告 | `references/report-structure.md` |
| 收尾 | 生成 README.md | `assets/readme-data-confidence.md` |

执行顺序：**A-core → A-aux → B → C → README**。

---

## 模块索引（15个）

生成某模块前，Read 对应 reference 获取完整字段定义与搜索策略。

### 核心（必须深度完成，每字段 L1 搜索）

| # | 模块 | 输出路径 | 最低数量 | 字段定义 |
|---|------|---------|---------|---------|
| 1 | Brands | `Brands/_index.md` + `Brands/{品牌名}.md` | ≥10 独立文件 | `references/modules-core.md` |
| 3 | Pain-Points | `Pain-Points/_index.md` | ≥15 条目 | `references/modules-core.md` |
| 8 | Competitors | `Competitors/{品牌名}-analysis.md` + `_summary.md` | ≥5 分析 + 1 汇总 | `references/modules-core.md` |
| 13 | Opportunities | `Opportunities/_index.md` | ≥8 条目 | `references/modules-core.md` |

### 辅助（配额够才做，L2 即可，否则标注"本次未生成"）

| # | 模块 | 输出路径 | 最低数量 | 字段定义 |
|---|------|---------|---------|---------|
| 2 | Products | `Products/_index.md` + `{产品类型}.md` | ≥5 文件 | `references/modules-aux.md` |
| 4 | Keywords | `Keywords/_index.md` | ≥40 (5类×8) | `references/modules-aux.md` |
| 5 | Supply-Chain | `Supply-Chain/_index.md` | ≥5 企业 | `references/modules-aux.md` |
| 6 | Business-Models | `Business-Models/_index.md` | ≥3 模式 | `references/modules-aux.md` |
| 7 | Regulations | `Regulations/_index.md` | ≥4 认证 | `references/modules-aux.md` |
| 9 | Content-Ecosystem | 5平台文件 + `_content-types.md` + `_patterns.md` | ≥7 文件 | `references/modules-aux.md` |
| 10 | Communities | `Communities/_index.md` | ≥8 社区 | `references/modules-aux.md` |
| 11 | Influencers | `Influencers/_index.md` | ≥15 影响者 | `references/modules-aux.md` |
| 12 | Trends | `Trends/_index.md` | ≥5 趋势 | `references/modules-aux.md` |
| 14 | Knowledge-Map | `_level1/2/3.md` + `_connections.md` + `_opportunity-map.md` + `{节点}/` | ≥60% 覆盖 | `references/modules-aux.md` |
| 15 | Sources | `Sources/_index.md` | ≥10 信息源 | `references/modules-aux.md` |

---

## Phase A: 模块执行

1. 开始前 Read `references/search-strategy.md`：判断行业类型 → 加载垂直源优先级 → 掌握 L1/L2/L3 三级框架。
2. **A-core**：Read `references/modules-core.md`，按模块 1→3→8→13 顺序深度执行，每字段 L1 搜索。
3. **A-aux**：Read `references/modules-aux.md`，按 2→4→5→6→7→9→10→11→12→14→15 顺序执行。搜索配额耗尽时，剩余模块标注"本次未生成"并跳过，不推断填充。

---

## Phase B: 审计与补全（不可跳过）

运行审计脚本（位于本 skill 目录下的 `scripts/audit.sh`）：

```
bash {Base directory}/scripts/audit.sh "{行业名}-Industry"
```

自动检查 **B1**（空目录）/ **B2**（数量下界）/ **B3**（README 一致性）/ **B4**（推断比例 ≤20%）。
- 任一未通过 → 补全缺失内容 → 重跑（最多 2 轮）。
- 第 2 轮仍不通过 → README 末尾追加"已知缺失"区块，列出未达标项及原因。
- 全部通过 → 进入 Phase C。
- 若脚本路径无法解析，按 `references/audit-checklist.md` 内联命令手动执行 B1-B4。

---

## Phase C: 研究报告生成（不可跳过）

Read `references/report-structure.md`，生成 `{行业名}-Industry-Report.md` 到输出目录根，含 Part 1-4：行业全景 / 核心发现 / 机会优先级排序（含 90 天计划）/ 数据置信度声明。

---

## 收尾：生成 README.md

在输出目录根生成 `README.md`，包含：
1. 行业名、市场、生成日期
2. **数据置信度**区块（模板见 `assets/readme-data-confidence.md`）
3. 完整目录树（仅列实际存在的目录和文件）
4. 各子库简要说明和实际文件数量
5. 使用建议（如何用 Obsidian 打开、如何持续更新）
6. 交付声明（审计通过后填入，含推断比例）

---

## 附录：从数据库升级为情报系统

静态快照会过期，以下建议将其升级为动态情报系统：

- **每周竞品周报**：`/loop 7d` — 检查竞品新品、Collection、Landing Page、Blog、关键词变动
- **每日内容趋势**：`/loop 1d` — 追踪各平台高互动内容
- **每月行业地图更新**：`/loop 30d` — 检查新赛道、新公司、新产品类型

CronCreate 示例：
```
CronCreate: cron "0 9 * * 1", prompt "检查 {行业名} 行业竞品最近一周的变动，生成周报", recurring: true, durable: true
```

对行业核心 Blog 和 News 站点接入 RSS；可定期 WebFetch 检查目标站点更新。在 `Sources/` 持续更新信息源清单。
