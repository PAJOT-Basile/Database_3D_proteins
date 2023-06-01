#! /bin/sh

# We take into account the path to the database
DATA_PATH=$1

# We iterate over each gene family in each Super-Kingdom in the database and if the raser results file exists, we run the converter.
for ORDER in $(ls ${DATA_PATH}); do
    for FAMILY in $(ls ${DATA_PATH}${ORDER}); do
        if [[ -d "${DATA_PATH}${ORDER}/${FAMILY}/12-Pdb_information/" ]]; then
            python3 ./sged-raser2sged.py \
                -r ${DATA_PATH}${ORDER}/${FAMILY}/11-Raser_outputs/${FAMILY}_results_file.txt \
                -a ${DATA_PATH}${ORDER}/${FAMILY}/07-Consensus/${FAMILY}.mase \
                -f ig \
                -o ${DATA_PATH}${ORDER}/${FAMILY}/12-Pdb_information/${FAMILY}_sged.csv
        fi
    done
done