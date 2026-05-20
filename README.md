# bam-filter

A small [Nextflow](https://www.nextflow.io/) pipeline that filters a BAM file, keeping only the reads that overlap regions in a BED file. Uses `samtools view -L` under the hood.

## Quick start

```bash
nextflow run main.nf \
    --bam   path/to/sample.bam \
    --bed   path/to/regions.bed \
    --outdir results \
    -profile docker
```

Outputs:

- `results/<sample>.filtered.bam`
- `results/<sample>.filtered.bam.bai`

## Requirements

- Nextflow `>=22.10.0`
- One of: Docker, Singularity, or Conda (or a local `samtools >=1.10` install if you skip profiles)

## Inputs

| Param      | Required | Description                                       |
|------------|----------|---------------------------------------------------|
| `--bam`    | yes      | Input BAM file. Index is created if missing.      |
| `--bed`    | yes      | BED file (chrom, start, end) with regions to keep.|
| `--outdir` | no       | Output directory (default: `results`).            |

## Profiles

- `docker`      — uses the biocontainers samtools image
- `singularity` — same image via Singularity
- `conda`       — installs samtools via bioconda
- `standard`    — runs locally, assumes `samtools` on `PATH`

See [`usage.md`](usage.md) for more detail.

## Repo layout

```
.
├── main.nf               # Pipeline workflow
├── nextflow.config       # Profiles and defaults
├── nextflow_schema.json  # Parameter schema
├── README.md
└── usage.md
```

## License

MIT
