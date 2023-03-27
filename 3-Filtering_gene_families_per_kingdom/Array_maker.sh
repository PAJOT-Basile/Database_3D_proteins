#! /bin/bash

DATA_PATH=$1
LIST_ORDERS="Archaea Bacteria Eukaryota"

for ORDER in $LIST_ORDERS; do

    #mkdir $ORDER
    File_number=1
    echo $ORDER
    LIST_FAMILIES=$(ls "${DATA_PATH}${ORDER}")
    for FAMILY in $LIST_FAMILIES; do
        
        bash Python_launcher.sh $DATA_PATH $ORDER $FAMILY 
        
        File_number=$(( $File_number + 1 ))

        if [[ $(expr $File_number % 1000) -eq 0 ]]; then
            echo $File_number
        fi
    done
done
