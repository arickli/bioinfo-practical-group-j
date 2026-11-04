#!/bin/bash

#SBATCH --mail-type=fail
#SBATCH --job-name="deepvariant"
#SBATCH --nodes=1
#SBATCH --cpus-per-task=12
#SBATCH --time=24:00:00
#SBATCH --mem=25G
#SBATCH --partition=pcourse

DATASTORE="/data/users/lfalquet/class/SBI.07107/YEAST/"

#activating conda env if needed
if [[ $CONDA_DEFAULT_ENV != "/data/users/lfalquet/class/SBI.07107/conda/env/ws2026" ]]
    then
	source /srv/ss/sib/ibu/rocky8/2023072800/software/Anaconda3/2022.05/etc/profile.d/conda.sh
        conda config --set env_prompt '({name}) '
        conda activate /data/users/lfalquet/class/SBI.07107/conda/env/ws2026
    fi

THREADS=$SLURM_CPUS_PER_TASK
XX=$1

#create tmpdir and go to the TP directory
cd bwa${XX}
mkdir tmp${XX}

#link the reference genome and the reads locally
rm R64-1-1.112.fa
cp ${DATASTORE}/reference/R64-1-1.112.fa .

#index references
samtools faidx R64-1-1.112.fa

## call singularity
export TMPDIR=./
export SINGULARITY_TMPDIR=./
singularity exec --no-home -B ${PWD}:${PWD} /data/users/lfalquet/class/SBI.07107/scripts/deepvariant_1.5.0.sif run_deepvariant --model_type WGS --num_shards 24 --ref R64-1-1.112.fa --reads ${XX}.bam --intermediate_results_dir tmp${XX} --output_vcf ${XX}.vcf --sample_name ${XX}

#works but must remove RefCall
grep -v RefCall ${XX}.vcf > ${XX}_clean.vcf

#compact and index
bgzip ${XX}_clean.vcf
tabix -p vcf ${XX}_clean.vcf.gz 

#clean tmp
rm -rf tmp${XX}/*

