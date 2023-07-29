#! /bin/sh

# We take into account the path to the database
DATA_PATH=$1
LIST_ORDERS="../01-AcnucFamilies/List_superkingdoms.txt"

# We iterate over each gene family in every Super-Kingdom
cat ${LIST_ORDERS} | while read ORDER; do
#for ORDER in $(ls ${DATA_PATH}); do
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
                    if [[ "$LINE_PDB" = "4V9F" ]] || [[ "$LINE_PDB" = "5AFI" ]] || [[ "$LINE_PDB" = "4V7O" ]] || [[ "$LINE_PDB" = "4YFC" ]]; then
                        continue
                    else
                        PDB="${PDB} -p ${LINE_PDB}"
                    fi

                fi
            done < ${DATA_PATH}${ORDER}/${FAMILY}/12-Pdb_information/Pdb_info.csv

            if [[ "$PDB" = " -p " ]]; then
                continue
            else
                # Once we have all the pdb references, we run the sged-create-structure-index script that downloads the pdb reference files, 
                # choses the best one depending on the alignment and writes an index file containing the alignment position of the residues
                # from the selected chain in the pdb reference file
                python3 ./sged-create-structure-index.py \
                                ${PDB} \
                                -f remote:pdb \
                                -a ${DATA_PATH}${ORDER}/${FAMILY}/07-Consensus/${FAMILY}.mase \
                                -g ig \
                                -o ${DATA_PATH}${ORDER}/${FAMILY}/12-Pdb_information/${FAMILY}_index.txt \
                                -x

                # Finaly, we move the reference files to the 12-Pdb_information folder in the database.
                for pdb in ${PDB}; do 
                    x=$(echo ${pdb} | sed "s/ //g")
                    if [[ "${x}" = "-p" ]]; then
                        continue
                    else
                        p=$(echo ${x} | tr "[:upper:]" "[:lower:]")
                        mv pdb${p}.ent ${DATA_PATH}${ORDER}/${FAMILY}/12-Pdb_information/${p}.pdb
                    fi
                done
            fi
        fi
    done
done

# The sged-create-structure-index.py creates a folder called obsolete in which it stores the obsolete files. If it is empty,
# we remove it. If not, we take a look at it
if [[ -d "obsolete/" ]]; then
    if [[ "$(ls -A obsolete/)" ]]; then
        echo "Check the obsolete folder for info"
    else
        rmdir obsolete/
    fi
fi
