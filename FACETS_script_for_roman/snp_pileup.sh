#!/bin/bash

# hg38 ref files I saw are here:
#s3://umccr-refdata-dev/genomes_1.7/hg38/hg38.fa

# Bams/snp ref should be in here:
#s3://umccr-temp-dev/Andrew_parallel_cluster_test/

# BCBio has output files in the wrong order that FACETS wants for some reason. Picard reorder to fix this 
picard ReorderSam I=PRJ190493_FL-2T-ready.bam O=PRJ190493_FL-2T_chr_ordered.bam R=hg38.fa
picard ReorderSam I=PRJ190494_FL-2B-ready.bam O=PRJ190494_FL-2B_chr_ordered.bam R=hg38.fa

outdir=./output
# Ref files are from here as suggested in the FACETS docs ftp://ftp.ncbi.nlm.nih.gov/snp/organisms/human_9606_b150_GRCh38p7/VCF/
SNP_reference=00-All.vcf.gz
mkdir -p $outdir

# Tumour bam
bam_file_t=PRJ190493_FL-2T_chr_ordered.bam
# Normal (blood) bam
bam_file_n=PRJ190494_FL-2B_chr_ordered.bam

# SNP pileup from here: https://github.com/mskcc/facets/tree/master/inst/extcode
snp-pileup -g -q 30 -Q 30 -r 10,10 $SNP_reference $outdir/$tumour.pileup.gz $bam_file_n $bam_file_t


