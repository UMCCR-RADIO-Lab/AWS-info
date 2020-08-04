#!/bin/bash -x
docker_cmd_prefix="docker run -it -v /scratch:/scratch -v /mnt/data:/mnt/data -v /mnt/refdata:/mnt/refdata -v /mnt/out:/mnt/out --env=TMP_DIR --env=JAVA_OPTS --memory=8G"
picard="$docker_cmd_prefix quay.io/biocontainers/picard:2.23.3--0 picard $PICARD_JAVA_OPTIONS"
snp_pileup="$docker_cmd_prefix quay.io/biocontainers/snp-pileup:0.5.14--hfbaaabd_3 snp-pileup"

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

# BCBio has output files in the wrong order that FACETS wants for some reason. Picard reorder to fix this
$picard ReorderSam -I $BCBio_tumour_bam -O $outdir/`basename $BCBio_tumour_bam`.ordered.bam -R $genome_ref -SD /mnt/refdata/genomes_1.7/GRCh37/GRCh37.dict
$picard ReorderSam -I $BCBio_blood_bam -O $outdir/`basename $BCBio_blood_bam`.ordered.bam -R $genome_ref -SD /mnt/refdata/genomes_1.7/GRCh37/GRCh37.dict

mkdir -p $outdir

# SNP pileup from here: https://github.com/mskcc/facets/tree/master/inst/extcode
$snp_pileup -g -q 30 -Q 30 -r 10,10 $SNP_reference $outdir/`basename $BCBio_tumour_bam.csv.gz` $outdir/`basename $BCBio_blood_bam.ordered.bam` $outdir/`basename $BCBio_tumour_bam.ordered.bam`
