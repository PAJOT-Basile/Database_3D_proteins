#! /bin/sh

# Variable input
DATA_PATH=$1
ORDER=$2
FAMILY=$3

# If the output file already exists, we remove it and recreate it
if [[ -d "${DATA_PATH}${ORDER}/${FAMILY}/12-Pdb_information" ]]; then
    rm -r ${DATA_PATH}${ORDER}/${FAMILY}/12-Pdb_information
fi
mkdir ${DATA_PATH}${ORDER}/${FAMILY}/12-Pdb_information

# We extract the lines corresponding to the wanted gene family from the csv file
FAM_LINES=$(grep ${FAMILY} ${ORDER}_pdbs.csv)

# We extract the sequence ids, the gene family ids, the pdb references and the resolution of the measurement from the extracted lines
grep ${FAMILY} ${ORDER}_pdbs.csv | cut -d";" -f1 >> ${FAMILY}_families.txt
grep ${FAMILY} ${ORDER}_pdbs.csv | cut -d";" -f2 >> ${FAMILY}_sequences.txt
grep ${FAMILY} ${ORDER}_pdbs.csv | cut -d";" -f3 >> ${FAMILY}_pdbs.txt
grep ${FAMILY} ${ORDER}_pdbs.csv | cut -d";" -f4 >> ${FAMILY}_res.txt

# We paste these columns together separated by a semi-colon
paste ${FAMILY}_families.txt ${FAMILY}_sequences.txt ${FAMILY}_pdbs.txt ${FAMILY}_res.txt | sed "s/\t/;/g" >> ${DATA_PATH}/${ORDER}/${FAMILY}/12-Pdb_information/Pdb_info.csv

# We add a header to the csv file
sed -i $"1s/^/Gene_family;Sequence_ID;PDB;Resolution\n/" ${DATA_PATH}${ORDER}/${FAMILY}/12-Pdb_information/Pdb_info.csv

# We remove the construction files 
rm ${FAMILY}_*txt

# We filter the file on the resolution. If the resolution is not precise enough (too high), the 3D structure is not precise enough so
# we take out the structures that have a too high resolution. We iterate over the lines in the newly created csv file in the gene family folder
# If one resolution is greater than the wanted threshold, this line is not copied to the temporary file, therefore, removing it from the end 
# file.
counter=0
cat ${DATA_PATH}${ORDER}/${FAMILY}/12-Pdb_information/Pdb_info.csv | while read LINE; do
    if [[ "${LINE}" = "Gene_family"* ]]; then
        echo ${LINE} >> ${DATA_PATH}${ORDER}/${FAMILY}/12-Pdb_information/temp.csv
        continue
    else
        RESOLUTION=$(echo ${LINE} | cut -d";" -f4)
        if [[ "${RESOLUTION}" != "-" ]] && [[ $(echo "${RESOLUTION} <= 3" | bc) -eq 1 ]]; then
            echo ${LINE} >> ${DATA_PATH}${ORDER}/${FAMILY}/12-Pdb_information/temp.csv
        fi
    fi
    ((counter+=1))
done
mv ${DATA_PATH}${ORDER}/${FAMILY}/12-Pdb_information/temp.csv ${DATA_PATH}${ORDER}/${FAMILY}/12-Pdb_information/Pdb_info.csv


# If all the pdb information was removed from the csv file, then we remove the directory
NB_LINES=$(wc -l ${DATA_PATH}${ORDER}/${FAMILY}/12-Pdb_information/Pdb_info.csv | cut -d' ' -f1)
if [[ 1 -eq $(echo "${NB_LINES} <= 1" | bc) ]]; then
    rm -r ${DATA_PATH}/${ORDER}/${FAMILY}/12-Pdb_information/
fi
