#! /bin/sh

# We take as input the relative path to the database and the number of the folder to test
DATA_PATH=$1
FOLDER_NB=$2

# We iterate over the Super-Kingdoms.
for ORDER in $(ls ${DATA_PATH}); do
    counter=0
    echo ${ORDER}
    # We iterate over the gene families in each Super-Kingdom
    for FAMILY in $(ls ${DATA_PATH}${ORDER}/); do
        # If the considered gene family has the folder to test, we add 1 to the counter
        if [ -d "${DATA_PATH}${ORDER}/${FAMILY}/${FOLDER_NB}-"* ]; then
            ((counter+=1))
        fi
    done
    echo $counter
done
