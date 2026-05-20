# Usage

## Overview

`bam-filter` takes one BAM file and one BED file and produces a filtered, indexed BAM containing only reads that overlap the BED intervals. Internally it runs:

```bash
samtools view -b -L regions.bed input.bam > input.filtered.bam
samtools index input.filtered.bam
```

## Running the pipeline

### Minimal command

```bash
nextflow run main.nf \
    --bam   sample.bam \
    --bed   regions.bed
```

Results land in `./results/` by default.

### With Docker

```bash
nextflow run main.nf \
    --bam   sample.bam \
    --bed   regions.bed \
    --outdir out \
    -profile docker
```

### With Singularity (HPC)

```bash
nextflow run main.nf \
    --bam   sample.bam \
    --bed   regions.bed \
    -profile singularity
```

### With Conda

```bash
nextflow run main.nf \
    --bam   sample.bam \
    --bed   regions.bed \
    -profile conda
```

### From a remote git repo

Once pushed to GitHub you can run it directly:

```bash
nextflow run your-org/bam-filter \
    --bam sample.bam \
    --bed regions.bed \
    -profile docker
```

## Parameters

### `--bam` (required)

Path to the input BAM file. Can be absolute or relative. If a `.bai` index is not found next to it, one will be generated inside the work directory before filtering.

### `--bed` (required)

Path to a BED file with the regions to keep. Standard 3-column BED is enough (`chrom`, `start`, `end`); extra columns are ignored. Coordinates must match the reference used to align the BAM.

Example BED:

```
chr1	100000	200000
chr1	500000	600000
chr2	1000000	1100000
```

### `--outdir`

Directory where final files are published. Default: `results`.

## Outputs

| File                                | Description                          |
|-------------------------------------|--------------------------------------|
| `<sample>.filtered.bam`             | BAM with reads overlapping the BED   |
| `<sample>.filtered.bam.bai`         | Index for the filtered BAM           |

`<sample>` is the basename of the input BAM (e.g. `sample.bam` → `sample.filtered.bam`).

## Resources

By default each process requests 2 CPUs and 2 GB RAM. Override via `-c custom.config`:

```groovy
process {
    withName: FILTER_BAM {
        cpus   = 8
        memory = '8 GB'
    }
}
```

```bash
nextflow run main.nf --bam x.bam --bed y.bed -c custom.config
```

## Resuming

Re-run with `-resume` to use cached results:

```bash
nextflow run main.nf --bam x.bam --bed y.bed -resume
```

## Troubleshooting

- **`samtools: command not found`** — use a profile (`-profile docker|singularity|conda`) or install samtools locally.
- **Empty output BAM** — check that chromosome names in the BED match those in the BAM (`chr1` vs `1` is the usual culprit).
- **`Missing required parameters`** — both `--bam` and `--bed` must be provided.
