# Industry Intelligence Generator

A KSCC-based system that generates structured industry intelligence databases from any market.

## What this is

Industry Intelligence Generator is a KSCC Skill that takes an industry name as input and generates a complete structured industry intelligence database for that industry.

It builds a multi-dimensional knowledge system including:

- Brands & competitors
- Products & categories
- User pain points
- Keywords & demand signals
- Supply chain structure
- Business models
- Regulations & compliance
- Content ecosystems
- Communities & influencers
- Market trends
- Opportunity maps
- Knowledge graphs

Output is a fully structured Markdown-based industry database, ready to browse in Obsidian.

## Core Principle

Skill reproducibility > demo completeness > documentation aesthetics

This system is designed to be:

- Reproducible — same input produces same structure
- Deterministic in structure — 15 fixed modules, minimum counts enforced
- Scalable across industries — works for any market or region

## Repository Structure

```
industry-intelligence-generator/
│
├── skill/                    # Core engine
│   └── SKILL.md              # Skill definition (V2-MVP)
│
├── demo/                     # Generated outputs
│   ├── README.md
│   └── 体脂秤-Industry/       # Example generated output
│
├── audit-report.md           # Quality audit of demo output
│
└── README.md
```

## Quick Start

### 1. Install Skill

```bash
cp -r skill/SKILL.md ~/.claude/skills/industry-research/SKILL.md
```

### 2. Run generation

In KSCC, invoke the skill by its name:

```
/industry-research 体脂秤 中国
/industry-research 新能源汽车 全球
/industry-research GLP-1药物 美国
```

The skill name is `industry-research`. The optional second argument specifies the market/region (defaults to global).

### 3. Output

The skill generates a `{industry}-Industry/` folder in your current working directory containing 15 sub-modules of structured Markdown files. Open the folder in Obsidian and use Graph View to explore knowledge graph connections.

## V2-MVP Design

### Problems solved from V1

| V1 Problem | V2 Solution |
|------------|-------------|
| Empty directories | Mandatory module checklist |
| Low brand coverage | >=15 minimum threshold |
| Weak competitor set | >=5 enforced minimum |
| Undefined structure | 15-module fixed schema |
| No audit system | Phase B validation loop |
| Tool failure skips | Graceful degradation + fallback |

### Execution Flow

1. Parse industry name + market/region
2. Execute 15-module generation (WebSearch + WebFetch)
3. Run Phase B audit (empty dirs, count checks, README consistency)
4. Auto-fix missing content if audit fails
5. Re-audit (max 2 cycles)
6. Deliver final output with audit report

### Degradation Strategy

When search or fetch tools fail, the skill degrades gracefully instead of skipping:

- Search fail -> retry with synonyms (max 2)
- Fetch fail -> fallback to site homepage
- Total failure -> inferred content marked `[assumption: needs validation]`

## Demo

This repository includes a full example:

`demo/体脂秤-Industry/` — 67 structured Markdown files covering the body fat scale industry.

- 19 brands, 6 competitor analyses, 20 user pain points
- 7 market trends, 18 business opportunities
- Knowledge graph with 8 core nodes
- Audit result: **PASS** — see `audit-report.md` for details

## Future Roadmap

- Dynamic industry intelligence system (from static snapshot to living database)
- Scheduled updates via CronCreate
- Multi-industry comparison
- API exposure for automation tools

## License / Usage

This project is a reusable intelligence generation system.
You may extend or fork it for other industries.
