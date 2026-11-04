#!/bin/bash

#SBATCH --mail-type=fail
#SBATCH --job-name="snp_calling"
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --time=2:00:00
#SBATCH --mem=25G
#SBATCH --partition=pcourse
#SBATCH --error=error_%x_%j.txt
#SBATCH --output=output_%x_%j.txt

XX=$1

# 2. Navigate to SNP directory
WORK_DIR="/data/users/${USER}/bioinfo-practical-group-j"
mkdir -p "${WORK_DIR}/snp"
cd "${WORK_DIR}/snp" || exit 1

# 3. Symlink reference files (including index)
DATASTORE="/data/users/lfalquet/class/SBI.07107/YEAST"
ln -sf "${DATASTORE}/reference/R64-1-1.112.fa" .
ln -sf "${DATASTORE}/reference/R64-1-1.112.fa.fai" .
ln -sf "${DATASTORE}/reference/R64-1-1.112.gtf" .

bcftools mpileup -Ou --threads 8 -f R64-1-1.112.fa ${XX}.bam | bcftools call -vc -Oz --threads 8 -o ${XX}.vcf.gz
tabix ${XX}.vcf.gz