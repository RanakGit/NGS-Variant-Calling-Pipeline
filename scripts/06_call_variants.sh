#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DATA_ROOT="${DATA_ROOT:-$(cd "$ROOT/.." && pwd)}"
THREADS="${THREADS:-4}"
REFERENCE="$DATA_ROOT/reference/hg19_chr8.fa"
mkdir -p "$ROOT/results"

bcftools mpileup --threads "$THREADS" -f "$REFERENCE" -Ou \
  "$DATA_ROOT/aligned/proband.dedup.bam" \
  | bcftools call --threads "$THREADS" -mv -Oz -o "$ROOT/results/proband.raw.vcf.gz"
bcftools index -f "$ROOT/results/proband.raw.vcf.gz"