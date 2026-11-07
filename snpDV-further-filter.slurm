#!/bin/bash

#SBATCH --mail-type=fail
#SBATCH --job-name="filter_DV_data"
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --time=1:00:00
#SBATCH --mem=1000M
#SBATCH --partition=pcourse
#SBATCH --output=/data/users/%u/bioinfo-practical-group-j/snpDV_deepVariant/slurm_%j.out
#SBATCH --error=/data/users/%u/bioinfo-practical-group-j/snpDV_deepVariant/slurm_%j.err


mkdir -p /data/users/${USER}/bioinfo-practical-group-j/snpDV_deepVariant
cd /data/users/${USER}/bioinfo-practical-group-j/snpDV_deepVariant

SNPEFF=/data/users/lfalquet/SBC07107_25/scripts/snpEff

java -jar ${SNPEFF}/SnpSift.jar filter \
  "(QUAL >= 20) & (!isVariant(GEN[4])) & ((ANN[*].IMPACT = 'HIGH') | (ANN[*].IMPACT = 'MODERATE'))" \
  deepVariantall_coding_max2.vcf > deepVariantall_coding_max2_QUAL_IMPACT_nonWT.vcf

java -jar ${SNPEFF}/SnpSift.jar extractFields deepVariantall_coding_max2_QUAL_IMPACT_nonWT.vcf \
  CHROM POS QUAL "ANN[0].GENE" "ANN[0].EFFECT" "ANN[0].IMPACT" "ANN[0].HGVS_P" \
  "GEN[0].GT" "GEN[0].DP" "GEN[1].GT" "GEN[1].DP" "GEN[2].GT" "GEN[2].DP" "GEN[3].GT" "GEN[3].DP" > deepVariantall_coding_max2_QUAL_IMPACT_nonWT_forEXCL.tsv