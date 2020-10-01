#!/bin/bash
#SBATCH --output %J.out
#SBATCH --error %J.err
#SBATCH --time=00:50:00

time ./snp_pileup.sh \
        /efs/refdata/hg38.fa \
        /efs/data/PRJ190494_FL-2B-ready.bam \
        /efs/data/PRJ190493_FL-2T-ready.bam \
        /efs/out /efs/data/00-common_all.vcf.gz
