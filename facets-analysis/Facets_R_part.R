#!/usr/bin/env Rscript
install.packages("tidyverse", repos = "http://cran.us.r-project.org")

library(tidyverse)
library(facets)

# Test run of facets from the vignette for Roman
# https://github.com/mskcc/facets/blob/master/vignettes/FACETS.pdf

# Set seed because sample preprocessing uses random SNP sampling
set.seed(1234)

# This is the output from the C snp pileup
#datafile <- list.files(path = "snp_pileup_output_folder", pattern = "*.csv.gz",full.names = T)
# Example file
#datafile <- system.file("extdata", "stomach.csv.gz", package = "facets")

rcmat <- readSnpMatrix(datafile[[1]])

# Preprocess the sample. Some things here might be tweakable. 
xx = preProcSample(rcmat)

# Process a sample
# Lower cval leads to higher sensitivity for small changes.
oo <- procSample(xx, cval = 500)

# The log ratio for a diploid location in this tumour sample
oo$dipLogR

fit <- emcncf(oo)

# cf.em = initial estimates of cellular fraction
# tcn.em = total copy number estimate
# lcn.em = minor copy number estimate
# All by the expectation-maximization (EM)-algorithm 

# For diploid normal segments (total copy=2, minor copy=1)

head(fit$cncf)

facets_table <- fit$cncf

seg_file_IGV <- data.frame(Sample = "E233_test", Chrom = facets_table$chrom, Start = facets_table$start, Stop = facets_table$end,
                           Mark = facets_table$num.mark, Seg.CN = facets_table$cnlr.median)

# Seg file that can be opened in IGV
write_tsv(seg_file_IGV, "E233.seg")

# The logOR data for a segment are summarized using the square of expected log-odds-ratio (mafR column)
# mafR = minor allele frequency ratio 

# Estimated tumor sample purity and ploidy are reported

fit$purity
fit$ploidy

# At each position, logR is defined by the log-ratio of total read depth 
# in the tumor versus that in the normal and logOR is defined by the log-odds 
# ratio of the variant allele count in the tumor versus in the normal.
pdf("file.pdf")
plotSample(x=oo, emfit = fit)
dev.off()
logRlogORspider(oo$out, oo$dipLogR)
