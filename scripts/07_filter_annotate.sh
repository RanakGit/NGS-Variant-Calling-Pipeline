#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RESULTS="$ROOT/results"
RAW="$RESULTS/proband.raw.vcf.gz"
FILTERED="$RESULTS/proband.filtered.vcf.gz"
REGION="chr8:86376236-86393722"

bcftools filter -i 'QUAL>=20 && INFO/DP>=10' -Oz -o "$FILTERED" "$RAW"
bcftools index -f "$FILTERED"
bcftools view -i 'GT="AA"' -r "$REGION" -Ov \
  -o "$RESULTS/proband_CA2_candidates.vcf" "$FILTERED"

if command -v vep >/dev/null 2>&1; then
  VEP_CACHE_DIR="${VEP_CACHE_DIR:-$HOME/.vep}"
  VEP_CACHE_VERSION="${VEP_CACHE_VERSION:-110}"
  vep --input_file "$RESULTS/proband_CA2_candidates.vcf" \
    --output_file "$RESULTS/vep_results.txt" --force_overwrite \
    --tab --cache --offline --dir_cache "$VEP_CACHE_DIR" \
    --cache_version "$VEP_CACHE_VERSION" --assembly GRCh37 \
    --species homo_sapiens --symbol --canonical --nearest gene \
    --fields "Uploaded_variation,Location,Allele,Consequence,SYMBOL,Feature,BIOTYPE,Existing_variation,IMPACT"
else
  printf '%s\n' 'VEP is not installed; install the environment and configure its GRCh37 cache to generate this table.' \
    > "$RESULTS/vep_results.txt"
fi