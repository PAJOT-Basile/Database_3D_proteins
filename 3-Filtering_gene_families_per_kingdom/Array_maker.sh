#! /bin/bash

DATA_PATH=$1
NUMBER_OF_JOBS=$2
LIST_ORDERS=$(ls -d */)

for ORDER in $LIST_ORDERS; do

    mkdir $ORDER
    File_number=1
    echo $ORDER


    LIST_FAMILIES=$(ls "${DATA_PATH}${ORDER}")

    set -- $LIST_FAMILIES
    while (( $# )); do
        for ((i=0; i<$NUMBER_OF_JOBS; i++)); do
            [[ $1 ]] && bash Python_launcher.sh $DATA_PATH $ORDER "$1" & shift
        done
        wait
    done
done
