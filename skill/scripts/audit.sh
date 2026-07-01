#!/usr/bin/env bash
# Phase B 审计自动化 (B1-B4) — industry-research skill v3.1
# 用法: bash skill/scripts/audit.sh {行业名}-Industry
# 退出码: 0=全部通过 1=有失败项 2=用法/参数错误
set -u

DIR="${1:-}"
if [ -z "$DIR" ]; then echo "用法: bash $0 {行业名}-Industry"; echo "示例: bash $0 体脂秤-Industry"; exit 2; fi
if [ ! -d "$DIR" ]; then echo "✗ 目录不存在: $DIR"; exit 2; fi

PASS=0; FAIL=0; WARN=0
ok(){ echo "  ✅ $1"; PASS=$((PASS+1)); }
no(){ echo "  ❌ $1"; FAIL=$((FAIL+1)); }
wn(){ echo "  ⚠️  $1"; WARN=$((WARN+1)); }
skip(){ echo "  ⏭️  $1 (本次未生成，跳过)"; }

# 安全数值比较: ge <actual> <min>
ge(){ [ "${1:-0}" -ge "${2:-0}" ] 2>/dev/null; }
# 文件计数 (排除 _index.md)
fcount(){ find "${1:-/dev/null}" -name "*.md" ! -name "_index.md" 2>/dev/null | wc -l | tr -d ' '; }
# 表格条目计数 (首列为数字的行)；无文件返回 0
ecount(){ local n; n=$(grep -cE '^\| *[0-9]+' "${1:-/dev/null}" 2>/dev/null || true); echo "${n:-0}"; }

echo "================ Phase B 审计: $DIR ================"

echo; echo "B1. 空目录扫描"
EMPTY="$(find "$DIR" -type d -empty 2>/dev/null)"
if [ -z "$EMPTY" ]; then ok "无空目录"; else no "发现空目录:"; printf '%s\n' "$EMPTY" | sed 's/^/      /'; fi

echo; echo "B2. 数量达标检查"
echo "  [核心]"
B=$(fcount "$DIR/Brands");        ge "$B" 10 && ok "Brands: $B (≥10)"      || no "Brands: $B (需≥10)"
C=$(fcount "$DIR/Competitors");   ge "$C" 5  && ok "Competitors: $C (≥5)" || no "Competitors: $C (需≥5)"
PP=$(ecount "$DIR/Pain-Points/_index.md");     ge "$PP" 15 && ok "Pain-Points: ~$PP (≥15)"  || no "Pain-Points: ~$PP (需≥15，近似计数)"
OP=$(ecount "$DIR/Opportunities/_index.md");   ge "$OP" 8  && ok "Opportunities: ~$OP (≥8)"  || no "Opportunities: ~$OP (需≥8，近似计数)"

echo "  [辅助]"
chk(){ # chk <label> <path> <min> <mode>  mode: f=文件数 e=条目数
  local lbl="$1" p="$2" m="$3" mode="$4" n
  [ -e "$p" ] || { skip "$lbl"; return; }
  if [ "$mode" = f ]; then n=$(fcount "$p"); else n=$(ecount "$p"); fi
  ge "$n" "$m" && ok "$lbl: $n (≥$m)" || no "$lbl: $n (需≥$m)"
}
chk "Products"          "$DIR/Products"                   5  f
chk "Supply-Chain"      "$DIR/Supply-Chain"               5  f
chk "Business-Models"   "$DIR/Business-Models/_index.md"  3  e
chk "Regulations"       "$DIR/Regulations/_index.md"      4  e
chk "Content-Ecosystem" "$DIR/Content-Ecosystem"          7  f
chk "Communities"       "$DIR/Communities/_index.md"      8  e
chk "Influencers"       "$DIR/Influencers/_index.md"      15  e
chk "Trends"            "$DIR/Trends/_index.md"            5  e
chk "Keywords"          "$DIR/Keywords/_index.md"         40  e
chk "Sources"           "$DIR/Sources/_index.md"          10  e

echo; echo "B3. README 一致性"
TOTAL=$(find "$DIR" -type f 2>/dev/null | wc -l | tr -d ' ')
DECL=$(grep -oE '文件数[^0-9]*[0-9]+' "$DIR/README.md" 2>/dev/null | grep -oE '[0-9]+' | head -1)
if [ -z "$DECL" ]; then wn "README 未声明 '文件数: N'（实际 $TOTAL 个）— 请确认 README 总数声明"; else
  [ "$TOTAL" = "$DECL" ] && ok "实际 $TOTAL = 声明 $DECL" || no "实际 $TOTAL ≠ 声明 $DECL"
fi

echo; echo "B4. 推断比例检查"
INFER=$(grep -rl '⚠️' "$DIR" 2>/dev/null | wc -l | tr -d ' ')
CAP=$(( TOTAL * 20 / 100 ))
PCT=$(( TOTAL > 0 ? INFER * 100 / TOTAL : 0 ))
if [ "$INFER" -le "$CAP" ]; then ok "推断 $INFER/$TOTAL = ${PCT}% (≤20%)"; else no "推断 $INFER/$TOTAL = ${PCT}% (超20%) — 需在 README 追加推断超限声明"; fi

echo; echo "================ 汇总 ================"
echo " ✅ $PASS 通过 | ❌ $FAIL 失败 | ⚠️  $WARN 警告"
echo "======================================"
[ "$FAIL" -gt 0 ] && exit 1 || exit 0
