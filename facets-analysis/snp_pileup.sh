#!/bin/bash

# hg38 ref files I saw are here:
#s3://umccr-refdata-dev/genomes_1.7/hg38/hg38.fa

# Bams/snp ref should be in here:
#s3://umccr-temp-dev/Andrew_parallel_cluster_test/

# Example command
# bash snp_pileup.sh hg19.fa blood.bam tumour.bam ouput_dir snp_reference snp_pileup_program

# hg38.fa etc
genome_ref=$1
#PRJ190494_FL-2B.bam
BCBio_blood_bam=$2
# PRJ190493_FL-2T.bam
BCBio_tumour_bam=$3
# Output directory
outdir=$4
# Ref files are from here as suggested in the FACETS docs ftp://ftp.ncbi.nlm.nih.gov/snp/organisms/human_9606_b150_GRCh38p7/VCF/
#00-All.vcf.gz
SNP_reference=$5
# SNP pileup execuatble
snp_pileup=$6

# BCBio has output files in the wrong order that FACETS wants for some reason. Picard reorder to fix this 
picard ReorderSam I=$BCBio_tumour_bam O=$outdir/$BCBio_tumour_bam.ordered.bam R=$genome_ref
picard ReorderSam I=$BCBio_blood_bam O=$outdir/$BCBio_blood_bam.ordered.bam R=$genome_ref

mkdir -p $outdir

# SNP pileup from here: https://github.com/mskcc/facets/tree/master/inst/extcode
$snp_pileup -g -q 30 -Q 30 -r 10,10 $SNP_reference $outdir/$BCBio_tumour_bam.csv.gz $outdir/$BCBio_blood_bam.ordered.bam $outdir/$BCBio_tumour_bam.ordered.bam


