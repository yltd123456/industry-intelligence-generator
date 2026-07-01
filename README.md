# Industry Intelligence Generator

A [Claude Code](https://docs.anthropic.com/en/docs/claude-code) skill that generates structured industry research reports from any market. Input an industry name, get a 15-module Markdown knowledge database plus a decision-ready research report — all based on real, verifiable data.

## What you get

You give it an industry name (and optionally a market/region):

```
/industry-research 体脂秤 (Body Fat Scale) 中国 (China)
```

It generates a `{industry}-Industry/` folder containing:

**A structured data layer** — 15 modules of Markdown files covering:

| Module | Priority | What it covers |
|--------|----------|---------------|
| Brands | Core | Top companies, products, pricing, channels |
| Competitors | Core | Deep website teardowns (nav, collections, SEO, social) |
| Pain-Points | Core | User complaints with source quotes (Reddit, Zhihu, forums) |
| Opportunities | Core | Ranked plays with feasibility, market size, confidence |
| Products | Aux | Product categories, market size, trends |
| Keywords | Aux | Search terms by intent (commercial, informational, buying) |
| Supply-Chain | Aux | OEM/ODM factories, component suppliers |
| Business-Models | Aux | How companies make money (hardware, subscription, etc.) |
| Regulations | Aux | FDA, CE, FCC, NMPA — what it takes to enter |
| Content-Ecosystem | Aux | Top accounts per platform, content patterns |
| Communities | Aux | Active forums, subreddits, Discords |
| Influencers | Aux | KOLs with follower counts and rate estimates |
| Trends | Aux | Market shifts with timelines and opportunity windows |
| Knowledge-Map | Aux | 3-level taxonomy, value chain, opportunity map |
| Sources | Required | All referenced links, data provenance, confidence ratings |

**A research report** — `{industry}-Industry-Report.md` with:
- Industry overview with sourced market data
- Top 3 pain points with user quotes and commercial implications
- Top 3 unmet gaps from competitor analysis
- Top 3 opportunities ranked by feasibility, market size, and data confidence
- 90-day action plans with validation metrics
- Full data confidence declaration

## How it works

This is a [Claude Code](https://docs.anthropic.com/en/docs/claude-code) skill — a reusable prompt template that extends Claude Code with domain-specific workflows. You install it into your Claude Code skills directory and invoke it with `/industry-research`.

**V3 key principles:**
- **Real > Complete** — fewer brands but all data verified, not more brands with half invented
- **Deep > Broad** — core modules get authority-source searches per field; auxiliary modules skip if budget runs out
- **Search strategy is research-grade** — each data type has designated authority sources and search patterns
- **Inference is not data** — when data isn't findable, fields are left blank and marked `[public data unavailable]`, not fabricated
- **Scan → Report** — the output is a decision-ready research report, not just a data dump

> **Why is the skill called `/industry-research` when the repo is called `industry-intelligence-generator`?**
> The repo name describes the project. The skill name is what you type to use it. Same system — different naming contexts.

## V2 → V3 changes

| V2 Problem | V3 Solution |
|------------|-------------|
| 64% of files contained inferred data | Inference capped at 20%; fields left blank when data unavailable |
| Search strategy was "amateur Googling" | L1 (authority sources) → L2 (broad keywords) → L3 (vertical sources) three-tier search |
| All 15 modules treated equally | Core (4 modules) vs Auxiliary (11 modules); aux modules can skip if budget runs out |
| Output stopped at data dump | New Phase C generates a decision-ready research report |
| No way to know what's real vs. guessed | Every file separates confirmed vs. inferred data; README declares inference ratio |
| User quotes were synthetic | Pain points require source quotes with platform/URL |

## Repository Structure

```
industry-intelligence-generator/
│
├── .claude-plugin/           # Plugin metadata (installable via npx/CLI)
│   ├── plugin.json           # Runtime manifest
│   └── marketplace.json      # Discovery metadata (keywords, homepage)
│
├── skill/                    # Core engine (progressive disclosure, V3.1)
│   ├── SKILL.md              # Skill router (~167 lines) — flow + module index only
│   ├── llms.txt              # Machine-readable skill index
│   ├── references/           # On-demand detail (search strategy, module field specs, audit checklist, report structure)
│   ├── scripts/              # audit.sh — automated Phase B audit (B1–B4)
│   └── assets/               # Reusable templates (source footer, inference warning, README confidence)
│
├── assets/                   # Images for README (banner, screenshots)
│
├── demo/                     # Generated example (V2 output)
│   ├── README.md             # Demo index
│   └── 体脂秤-Industry/ (Body Fat Scale)  # V2 generated output
│
├── audit-report.md           # Quality audit of demo output
├── CHANGELOG.md              # Version history
│
└── README.md
```

## Quick Start

### 1. Install Skill

```bash
# Copy the ENTIRE skill package (SKILL.md + references/ + scripts/ + assets/).
# Copying only SKILL.md will break progressive disclosure — the references/ files are loaded on demand.
cp -r skill/* ~/.claude/skills/industry-research/
```

### 2. Run

```
/industry-research 体脂秤 (Body Fat Scale) 中国 (China)
/industry-research 新能源汽车 (New Energy Vehicle) 全球 (Global)
/industry-research GLP-1药物 (GLP-1 Drugs) 美国 (US)
```

Optional second argument is market/region. Defaults to global.

### 3. Browse output

Open `{industry}-Industry/` in [Obsidian](https://obsidian.md). Use Graph View to explore the knowledge map.

Read `{industry}-Industry-Report.md` for the decision-ready research summary.

## Demo

This repo includes a V2 generated example (体脂秤-Industry/, Body Fat Scale):

```
体脂秤-Industry/ (Body Fat Scale)
├── Brands/          19 brand files + index
├── Products/        6 product types + index
├── Pain-Points/     20 pain points
├── Keywords/        60+ keywords by intent
├── Competitors/     6 deep teardowns + summary
├── Content-Ecosystem/  5 platform files + patterns
├── Knowledge-Map/   3-level taxonomy + 8 card directories
├── Trends/          7 industry trends
├── Opportunities/   18 opportunity entries
└── ...              (Supply-Chain, Business-Models, Regulations, Communities, Influencers, Sources)
```

67 files total. Audit result: **PASS** — see [`audit-report.md`](audit-report.md).

Note: This demo was generated with V2. V3 output will have higher data confidence and include a research report.

## Design

This skill is built for:

- **Data integrity** — inference capped at 20%; confirmed and inferred data are always separated
- **Reproducibility** — same input, same output structure; core modules always complete
- **Research-grade search** — authority sources first, broad keywords second, vertical sources third
- **Decision readiness** — every run produces a research report with ranked opportunities and 90-day plans
- **Graceful failure** — if a search fails, the skill retries with synonyms, falls back to homepages, or leaves fields blank (never fabricates)

For implementation details (module specs, field requirements, audit logic, search patterns), see [`skill/SKILL.md`](skill/SKILL.md).

## Future Roadmap

- Dynamic intelligence system (from static snapshot to living database)
- Scheduled updates via CronCreate
- Multi-industry comparison
- API exposure for automation tools

## License / Usage

Licensed under the [MIT License](LICENSE). You may extend or fork it for other industries.
