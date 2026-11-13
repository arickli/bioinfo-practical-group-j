#!/bin/bash

#SBATCH --mail-type=fail
#SBATCH --job-name="Bakta"
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --time=2:58:00
#SBATCH --mem=200G
#SBATCH --partition=pcourse

NAME=$4 #fasta file of draft genome
BC=$1  #barcode
genus=$2
species=$3

cd /data/users/${USER}/bioinfo-practical-group-j/groupJ/final_assembly

BAKTA_DB="/data/users/lfalquet/class/SBI.07107/scripts/BAKTA_DB"

#module add prokka/1.14.5-gompi-2021a
#module add prodigal/2.6.3-GCCcore-10.3.0
#prokka --centre UniFr --compliant --addgenes --mincontiglen 200 --outdir ${BC} --genus ${genus} --species ${species} --prefix ${BC} --rfam --locustag ${BC} --strain ${BC} --cpus ${SLURM_CPUS_PER_TASK}  ${NAME}


mkdir -p /data/users/${USER}/apptainercache
export APPTAINER_CACHEDIR=/data/users/${USER}/apptainercache
export APPTAINER_TMPDIR="/data/users/${USER}/bioinfo-practical-group-j/groupJ/final_assembly"
export SIF_CONTAINER_BAKTA="/data/users/lfalquet/class/SBI.07107/scripts/bakta_latest.sif"
export APPTAINERENV_MPLCONFIGDIR=/tmp/${USER}_matplotlib

apptainer exec --containall --bind /data,/scratch  --bind ${HOME}:/mnt  --bind $APPTAINER_TMPDIR:/home/${USER} --bind $APPTAINER_CACHEDIR:/tmp ${SIF_CONTAINER_BAKTA} bakta --db ${BAKTA_DB} --force --verbose --compliant --output bakta_${BC} --prefix ${BC} --locus-tag ${BC} --genus ${genus} --species ${species} --threads ${SLURM_CPUS_PER_TASK} ${NAME}


