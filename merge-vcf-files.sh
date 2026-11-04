#!/bin/bash

#SBATCH --mail-type=fail
#SBATCH --job-name="merge vcf files"
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --time=2:00:00
#SBATCH --mem=25G
#SBATCH --partition=pcourse
#SBATCH --error=snp/error_%x_%j.txt
#SBATCH --output=snp/output_%x_%j.txt


cd /data/users/${USER}/bioinfo-practical-group-j/snp

bcftools merge -O v `ls *.vcf.gz` > all.vcf

