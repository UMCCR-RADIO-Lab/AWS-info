#!/usr/bin/env Rscript

# Example command: Rscript /mnt/fsx/Andrew_parallel_cluster_test/ 500 samplename

library(facets)

# Read command line args
args <- commandArgs(trailingOnly = TRUE)

print(paste0("FACETS pileup output dir given is ", args[1]))
print(paste0("cval given is  ", args[2]))
print(paste0("outputting to  ", args[1]))
print(paste0("sample is called  ", args[3]))

# Test run of facets from the vignette for Roman
# https://github.com/mskcc/facets/blob/master/vignettes/FACETS.pdf

# Set seed because sample preprocessing uses random SNP sampling
set.seed(1234)

# This is the output from the C snp pileup
datafile <- list.files(path = args[1], pattern = "*.csv.gz",full.names = T)

rcmat <- readSnpMatrix(datafile[[1]])

# Preprocess the sample. Some things here might be tweakable. 
xx = preProcSample(rcmat)

# Process a sample
# Lower cval leads to higher sensitivity for small changes.
oo <- procSample(xx, cval = args[2])

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

seg_file_IGV <- data.frame(Sample = args[3], Chrom = facets_table$chrom, Start = facets_table$start, Stop = facets_table$end,
                           Mark = facets_table$num.mark, Seg.CN = facets_table$cnlr.median)

# Seg file that can be opened in IGV
write.table(seg_file_IGV, paste0(args[1], "/", args[3], ".seg"),quote = F, row.names = F, sep ="\t")

# The logOR data for a segment are summarized using the square of expected log-odds-ratio (mafR column)
# mafR = minor allele frequency ratio 

# Estimated tumor sample purity and ploidy are reported

fit$purity
fit$ploidy

# Save purity and ploidy
pp_df <- data.frame(Purity = fit$purity, Ploidy = fit$ploidy)

write.csv(pp_df, paste0(args[1], "/", args[3],  "_purity_ploidy.csv"),quote = F,row.names = F)

# At each position, logR is defined by the log-ratio of total read depth 
# in the tumor versus that in the normal and logOR is defined by the log-odds 
# ratio of the variant allele count in the tumor versus in the normal.
pdf(paste0(args[1], "/", args[3], "_FACETS_plot.pdf"))
plotSample(x=oo, emfit = fit)
dev.off()

pdf(paste0(args[1], "/", args[3], "_spider.pdf"))
logRlogORspider(oo$out, oo$dipLogR)
dev.off()
