#! /bin/sh

DATA_PATH=$1

for ORDER in $(ls ${DATA_PATH}); do
    for FAMILY in $(ls ${DATA_PATH}${ORDER}); do
        if [[ -f "${DATA_PATH}${ORDER}/${FAMILY}/12-PDB_filter/${FAMILY}_sged.csv" ]]; then
            if [[ ! -d "${DATA_PATH}${ORDER}/${FAMILY}/13-Translated_coordinates" ]]; then
                mkdir ${DATA_PATH}${ORDER}/${FAMILY}/13-Translated_coordinates
            fi

            for INDEX in $(ls ${DATA_PATH}${ORDER}/${FAMILY}/12-PDB_filter/*index.txt); do
                
                REF=$(echo ${INDEX} | cut -d"/" -f6 | cut -d"_" -f1)

                python3 ~/Downloads/sgedtools/src/sged-translate-coords.py \
                    -s ${DATA_PATH}${ORDER}/${FAMILY}/12-PDB_filter/${FAMILY}_sged.csv \
                    -o ${DATA_PATH}${ORDER}/${FAMILY}/13-Translated_coordinates/${FAMILY}_${REF}.csv \
                    -i ${INDEX} \
                    -n PdbRes \
                    -c
            done
        fi
    done
done