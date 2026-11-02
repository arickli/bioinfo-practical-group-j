#!/bin/bash

#SBATCH --mail-type=fail
#SBATCH --job-name="bwa"
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --time=36:00:00
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


XX=$1
GROUP=$2
THREADS=$SLURM_CPUS_PER_TASK

#create and go to the TP directory
mkdir /data/users/${USER}/bioinfo-practical-group-j/bwa$1
cd /data/users/${USER}/bioinfo-practical-group-j/bwa$1

#link the reference genome and the reads locally
ln -s ${DATASTORE}/reference/R64-1-1.112.fa .
ln -s ${DATASTORE}/reference/R64-1-1.112.gtf .
ln -s ${DATASTORE}/${GROUP}/${XX}_1.fastq.gz ${XX}_1.fastq.gz
ln -s ${DATASTORE}/${GROUP}/${XX}_2.fastq.gz ${XX}_2.fastq.gz

#verify that your files are in your directory (ls -l)

fastqc -t $THREADS ${XX}_1.fastq.gz ${XX}_2.fastq.gz

#with trimmotatic
#trimmomatic PE -threads ${THREADS} -phred33 ${XX}_1.fastq.gz ${XX}_2.fastq.gz ${XX}_1trim.fastq.gz ${XX}_1unpaired.fastq.gz ${XX}_2trim.fastq.gz ${XX}_2unpaired.fastq.gz LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:130

#with fastp
fastp -i ${XX}_1.fastq.gz -I ${XX}_2.fastq.gz -o ${XX}_1trim.fastq.gz -O ${XX}_2trim.fastq.gz -j ${XX}_fastp.json -h ${XX}_fastp.html --thread ${THREADS} --trim_poly_g -l 50;


#index reference for bwa
bwa index R64-1-1.112.fa

#map reads onto reference
bwa mem -t $THREADS -M R64-1-1.112.fa ${XX}_1trim.fastq.gz ${XX}_2trim.fastq.gz > ${XX}.sam

#index reference for samtools
samtools faidx R64-1-1.112.fa

#convert sam to bam
samtools view -b -@ $THREADS -t R64-1-1.112.fa.fai ${XX}.sam > ${XX}_unsorted.bam

#sort bam
samtools sort -@ $THREADS -o ${XX}.bam ${XX}_unsorted.bam
rm ${XX}_unsorted.bam  
rm ${XX}.sam

#index bam
samtools index -@ $THREADS ${XX}.bam

