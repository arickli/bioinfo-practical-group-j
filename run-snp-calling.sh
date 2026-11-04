#!/bin/bash

#SBATCH --mail-type=fail
#SBATCH --job-name="snp_calling"
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --time=2:00:00
#SBATCH --mem=25G
#SBATCH --partition=pcourse
#SBATCH --error=snp/error_%x_%j.txt
#SBATCH --output=snp/output_%x_%j.txt

XX=$1

# 2. Navigate to SNP directory
mkdir -p /data/users/${USER}/bioinfo-practical-group-j/snp
cd /data/users/${USER}/bioinfo-practical-group-j

# 3. Symlink reference files (including index)
DATASTORE="/data/users/lfalquet/class/SBI.07107/YEAST/"
ln -s ${DATASTORE}/reference/R64-1-1.112.fa .
ln -s ${DATASTORE}/reference/R64-1-1.112.gtf .
ln -s /data/users/${USER}/bioinfo-practical-group-j/bwa*/*.bam .

bcftools mpileup -Ou --threads 8 -f R64-1-1.112.fa bwa${XX}/${XX}.bam | bcftools call -vc -Oz --threads 8 -o snp/${XX}.vcf.gz

cd /data/users/${USER}/bioinfo-practical-group-j/snp

tabix ${XX}.vcf.gz
