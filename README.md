# Industry OS Generator

> 一个可以生成"行业认知操作系统"的方法论引擎

## 这是什么

Industry OS Generator 是一个 KSCC Skill，输入一个行业名，输出一个完整的行业认知体系（Industry OS）——包含品牌、产品、痛点、竞品、内容生态、知识地图、机会地图等15个模块的结构化 Markdown 数据库。

**Skill 可复用性 > Demo 完整性 > 文档美观性**

## 仓库结构

```
industry-os-generator/
│
├── skill/                    # 核心能力层（系统本体）
│   └── SKILL.md              # Industry Research Skill V2-MVP
│
├── demo/                     # 案例层（系统运行结果）
│   ├── README.md             # 案例索引
│   └── 体脂秤-Industry/      # 体脂秤行业完整 Industry OS
│
├── audit-report.md           # 体脂秤案例的结构性质量审计报告
│
└── README.md                 # 本文件
```

## 快速开始

### 1. 安装 Skill

将 `skill/` 目录复制到 `~/.claude/skills/industry-research/`：

```bash
cp -r skill/SKILL.md ~/.claude/skills/industry-research/SKILL.md
```

### 2. 执行研究

在 KSCC 中调用：

```
/industry-research 体脂秤 中国
/industry-research 新能源汽车 全球
/industry-research GLP-1药物 美国
```

输出将生成在当前工作目录下的 `{行业名}-Industry/` 文件夹。

### 3. 查看结果

用 Obsidian 打开生成的文件夹，Graph View 查看知识地图连接。

## V2-MVP 核心设计

### 解决的 V1 问题

| V1 问题 | V2 解决方案 |
|---------|-----------|
| 7个空目录 | 禁止预创建空目录，15个模块全部有生成指令 |
| 品牌4个（目标20+） | 明确下界 ≥15 |
| 竞品2个（目标5-10） | 明确下界 ≥5 |
| Content-Channels 和 Content-Ecosystem 重复 | 合并为 Content-Ecosystem |
| 商业模式/合规/供应链缺失 | 全部定义为独立模块 |
| 无审计机制 | Phase B：空目录扫描+数量下界+README一致性 |
| 模糊词"Top N" | 全部使用明确数字下界 |
| 搜索失败无降级 | 3级降级策略：换词→换站→推断+标注 |

### 执行流程

```
输入行业名 → 15个模块依次生成 → Phase B审计 → 补全 → 重新审计 → 交付
```

### 降级策略

```
WebSearch失败 → 换同义关键词（≤2轮）
WebFetch 404 → 尝试站首页
仍然失败 → WebSearch获取二手信息
全部失败 → 推断+标注[推断,待验证]
```

## Demo 案例：体脂秤

`demo/体脂秤-Industry/` 是使用本 Skill 生成的完整行业研究。

- **67个文件**，15个模块全部覆盖
- **19个品牌**详细分析，6个竞品官网拆解
- **20条用户痛点**，7条行业趋势，18条商业机会
- **8个知识卡片**目录覆盖核心技术/产品/市场节点

审计结果：**PASS** — 详见 `audit-report.md`

## 扩展方向

- 从静态数据库升级为动态情报系统（见 Skill 附录）
- CronCreate 定期更新任务
- 多行业横向对比
- API 化供程序调用
