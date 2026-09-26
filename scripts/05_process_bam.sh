#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DATA_ROOT="${DATA_ROOT:-$(cd "$ROOT/.." && pwd)}"
THREADS="${THREADS:-4}"
mkdir -p "$DATA_ROOT/aligned" "$ROOT/results"

for sample in father mother proband; do
  input="$DATA_ROOT/aligned/${sample}.aligned.bam"
  name_sorted="$DATA_ROOT/aligned/${sample}.namesort.bam"
  fixmate="$DATA_ROOT/aligned/${sample}.fixmate.bam"
  coordinate_sorted="$DATA_ROOT/aligned/${sample}.positionsort.bam"
  output="$DATA_ROOT/aligned/${sample}.dedup.bam"

  samtools sort -n -@ "$THREADS" -o "$name_sorted" "$input"
  samtools fixmate -m "$name_sorted" "$fixmate"
  samtools sort -@ "$THREADS" -o "$coordinate_sorted" "$fixmate"
  samtools markdup -@ "$THREADS" "$coordinate_sorted" "$output"
  samtools index -@ "$THREADS" "$output"
  rm "$name_sorted" "$fixmate" "$coordinate_sorted"
done

samtools flagstat -@ "$THREADS" "$DATA_ROOT/aligned/proband.dedup.bam" > "$ROOT/results/flagstat_proband.txt"