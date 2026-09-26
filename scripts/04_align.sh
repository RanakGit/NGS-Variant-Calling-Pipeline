#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DATA_ROOT="${DATA_ROOT:-$(cd "$ROOT/.." && pwd)}"
THREADS="${THREADS:-4}"
REFERENCE="$DATA_ROOT/reference/hg19_chr8.fa"
mkdir -p "$DATA_ROOT/aligned"

for sample in father mother proband; do
  bwa mem -t "$THREADS" \
    -R "@RG\\tID:${sample}\\tSM:${sample}\\tPL:ILLUMINA" \
    "$REFERENCE" \
    "$DATA_ROOT/trimmed/${sample}_R1_trimmed.fq" \
    "$DATA_ROOT/trimmed/${sample}_R2_trimmed.fq" \
    | samtools view -@ "$THREADS" -b -o "$DATA_ROOT/aligned/${sample}.aligned.bam" -
done