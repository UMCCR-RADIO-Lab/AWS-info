#!/bin/bash -x
# Do not use `-it` on docker run, otherwise:
# https://stackoverflow.com/questions/43099116/error-the-input-device-is-not-a-tty

# Example command
# bash snp_pileup.sh hg19.fa blood.bam tumour.bam ouput_dir snp_reference

. /home/ec2-user/.conda/etc/profile.d/conda.sh
conda activate samtools

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

echo $BCBio_blood_bam
echo $BCBio_tumour_bam

base_blood=$(basename $BCBio_blood_bam)
base_tumour=$(basename $BCBio_tumour_bam)

# Make the outdir if it doesn't exist
mkdir -p $outdir

# BCBio has output files in the wrong order that FACETS wants for some reason.
# Samtools sort with 10 threads to hopefully fix this
samtools sort -@ 16 -T /efs/scratch/$BCBio_tumour_bam_tmp $BCBio_tumour_bam -O BAM -o $outdir/$base_tumour.ordered.bam
samtools sort -@ 16 -T /efs/scratch/$BCBio_blood_bam_tmp $BCBio_blood_bam -O BAM -o $outdir/$base_blood.ordered.bam

# SNP pileup from here: https://github.com/mskcc/facets/tree/master/inst/extcode
snp-pileup -g -q 30 -Q 30 -r 10,10 $SNP_reference $outdir/$base_tumour.vcf $outdir/$base_blood.ordered.bam $outdir/$base_tumour.ordered.bam
