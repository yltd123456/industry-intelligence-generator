# Changelog

All notable changes to the Industry Intelligence Generator skill.

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
