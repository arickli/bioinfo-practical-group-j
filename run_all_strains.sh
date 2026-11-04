#!/bin/bash

NAMES="B3c3 F22c3 K47c2 L53c1 WT"

for strain in ${NAMES}
    do sbatch run-snp-calling.sh ${strain} groupJ
done