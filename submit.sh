#!/bin/bash
#SBATCH --output %J.out
#SBATCH --error %J.err
#SBATCH --time=24:50:00

# Source and activate conda
. /home/ec2-user/.conda/etc/profile.d/conda.sh
conda activate samtools

#time
#bash facets-analysis/snp_pileup.sh \
#	/efs/refdata/hg38.fa \
#        /efs/data/SBJ00605_PRJ200472_L2000846-ready.bam \
#        /efs/data/SBJ00605_PRJ200504_L2000847-ready.bam \
#        /efs/out \
#	/efs/refdata/All_20170710.vcf.gz


time Rscript facets-analysis/Facets_R_part.R /efs/out/ 500
