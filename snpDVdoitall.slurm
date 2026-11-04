#!/bin/bash

#SBATCH --mail-type=fail
#SBATCH --job-name="snps"
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --time=28:00:00
#SBATCH --mem=20G
#SBATCH --partition=pcourse

DATASTORE="/data/users/lfalquet/class/SBI.07107/YEAST/"

#activating conda env if needed
if [[ $CONDA_DEFAULT_ENV != "/data/users/lfalquet/class/SBI.07107/conda/env/ws2026" ]]
    then
	source /srv/ss/sib/ibu/rocky8/2023072800/software/Anaconda3/2022.05/etc/profile.d/conda.sh
        conda config --set env_prompt '({name}) '
        conda activate /data/users/lfalquet/class/SBI.07107/conda/env/ws2026
    fi


NAME=$1
THREADS=$SLURM_CPUS_PER_TASK

mkdir /data/users/${USER}/bioinfo-practical-group-j/snpDV_${NAME}
cd /data/users/${USER}/bioinfo-practical-group-j/snpDV_${NAME}

ln -s /data/users/${USER}/bioinfo-practical-group-j/bwa*/*_clean.vcf.gz .
ln -s /data/users/${USER}/bioinfo-practical-group-j/bwa*/*_clean.vcf.gz.tbi .

bcftools merge -O v `ls *.vcf.gz` > ${NAME}all.vcf

SNPEFF=/data/users/lfalquet/SBC07107_25/scripts/snpEff
java -Xmx20g -jar ${SNPEFF}/snpEff.jar R64-1-1.105 -no-upstream -no-downstream ${NAME}all.vcf > ${NAME}all_annot.vcf 

cat ${NAME}all_annot.vcf | java -jar ${SNPEFF}/SnpSift.jar filter "(( ANN[*].EFFECT != 'synonymous_variant') & ( ANN[*].EFFECT != 'intergenic_region'))"   > ${NAME}all_coding.vcf

# keep only variants that are found in less than 3 strains
cat ${NAME}all_coding.vcf | java -jar ${SNPEFF}/SnpSift.jar filter  "((countVariant() < 3))" > ${NAME}all_coding_max2.vcf 

# Tip: modify before importing into excel
perl -pe 's/;ANN=/;\tANN=/g' ${NAME}all_coding_max2.vcf > ${NAME}all_coding_max2_forexcel.vcf 
perl -i -pe 's/FORMAT\t/FORMAT\t\t/' ${NAME}all_coding_max2_forexcel.vcf

