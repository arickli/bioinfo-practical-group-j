#!/bin/bash

NAMES="bwaB3c3/B3c3.bam  bwaF22c3/F22c3.bam  bwaK47c2/K47c2.bam  bwaL53c1/L53c1.bam  bwaWT/WT.bam"

for strain in ${NAMES}
    do sbatch run-snp-calling.sh ${strain}
done