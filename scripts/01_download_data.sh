#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DATA_ROOT="${DATA_ROOT:-$(cd "$ROOT/.." && pwd)}"
mkdir -p "$DATA_ROOT/raw_data" "$DATA_ROOT/reference"

for sample in father mother proband; do
  for read in R1 R2; do
    fq="$DATA_ROOT/raw_data/${sample}_${read}.fq"
    gz="${fq}.gz"
    if [[ ! -s "$fq" ]]; then
      if [[ ! -s "$gz" ]]; then
        wget -c "https://zenodo.org/records/3243160/files/${sample}_${read}.fq.gz" -O "$gz"
      fi
      gzip -dc "$gz" > "$fq"
    fi
  done
done

reference="$DATA_ROOT/reference/hg19_chr8.fa"
if [[ ! -s "$reference" ]]; then
  wget -c "https://hgdownload.soe.ucsc.edu/goldenPath/hg19/chromosomes/chr8.fa.gz" -O "$reference.gz"
  gzip -dc "$reference.gz" > "$reference"
fi

[[ -s "${reference}.fai" ]] || samtools faidx "$reference"
[[ -s "${reference}.bwt" ]] || bwa index "$reference"