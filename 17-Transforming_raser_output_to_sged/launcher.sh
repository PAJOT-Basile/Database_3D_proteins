#! /bin/sh

DATA_PATH=$1

for ORDER in $(ls ${DATA_PATH}); do
    for FAMILY in $(ls ${DATA_PATH}${ORDER}); do
        if [[ -f "${DATA_PATH}${ORDER}/${FAMILY}/11-Raser_outputs/${FAMILY}_results_file.txt" ]]; then
            python3 ./sged-raser2sged.py \
                -r ${DATA_PATH}${ORDER}/${FAMILY}/11-Raser_outputs/${FAMILY}_results_file.txt \
                -o ${DATA_PATH}${ORDER}/${FAMILY}/12-PDB_filter/${FAMILY}_sged.csv
        fi
    done
done