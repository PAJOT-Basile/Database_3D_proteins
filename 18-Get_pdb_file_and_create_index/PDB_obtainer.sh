#! /bin/sh

DATA_PATH=$1

for ORDER in $(ls ${DATA_PATH}); do
    for FAMILY in $(ls ${DATA_PATH}${ORDER}); do
        if [[ -d "${DATA_PATH}${ORDER}/${FAMILY}/12-PDB_filter" ]]; then

            cat ${DATA_PATH}${ORDER}/${FAMILY}/12-PDB_filter/Pdb_info.csv | while read LINE; do

                if [[ "${LINE}" = "Gene_family"* ]]; then
                    continue
                else
                    PDB=$(echo ${LINE} | cut -d";" -f3)
                    python3 ~/Downloads/sgedtools/src/sged-create-structure-index.py \
                            -p ${PDB} \
                            -f remote:PDB \
                            -a ${DATA_PATH}${ORDER}/${FAMILY}/07-Consensus/${FAMILY}.mase \
                            -g ig \
                            -o ${DATA_PATH}${ORDER}/${FAMILY}/12-PDB_filter/${PDB}_PDB_index.txt \
                            -x
                    pdb=$(echo ${PDB} | tr "[:upper:]" "[:lower:]")
                    mv pdb${pdb}.ent ${DATA_PATH}${ORDER}/${FAMILY}/12-PDB_filter/
                fi
            done
        fi
    done
done

if [[ -d "obsolete/" ]]; then
    if [[ "$(ls -A obsolete)" ]]; then
        echo "Check the obsolete folder for info"
    else
        rmdir obsolete
    fi
fi