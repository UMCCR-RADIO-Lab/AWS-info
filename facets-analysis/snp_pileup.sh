#!/bin/bash -x
docker_cmd_prefix="docker run -it -v /efs/scratch:/efs/scratch -v /efs/data:/efs/data -v /efs/refdata:/efs/refdata -v /efs/out:/efs/out --env=TMP_DIR --env=JAVA_OPTS --memory=8G"
snp_pileup="$docker_cmd_prefix quay.io/biocontainers/snp-pileup:0.5.14--hfbaaabd_3 snp-pileup"
samtools="$docker_cmd_prefix quay.io/biocontainers/samtools:1.10--h9402c20_2 samtools"

# Example command
# bash snp_pileup.sh hg19.fa blood.bam tumour.bam ouput_dir snp_reference

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

# BCBio has output files in the wrong order that FACETS wants for some reason. 
# Samtools sort with 10 threads to hopefully fix this
$samtools sort -@ 10 -o $outdir/`basename $BCBio_tumour_bam`.ordered.bam $BCBio_tumour_bam
$samtools sort -@ 10 -o $outdir/`basename $BCBio_blood_bam`.ordered.bam $BCBio_blood_bam

mkdir -p $outdir

# SNP pileup from here: https://github.com/mskcc/facets/tree/master/inst/extcode
$snp_pileup -g -q 30 -Q 30 -r 10,10 $SNP_reference $outdir/`basename $BCBio_tumour_bam.csv.gz` $outdir/`basename $BCBio_blood_bam.ordered.bam` $outdir/`basename $BCBio_tumour_bam.ordered.bam`
