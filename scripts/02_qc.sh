#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DATA_ROOT="${DATA_ROOT:-$(cd "$ROOT/.." && pwd)}"
THREADS="${THREADS:-4}"
mkdir -p "$DATA_ROOT/qc_reports/raw" "$DATA_ROOT/qc_reports/trimmed"

for sample in father mother proband; do
  fastqc --threads "$THREADS" --outdir "$DATA_ROOT/qc_reports/raw" \
    "$DATA_ROOT/raw_data/${sample}_R1.fq" "$DATA_ROOT/raw_data/${sample}_R2.fq"
done

if [[ -d "$DATA_ROOT/trimmed" ]]; then
  for sample in father mother proband; do
    fastqc --threads "$THREADS" --outdir "$DATA_ROOT/qc_reports/trimmed" \
      "$DATA_ROOT/trimmed/${sample}_R1_trimmed.fq" "$DATA_ROOT/trimmed/${sample}_R2_trimmed.fq"
  done
fi