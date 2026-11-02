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

set -euo pipefail

DATASTORE="/data/users/lfalquet/class/SBI.07107/YEAST/"

GROUP=$1
XX=$2

WORKDIR="/data/users/${USER}/bwa/${XX}"
OUTDIR="${WORKDIR}/output/${XX}"

mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Create the strain-specific output folder for FastQC reports
mkdir -p "${OUTDIR}"

ln -s "${DATASTORE}/reference/R64-1-1.112.fa" .
ln -s "${DATASTORE}/reference/R64-1-1.112.gtf" .
ln -s "${DATASTORE}/${GROUP}/${XX}_1.fastq.gz" "${XX}_1.fastq.gz"
ln -s "${DATASTORE}/${GROUP}/${XX}_2.fastq.gz" "${XX}_2.fastq.gz"

# -o specifies where all HTML and zip results will be saved
fastqc -t 2 -o "${OUTDIR}" ${XX}_*.fastq.gz