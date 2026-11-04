#!/bin/bash

#SBATCH --mail-type=fail
#SBATCH --job-name="filter vcf file"
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --time=2:00:00
#SBATCH --mem=25G
#SBATCH --partition=pcourse
#SBATCH --error=snp/error_%x_%j.txt
#SBATCH --output=snp/output_%x_%j.txt

cd /data/users/${USER}/bioinfo-practical-group-j/snp

SNPEFF="/data/users/lfalquet/class/SBI.07107/scripts/snpEff"

#annotate the VCF file
java -Xmx20g -jar ${SNPEFF}/snpEff.jar -no-upstream -no-downstream R64-1-1.105 all.vcf > all_annot.vcf

#remove synonymous and intergenic variants
cat all_annot.vcf | java -jar ${SNPEFF}/SnpSift.jar filter "(( ANN[*].EFFECT != 'synonymous_variant') &
( ANN[*].EFFECT != 'intergenic_region'))" > all_coding.vcf

# keep only variants that are found in less than 3 strains
cat all_coding.vcf | java -jar ${SNPEFF}/SnpSift.jar filter "((countVariant() < 3))" > all_coding_max2.vcf

# Tip: modify before importing into excel
perl -pe 's/;ANN=/;\tANN=/g' all_coding_max2.vcf > all_coding_max2_forexcel.vcf
perl -i -pe 's/FORMAT\t/FORMAT\t\t/' all_coding_max2_forexcel.vcf