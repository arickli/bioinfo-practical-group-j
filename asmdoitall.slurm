#!/bin/bash
#SBATCH --cpus-per-task=8
#SBATCH --mem=100G
#SBATCH --time=12:00:00
#SBATCH --job-name=hifiasm
#SBATCH --mail-type=FAIL
#SBATCH --partition=pcourse
#---------------------------------------------------------------


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
barcode=$2
#-- 0 -- setup 
workdir=/data/users/${USER}/bioinfo-practical-group-j/${GROUP}
outdir=${workdir}/hifi_asm/${barcode}
mkdir -p ${outdir}
cd ${workdir}

#QC
cp ${DATASTORE}/${GROUP}/${barcode}.fastq.gz .
fastqc -t ${THREADS} ${barcode}.fastq.gz
fastplong -i ${barcode}.fastq.gz -W 10 -5 -3 -M 10 -l 3000 -w ${THREADS} -o ${barcode}_clean.fastq.gz

#Assemble
hifiasm -o ${outdir}/${barcode} -t ${THREADS} ${workdir}/${barcode}_clean.fastq.gz
perl -ane 'if ($F[0]eq"S") { print ">".$F[1]."\n".$F[2]."\n"}' ${outdir}/${barcode}.bp.p_ctg.gfa > ${outdir}/${barcode}.p_ctg.fa
