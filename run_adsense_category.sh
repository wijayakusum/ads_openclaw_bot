#!/usr/bin/env bash
set -euo pipefail

# Usage:
# ./run_adsense_category.sh "Ferry Ticket Booking" "detail page"
# ./run_adsense_category.sh "Car Rental" "checkout page"

CATEGORY="${1:-Tour and Experience}"
PAGE_TYPE="${2:-detail page}"
SITE="https://balitatittour.com"

PROMPT="You are a Google AdSense strategist. For site ${SITE}, create an implementation-ready ad plan for category '${CATEGORY}' on '${PAGE_TYPE}'. Return: (1) placements with block names, (2) Auto Ads on/off, (3) conversion-safe suppression zones, (4) policy checklist, (5) 7-day test plan with KPI targets. Output in Markdown with concise tables."

SID="adsense-${CATEGORY// /-}-${PAGE_TYPE// /-}-$(date +%Y%m%d-%H%M%S)"
OUT_DIR="/Users/putuwijaya/balitatittour-google-ads"
OUT_FILE="$OUT_DIR/adsense_${CATEGORY// /_}_${PAGE_TYPE// /_}.md"
RAW_FILE="/tmp/adsense_${CATEGORY// /_}_${PAGE_TYPE// /_}.json"

openclaw agent --agent main --session-id "$SID" --message "$PROMPT" --json > "$RAW_FILE"

node -e "const fs=require('fs');const s=fs.readFileSync(process.argv[1],'utf8');const i=s.indexOf('{');const j=JSON.parse(s.slice(i));const r=j.result||j;const t=((r.payloads||[]).map(p=>p.text||'').join('\n')||r.text||'').trim();fs.writeFileSync(process.argv[2],t+'\n');" "$RAW_FILE" "$OUT_FILE"

echo "Saved: $OUT_FILE"
