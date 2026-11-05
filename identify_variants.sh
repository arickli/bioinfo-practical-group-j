#!/bin/env bash

#SBATCH --job-name="identify_variants"
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --time=00:10:00
#SBATCH --mem=25G
#SBATCH --partition=pcourse



mkdir -p /data/users/${USER}/bioinfo-practical-group-j/snp
cd /data/users/${USER}/bioinfo-practical-group-j/snp

DATASTORE="/data/users/lfalquet/class/SBI.07107/YEAST/"
ln -sf ${DATASTORE}/reference/R64-1-1.112.fa .
ln -sf ${DATASTORE}/reference/R64-1-1.112.gtf .
ln -sf /data/users/${USER}/bioinfo-practical-group-j/bwa*/*.bam .


for file in *.bam
    do XX=$(echo ${file} | cut -d '.' -f 1)
    bcftools mpileup -Ou --threads 8 -f R64-1-1.112.fa ${file} \
    | bcftools call -vc -Oz --threads 8 -o ${XX}.vcf.gz
    tabix ${XX}.vcf.gz
done

bcftools merge -O v `ls *.vcf.gz` > all.vcf


