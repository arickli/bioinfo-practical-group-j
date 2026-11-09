#!/bin/bash

#SBATCH --mail-type=fail
#SBATCH --job-name="QUAST"
#SBATCH --nodes=1
#SBATCH --cpus-per-task=12
#SBATCH --time=3:00:00
#SBATCH --mem=20G
#SBATCH --partition=pcourse

#conda env is incompatible with QUAST
source /srv/ss/sib/ibu/rocky8/2023072800/software/Anaconda3/2022.05/etc/profile.d/conda.sh
conda deactivate

BARCODE=$1

cd /data/users/${USER}/bioinfo-practical-group-j/groupJ/compareASM_${BARCODE}

LIST=$(ls *.fa*)
python3 /data/users/lfalquet/SOFTS/quast-5.3.0/quast.py -t ${SLURM_CPUS_PER_TASK} ${LIST}


conda activate /data/users/lfalquet/class/SBI.07107/conda/env/ws2026
