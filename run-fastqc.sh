#!/bin/bash

#SBATCH --mail-type=fail
#SBATCH --job-name="FastQC"
#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --time=2:00:00
#SBATCH --mem=25G
#SBATCH --partition=pcourse
#SBATCH --error=error_%x_%j.txt
#SBATCH --output=output_%x_%j.txt

DATASTORE="/data/users/lfalquet/class/SBI.07107/YEAST/"

GROUP=$1
XX=$2

mkdir /data/users/${USER}/bwa/${XX}
cd /data/users/${USER}/bwa/${XX}

ln -s ${DATASTORE}/reference/R64-1-1.112.fa .
ln -s ${DATASTORE}/reference/R64-1-1.112.gtf .
ln -s ${DATASTORE}/${GROUP}/${XX}_1.fastq.gz ${XX}_1.fastq.gz
ln -s ${DATASTORE}/${GROUP}/${XX}_2.fastq.gz ${XX}_2.fastq.gz

fastqc -t 2 ${XX}_*.fastq.gz