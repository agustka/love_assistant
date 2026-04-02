#!/usr/bin/env bash
# Prints a quick summary of total lines added/deleted, generated file count,
# and the top-20 high-churn hotspot files (scored by add+del >= 120).
set -euo pipefail

if [[ -z "${1:-}" ]]; then
  echo "Usage: print_diff_hotspots.sh <output_dir>" >&2
  exit 1
fi

output_dir="$1"
summary_file="$output_dir/per_file_summary.tsv"
generated_file="$output_dir/generated_skipped.txt"

if [[ ! -f "$summary_file" ]]; then
  echo "Missing summary file: $summary_file" >&2
  exit 1
fi

awk -F '\t' 'NF>=3 {c+=1; a+=$2; d+=$3} END {printf "count=%d\nadd=%d\ndel=%d\n", c,a,d}' "$summary_file"

if [[ -f "$generated_file" ]]; then
  wc -l "$generated_file"
else
  echo "0 $generated_file"
fi

awk -F '\t' 'NF>=3 {score=$2+$3; if(score>=120) print score"\t"$1}' "$summary_file" | sort -nr | head -n 20
