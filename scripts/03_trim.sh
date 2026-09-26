#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DATA_ROOT="${DATA_ROOT:-$(cd "$ROOT/.." && pwd)}"
THREADS="${THREADS:-4}"
mkdir -p "$DATA_ROOT/trimmed" "$ROOT/results"
mkdir -p "$DATA_ROOT/qc_reports/trimmed"
: > "$ROOT/results/bbduk_summary.txt"

for sample in father mother proband; do
  bbduk.sh -Xmx2g \
    in1="$DATA_ROOT/raw_data/${sample}_R1.fq" \
    in2="$DATA_ROOT/raw_data/${sample}_R2.fq" \
    out1="$DATA_ROOT/trimmed/${sample}_R1_trimmed.fq" \
    out2="$DATA_ROOT/trimmed/${sample}_R2_trimmed.fq" \
    qtrim=r trimq=20 minlen=50 threads="$THREADS" \
    2>&1 | tee -a "$ROOT/results/bbduk_summary.txt"
  fastqc --threads "$THREADS" --outdir "$DATA_ROOT/qc_reports/trimmed" \
    "$DATA_ROOT/trimmed/${sample}_R1_trimmed.fq" "$DATA_ROOT/trimmed/${sample}_R2_trimmed.fq"
done