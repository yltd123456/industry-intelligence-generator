# Industry Intelligence Generator

A KSCC-based system that generates structured industry intelligence databases from any market.

## What this is

Industry Intelligence Generator is a KSCC Skill that takes an industry name as input and generates a complete structured intelligence system ("Industry OS") for that industry.

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

Output is a fully structured Markdown-based industry database.

## Core Principle

Skill reproducibility > demo completeness > documentation aesthetics

This system is designed to be:

- Reproducible
- Deterministic in structure
- Scalable across industries

## Repository Structure

```
industry-intelligence-generator/
│
├── skill/                    # Core engine
│   └── SKILL.md              # Industry Intelligence Skill (V2-MVP)
│
├── demo/                     # Generated outputs
│   ├── README.md
│   └── 体脂秤-Industry/       # Example generated Industry OS
│
├── audit-report.md           # Quality audit of demo output
│
└── README.md
```

## Quick Start

### 1. Install Skill

```bash
cp -r skill/SKILL.md ~/.claude/skills/industry-intelligence-generator/SKILL.md
```

### 2. Run generation

```
/industry-intelligence 体脂秤 中国
/industry-intelligence 新能源汽车 全球
/industry-intelligence GLP-1药物 美国
```

### 3. Output

Generated folder: `{industry}-Industry/`

Open with: Obsidian (Graph View recommended)

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

1. Parse industry input
2. Execute 15-module generation
3. Run Phase B audit
4. Auto-fix missing content
5. Re-audit (max 2 cycles)
6. Deliver final Industry OS

### Degradation Strategy

- Search fail -> retry with synonyms (max 2)
- Fetch fail -> fallback to homepage
- Total failure -> inferred content + [assumption: needs validation]

## Demo

This repository includes a full example:

`demo/体脂秤-Industry/`

Generated using the same Skill engine.

Includes:

- 67 structured Markdown files
- 15 modules fully populated
- 19 brands, 6 competitors, 20 pain points
- Knowledge graph with 8 core nodes
- Audit report: PASS

## Future Roadmap

- Dynamic industry intelligence system
- Scheduled updates (Cron-based)
- Multi-industry comparison
- API exposure for automation tools

## License / Usage

This project is a reusable intelligence generation system.
You may extend or fork it for other industries.
