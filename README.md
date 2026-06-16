# Industry Intelligence Generator

A [Claude Code](https://docs.anthropic.com/en/docs/claude-code) skill that generates a complete structured industry intelligence database from any market. Input an industry name, get a 15-module Markdown knowledge system ready to browse in Obsidian.

## What you get

You give it an industry name (and optionally a market/region):

```
/industry-research 体脂秤 中国
```

It generates a `{industry}-Industry/` folder in your working directory — a structured Markdown database covering:

| Module | What it covers |
|--------|---------------|
| Brands | Top companies, products, pricing, channels |
| Products | Product categories, market size, trends |
| Pain-Points | User complaints, unmet needs (Reddit, Zhihu, forums) |
| Keywords | Search terms by intent (commercial, informational, buying) |
| Supply-Chain | OEM/ODM factories, component suppliers |
| Business-Models | How companies make money (hardware, subscription, etc.) |
| Regulations | FDA, CE, FCC, NMPA — what it takes to enter |
| Competitors | Deep website teardowns (nav, collections, SEO, social) |
| Content-Ecosystem | Top accounts per platform, content patterns |
| Communities | Active forums, subreddits, Discords |
| Influencers | KOLs with follower counts and rate estimates |
| Trends | Market shifts with timelines and opportunity windows |
| Opportunities | Startup, content, and investment plays |
| Knowledge-Map | 3-level taxonomy, value chain, opportunity map |
| Sources | All referenced links and data provenance |

Each module has enforced minimum counts (e.g. >=15 brands, >=20 pain points, >=5 competitor teardowns) and is validated by an automated audit pass.

## How it works

This is a [Claude Code](https://docs.anthropic.com/en/docs/claude-code) skill — a reusable prompt template that extends Claude Code with domain-specific workflows. You install it into your Claude Code skills directory and invoke it with `/industry-research`.

> **Why is the skill called `/industry-research` when the repo is called `industry-intelligence-generator`?**
> The repo name describes the project. The skill name is what you type to use it. Same system — different naming contexts.

## Repository Structure

```
industry-intelligence-generator/
│
├── skill/                    # Core engine
│   └── SKILL.md              # Skill definition (V2-MVP)
│
├── demo/                     # Generated example
│   ├── README.md             # Demo index
│   └── 体脂秤-Industry/       # Full output for body fat scale industry
│
├── audit-report.md           # Quality audit of demo output
│
└── README.md
```

## Quick Start

### 1. Install Skill

```bash
cp skill/SKILL.md ~/.claude/skills/industry-research/SKILL.md
```

### 2. Run

```
/industry-research 体脂秤 中国
/industry-research 新能源汽车 全球
/industry-research GLP-1药物 美国
```

Optional second argument is market/region. Defaults to global.

### 3. Browse output

Open `{industry}-Industry/` in [Obsidian](https://obsidian.md). Use Graph View to explore the knowledge map.

## Demo

This repo includes a complete generated example — the body fat scale (体脂秤) industry:

```
体脂秤-Industry/
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

## Design

This skill is built for:

- **Reproducibility** — same input, same output structure
- **Completeness** — every module is generated; no empty directories
- **Graceful failure** — if a search or fetch fails, the skill retries with synonyms, falls back to site homepages, or infers content (always marked with `[assumption: needs validation]`)

For implementation details (module specs, field requirements, audit logic), see [`skill/SKILL.md`](skill/SKILL.md).

## Future Roadmap

- Dynamic intelligence system (from static snapshot to living database)
- Scheduled updates via CronCreate
- Multi-industry comparison
- API exposure for automation tools

## License / Usage

This project is a reusable intelligence generation system.
You may extend or fork it for other industries.
