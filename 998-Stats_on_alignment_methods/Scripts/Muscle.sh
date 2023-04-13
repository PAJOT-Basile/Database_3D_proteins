#! /bin/sh

DATA_PATH=$1

folder=$(echo $METHOD | tr '[:upper:]' '[:lower:]')
LIST_DATA_FILES=$(ls ${DATA_PATH} *.fasta)

set -- $LIST_DATA_FILES
while (( $# )); do
    for ((i=0; i<7; i++)); do
        [[ $1 ]] && time muscle -in "${DATA_PATH}${1}" -out "../MUSCLE/$1.aln & shift
    done
    wait
done 