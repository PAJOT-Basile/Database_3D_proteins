#! /bin/sh

DATA_PATH=$1
ORDER=$2
FAMILY=$3

if [[ -d "${DATA_PATH}${ORDER}/${FAMILY}/12-PDB_filter" ]]; then
    rm -r ${DATA_PATH}${ORDER}/${FAMILY}/12-PDB_filter
fi
mkdir ${DATA_PATH}${ORDER}/${FAMILY}/12-PDB_filter

FAM_LINES=$(grep ${FAMILY} ${ORDER}_pdbs.csv)

grep ${FAMILY} ${ORDER}_pdbs.csv | cut -d";" -f1 >> ${FAMILY}_sequences.txt
grep ${FAMILY} ${ORDER}_pdbs.csv | cut -d";" -f2 >> ${FAMILY}_families.txt
grep ${FAMILY} ${ORDER}_pdbs.csv | cut -d";" -f3 >> ${FAMILY}_pdbs.txt
grep ${FAMILY} ${ORDER}_pdbs.csv | cut -d";" -f4 >> ${FAMILY}_res.txt

paste ${FAMILY}_families.txt ${FAMILY}_sequences.txt ${FAMILY}_pdbs.txt ${FAMILY}_res.txt | sed "s/\t/;/g" >> ${DATA_PATH}/${ORDER}/${FAMILY}/12-PDB_filter/Pdb_info.csv

sed -i $"1s/^/Gene_family;Sequence_ID;PDB;Resolution\n/" ${DATA_PATH}${ORDER}/${FAMILY}/12-PDB_filter/Pdb_info.csv

rm ${FAMILY}_*txt

RESOLUTION_OK="no"
while read LINE; do
    if [[ "${LINE}" = "Gene_family"* ]]; then
        continue
    else
        RESOLUTION=$(echo ${LINE} | cut -d";" -f4)
        echo $FAMILY/$RESOLUTION
        if [[ 1 -eq $(echo "${RESOLUTION} <= 3" | bc) ]]; then
            RESOLUTION_OK="yes"
            break 1
        fi
    fi
done < ${DATA_PATH}${ORDER}/${FAMILY}/12-PDB_filter/Pdb_info.csv

echo "$RESOLUTION_OK"
if [[ "${RESOLUTION_OK}" != "yes" ]]; then
    rm -r ${DATA_PATH}/${ORDER}/${FAMILY}/12-PDB_filter/
fi
