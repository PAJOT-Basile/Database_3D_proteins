#! /bin/sh

# We take into account the path to the database and the format of the files to load to get structural information. It should be one 
# of pdb or mmCif
DATA_PATH=$1
FORMAT=$2

# We iterate over each gene family in every Super-Kingdom
for ORDER in $(ls ${DATA_PATH}); do
    for FAMILY in $(ls ${DATA_PATH}${ORDER}); do

        # We check if the file has a 12-Pdb_information folder. If not, the loop continues to the next gene family
        if [[ -d "${DATA_PATH}${ORDER}/${FAMILY}/12-Pdb_information" ]]; then

            # For gene families that have a 12-Pdb_information folder, we read the csv inside and extract all the pdb references to store
            # them in a variable to use in the creatin of the structure index
            PDB=""
            while read LINE; do

                if [[ "${LINE}" = "Gene_family"* ]]; then
                    continue
                else
                    LINE_PDB=$(echo ${LINE} | cut -d";" -f3)
                    PDB="${PDB} -p ${LINE_PDB}"

                fi
            done < ${DATA_PATH}${ORDER}/${FAMILY}/12-Pdb_information/Pdb_info.csv

            # Once we have all the pdb references, we run the sged-create-structure-index script that downloads the pdb reference files, 
            # choses the best one depending on the alignment and writes an index file containing the alignment position of the residues
            # from the selected chain in the pdb reference file
            python3 ~/Downloads/sgedtools/src/sged-create-structure-index.py \
                            ${PDB} \
                            -f remote:${FORMAT} \
                            -a ${DATA_PATH}${ORDER}/${FAMILY}/07-Consensus/${FAMILY}.mase \
                            -g ig \
                            -o ${DATA_PATH}${ORDER}/${FAMILY}/12-Pdb_information/${FAMILY}_index.txt \
                            -x

            # Finaly, we move the reference files to the 12-Pdb_information folder in the database
            for pdb in ${PDB}; do 
                x=$(echo ${pdb} | sed "s/ //g")
                if [[ "${x}" = "-p" ]]; then
                    continue
                else
                    p=$(echo ${x} | tr "[:upper:]" "[:lower:]")

                    if [[ "${FORMAT}" = "mmCif" ]]; then
                        mv ${p}.cif ${DATA_PATH}${ORDER}/${FAMILY}/12-Pdb_information/
                    else
                        mv pdb${p}.ent ${DATA_PATH}${ORDER}/${FAMILY}/12-Pdb_information/
                    fi
                fi
            done
        fi
    done
done

# The sged-create-structure-index.py creates a folder called obsolete in which it stores the obsolete files. If it is empty,.
# we remove it. If not, we take a look at it
if [[ -d "obsolete/" ]]; then
    if [[ "$(ls -A obsolete)" ]]; then
        echo "Check the obsolete folder for info"
    else
        rmdir obsolete
    fi
fi