#!/bin/bash

#SBATCH --mail-type=fail
#SBATCH --job-name="snp calling"
#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --time=2:00:00
#SBATCH --mem=25G
#SBATCH --partition=pcourse
#SBATCH --error=error_%x_%j.txt
#SBATCH --output=output_%x_%j.txt


mkdir -p /data/users/${USER}/bioinfo-practical-group-j/snp
cd /data/users/${USER}/bioinfo-practical-group-j/snp

DATASTORE="/data/users/lfalquet/class/SBI.07107/YEAST/"
ln -s ${DATASTORE}/reference/R64-1-1.112.fa .
ln -s ${DATASTORE}/reference/R64-1-1.112.gtf .
ln -s /data/users/${USER}/bwa*/*.bam .

