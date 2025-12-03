#!/bin/bash

set -euo pipefail

mkdir -p data/assembly results/alignment
wget https://s3-us-west-2.amazonaws.com/human-pangenomics/T2T/HG002/assemblies/hg002v1.1.fasta.gz -P data/assembly

# conda install bioconda::minimap2 bioconda::samtools
minimap2 -x lr:hq data/assembly/hg002v1.1.fasta.gz <(samtools bam2fq -T "*" data/ubam/*.bam) -t 12 -K 8G | \
    samtools view -bh -o results/alignment/HG002.bam

samtools index results/alignment/HG002.bam
