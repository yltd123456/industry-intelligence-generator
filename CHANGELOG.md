# Changelog

All notable changes to the Industry Intelligence Generator skill.

## [3.0.0] - 2026-06-17

### Added

- Three-tier search strategy (L1 authority sources → L2 broad keywords → L3 vertical sources) for all 15 modules (Section: 搜索策略框架)
- Industry type detection step: hardware/SaaS/medical/food/finance with vertical source priorities (Section: 行业类型判断)
- Module priority classification: core modules (Brands, Competitors, Pain-Points, Opportunities) vs auxiliary modules (Section: 模块清单)
- Phase C: research report generation with 4 parts — industry overview, key findings, opportunity ranking with 90-day plans, data confidence declaration (Section: Phase C)
- Phase B4: inference ratio check — infers capped at 20% of total files (Section: Phase B)
- Data confidence section in generated README — declares inference ratio and points to report (Section: 收尾)
- Authority source mapping table: 10 data types with designated search patterns and target sources (Section: L1 权威数据源)

### Changed

- Degradation rule #6 replaced by 6a/6b/6c: distinguish "can't find" vs "doesn't exist"; inferred files must separate confirmed vs. inferred data sections; inference ratio capped at 20% with user prompt on overflow (Section: 执行前规则 #6)
- Core module minimum counts adjusted for quality: Brands ≥10 (was ≥15), Pain-Points ≥15 (was ≥20), Opportunities ≥8 (was ≥10) — prioritize data quality over quantity
- Pain-Points now require source quotes with platform/URL (was "用户原话" without source requirement) (Section: 模块3)
- Opportunities now require data source attribution and feasibility rating (Section: 模块13)
- Sources now include confidence rating field (Section: 模块15)
- Auxiliary modules may be skipped with "本次未生成" label when search budget runs out (Section: 执行前规则 #7)

### Fixed

- Inferred data no longer mixed with confirmed data — always separated by section headers (Section: 执行前规则 #6b)
- Fields with no public data are left blank instead of fabricated (Section: 执行前规则 #6a)
- User is alerted when inference exceeds 20% cap instead of silently continuing (Section: 执行前规则 #6c)

## [2.0.0] - 2026-06-16

### Added

- 15-module fixed schema with enforced minimum counts per module (Section: 模块清单)
- Phase B audit loop: empty directory scan, count threshold checks, README consistency (Section: Phase B)
- 3-tier degradation strategy: synonym retry → homepage fallback → inferred content with `[推断,待验证]` tag (Section: 执行前规则 #6)
- Source attribution block required on every generated file (Section: 执行前规则 #5)
- Content-Ecosystem module merging former Content-Channels into unified module (Section: 模块9)
- Supply-Chain module with manufacturer, component supplier, and certification roles (Section: 模块5)
- Business-Models module with revenue structure, margin estimates, and pros/cons (Section: 模块6)
- Regulations module covering FDA, CE, FCC, NMPA, and data privacy (Section: 模块7)
- Knowledge-Map module with 3-level taxonomy, value chain connections, opportunity map, and per-node knowledge cards (Section: 模块14)
- README auto-generation with directory tree and delivery declaration (Section: 收尾)

### Changed

- Brand minimum raised from "Top N" (undefined) to >=15 independent files (Section: 模块1)
- Competitor minimum raised from "5-10" to >=5 analysis files + 1 summary (Section: 模块8)
- All "Top N" and "若干" wording replaced with explicit numeric lower bounds across all modules

### Fixed

- Empty directories no longer created — directories only materialize on first Write (Section: 执行前规则 #3)
- Module cross-contamination prevented — each module writes to its own directory only (Section: 执行前规则 #4)
- Search failure no longer skips a module — degradation strategy ensures every module completes (Section: 执行前规则 #6-7)

## [1.0.0] - 2026-06-14

### Added

- Initial implementation with basic brand, product, pain-point, keyword, competitor, and content-channel modules
- Obsidian-compatible Markdown output structure
