#! /bin/sh

DATA_PATH=$1

for ORDER in $(ls ${DATA_PATH}); do
    for FAMILY in $(ls ${DATA_PATH}${ORDER}); do
        if [[ -d "${DATA_PATH}${ORDER}/${FAMILY}/09-PhyML_tree/" ]]; then
            if [[ ! -d "${DATA_PATH}${ORDER}/${FAMILY}/10-Tree_without_bootstrap/" ]]; then
                mkdir "${DATA_PATH}${ORDER}/${FAMILY}/10-Tree_without_bootstrap/"
            fi

            sem --jobs -0 Rscript Converter.R ${DATA_PATH}${ORDER}/${FAMILY}/09-PhyML_tree/${FAMILY}.phylip_phyml_tree.txt
        fi
    done
done

