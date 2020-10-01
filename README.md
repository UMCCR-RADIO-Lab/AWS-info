# Parallelcluster FACETS pipeline

This is a pilot effort to transition traditional, legacy HPC bioinformaticists to AWS Parallelcluster. Work in progress and training staff and researchers along the way via commits on their own code.

GRCh37 example using FSx mountpoints, mapping S3 buckets directly:

```shell
$ time ./snp_pileup.sh \
        /mnt/refdata/genomes_1.7/GRCh37/GRCh37.fa \
        /mnt/data/Andrew_parallel_cluster_test/PRJ190494_FL-2B-ready.bam \
        /mnt/data/Andrew_parallel_cluster_test/PRJ190493_FL-2T-ready.bam \
        /mnt/out \
        /mnt/data/Andrew_parallel_cluster_test/00-common_all.vcf.gz

$ export docker_cmd_prefix="docker run -it -v /scratch:/scratch -v /mnt/data:/mnt/data -v /mnt/refdata:/mnt/refdata -v /mnt/out:/mnt/out --env TMP_DIR"
$ $docker_cmd_prefix quay.io/biocontainers/r-facets:0.5.14--r40he991be0_3 ./Facets_R_part.R
```

Using AWS EFS instead, staging the data needed previously:

```shell
$ time ./snp_pileup.sh \
        /efs/refdata/hg38.fa \
        /efs/data/SEQC-II_Normal-ready.bam \
        /efs/data/SEQC-II_Tumor_50pc-ready.bam \
        /efs/out /efs/refdata/All_20170710.vcf.gz

$ export docker_cmd_prefix="docker run -it -v /efs/scratch:/efs/scratch -v /efs/data:/efs/data -v /efs/refdata:/efs/refdata -v /efs/out:/efs/out --env TMP_DIR"
$ $docker_cmd_prefix quay.io/biocontainers/r-facets:0.5.14--r40he991be0_3 ./Facets_R_part.R
```

# Quickstart

Just submit jobs as if you were on, legacy HPC setup running SLURM while observing your EC2 compute nodes spawning:

```shell
$ sbatch submit.sh
Submitted batch job 2
$ squeue -h
                 2   compute submit.s ec2-user CF       1:56      1 compute-dy-c54xlarge-1
```

At the same time, remember that you are the king of your own cluster so Docker is installed and you can select [Docker images](https://github.com/umccr/infrastructure/blob/master/parallel_cluster/ami/biocontainers.yml#L23)... see how they are used in the scripts.

TODO: Ideally those docker containers could be aliased and volume-mounted to accomodate traditional HPC user transition (see `$docker_cmd` for an example on the scripts)?
