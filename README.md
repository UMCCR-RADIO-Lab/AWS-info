# Parallelcluster FACETS pipeline 

This is a pilot effort to transition traditional, legacy HPC bioinformaticists to AWS Parallelcluster. Work in progress and training staff and researchers along the way via commits on their own code.

```
$ time ./snp_pileup.sh /mnt/refdata/genomes_1.7/GRCh37/GRCh37.fa /mnt/data/Andrew_parallel_cluster_test/PRJ190494_FL-2B-ready.bam /mnt/data/Andrew_parallel_cluster_test/PRJ190493_FL-2T-ready.bam /mnt/out /mnt/data/Andrew_parallel_cluster_test/00-common_all.vcf.gz
$ docker run -it -v quay.io/biocontainers/r-facets:0.5.14--r40he991be0_3 bash -c Facets_R_part.R
```
