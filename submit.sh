#!/bin/bash
#SBATCH --output %J.out
#SBATCH --error %J.err
#SBATCH --time=00:50:00

time ./snp_pileup.sh \
        /efs/refdata/hg38.fa \
        /efs/data/SEQC-II_Normal-ready.bam \
        /efs/data/SEQC-II_Tumor_50pc-ready.bam \
        /efs/out /efs/refdata/All_20170710.vcf.gz
