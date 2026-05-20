#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

/*
 * bam-filter: filter a BAM file by regions defined in a BED file
 */

params.bam     = null
params.bed     = null
params.outdir  = 'results'

// Print help and exit if required params are missing
if (!params.bam || !params.bed) {
    log.error "Missing required parameters."
    log.info  "Usage: nextflow run main.nf --bam <file.bam> --bed <regions.bed> [--outdir results]"
    exit 1
}

log.info """
=========================================
 bam-filter pipeline
=========================================
 bam     : ${params.bam}
 bed     : ${params.bed}
 outdir  : ${params.outdir}
-----------------------------------------
""".stripIndent()


process FILTER_BAM {

    tag "${bam.baseName}"

    publishDir params.outdir, mode: 'copy'

    container 'quay.io/biocontainers/samtools:1.19--h50ea8bc_0'

    input:
    path bam
    path bed

    output:
    path "${bam.baseName}.filtered.bam"     , emit: bam
    path "${bam.baseName}.filtered.bam.bai" , emit: bai

    script:
    """
    # Index input BAM if no index exists
    if [ ! -f ${bam}.bai ]; then
        samtools index -@ ${task.cpus ?: 1} ${bam}
    fi

    samtools view \\
        -@ ${task.cpus ?: 1} \\
        -b \\
        -L ${bed} \\
        -o ${bam.baseName}.filtered.bam \\
        ${bam}

    samtools index -@ ${task.cpus ?: 1} ${bam.baseName}.filtered.bam
    """
}


workflow {
    bam_ch = Channel.fromPath(params.bam, checkIfExists: true)
    bed_ch = Channel.fromPath(params.bed, checkIfExists: true)

    FILTER_BAM(bam_ch, bed_ch)
}

workflow.onComplete {
    log.info ( workflow.success
        ? "\nDone. Filtered BAM is in: ${params.outdir}\n"
        : "\nPipeline failed. See .nextflow.log for details.\n" )
}
