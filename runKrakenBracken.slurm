#!/bin/bash

#SBATCH --mail-type=fail
#SBATCH --job-name="kraken2"
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --time=2:59:00
#SBATCH --mem=30G
#SBATCH --partition=pcourse

DATASTORE="/data/users/lfalquet/class/SBI.07107/ASM/"

#activating conda env if needed
if [[ $CONDA_DEFAULT_ENV != "/data/users/lfalquet/class/SBI.07107/conda/env/ws2026" ]]
    then
        source /srv/ss/sib/ibu/rocky8/2023072800/software/Anaconda3/2022.05/etc/profile.d/conda.sh
	conda config --set env_prompt '({name}) '
        conda activate /data/users/lfalquet/class/SBI.07107/conda/env/ws2026
    fi

THREADS=$SLURM_CPUS_PER_TASK


GROUP=$1
BC=$2
FILEPATH=/data/users/${USER}/bioinfo-practical-group-j/${GROUP}
cd ${FILEPATH}

KRAKEN2_DB_PATH=/data/users/lfalquet/SOFTS/k2_standard_16G_20260626

#kraken2
kraken2 --threads 8 --db ${KRAKEN2_DB_PATH}  groupJ/${BC}*.fastq.gz --report kraken2/kraken2_${BC}.report --confidence 0.01 > kraken2/kraken2_${BC}.output 

#bracken restimation:
bracken -d ${KRAKEN2_DB_PATH} -i kraken2/kraken2_${BC}.report -o kraken2/kraken2_${BC}.braken -r 100  -l 'S' -t 1
