#!/bin/sh
set -eu
cd /root/ayoo-hijaukan-dunia

quotes_file="/root/ayoo-hijaukan-dunia/quotes.txt"
quote=$(awk 'NF{print}' "$quotes_file" | awk 'BEGIN{srand()} {a[NR]=$0} END{if(NR) print a[int(rand()*NR)+1]}' )
now=$(date -u +'%Y-%m-%d %H:%M:%S UTC')

case "$quote" in
  *Allah*|*bismillah*|*syukur*|*doa*|*Nabi*|*ikhtiar*|*tawakal*|*istiqamah*|*sabar*)
    title="# Quote Islami ✨"
    ;;
  *)
    title="# Quote Motivasi 🌱"
    ;;
esac

old_entries=$(awk 'BEGIN{count=0} /^## /{count++} count>0 && count<100 {print}' README.md 2>/dev/null || true)

{
  printf '%s\n\n' "$title"
  printf '## %s\n' "$now"
  printf '> %s\n\n' "$quote"
  if [ -n "$old_entries" ]; then
    printf '%s\n' "$old_entries"
  fi
} > README.md

git add README.md
git commit -m "chore: hourly README update $(date -u +'%Y-%m-%d %H:%M UTC')"
git push origin main
