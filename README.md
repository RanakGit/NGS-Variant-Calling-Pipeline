# NGS Variant Calling Pipeline

Reproducible short-read variant calling for a father, mother, and proband trio, aligned against hg19 chromosome 8. The project includes download, read QC, trimming, alignment, BAM processing, variant calling, CA2-region filtering, and optional VEP annotation.

## Project contents

- `scripts/`: numbered pipeline steps; run them from any working directory.
- `raw_data/`, `trimmed/`, `aligned/`, `reference/`: pipeline inputs and intermediate files (ignored by Git).
- `qc_reports/`: FastQC reports.
- `results/`: compact outputs suitable for review and version control.
- `environment.yml`: Conda environment with pinned tool versions.

The current workspace already has `raw_data/`, `trimmed/`, `aligned/`, `reference/`, and `qc_reports/` beside this project folder. Scripts use those sibling folders by default and keep compact deliverables inside this project's `results/` directory. Set `DATA_ROOT` to another data directory when using a different layout.

## Setup

Run in Linux, WSL, or another Bash environment. From the project root:

```bash
conda env create -f environment.yml
conda activate ngs-variant-calling
```

The analysis reference is hg19/GRCh37 chromosome 8. `scripts/01_download_data.sh` downloads paired FASTQ files from Zenodo record 3243160 and retrieves the UCSC hg19 chr8 reference if they are not already present. Existing files are not overwritten.

## Run the pipeline

```bash
for script in scripts/0*.sh; do bash "$script"; done
```

Alternatively, run each numbered script in sequence. Steps 01-06 produce family QC, trimmed reads, processed BAMs, and a proband VCF. Step 07 applies QUAL >= 20 and DP >= 10, selects homozygous alternate genotypes in `chr8:86376236-86393722`, and runs VEP when its offline cache is available. Set `VEP_CACHE_DIR` to the cache directory; `VEP_CACHE_VERSION` can override the default cache version.

The scripts use `THREADS` (default: 4) to control parallel work. Raw files and large intermediates are intentionally excluded from Git; the final candidate VCF, summaries, and annotation table are kept under `results/`.

## Notes

The existing `raw_data/` files are uncompressed `.fq` files, so trimming scripts use those paths directly. The download step stores Zenodo `.fq.gz` files and expands them to the same `.fq` filenames. Candidate variants and annotations should be interpreted with clinical and population-frequency review; the pipeline does not establish pathogenicity.