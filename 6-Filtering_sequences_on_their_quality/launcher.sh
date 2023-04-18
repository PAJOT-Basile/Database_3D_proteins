#! /bin/sh
rm -r csvs #./*png

DATA_PATH=$1
METHOD=$2

LIST_ORDERS="../1-AcnucFamilies/List_superkingdoms.txt"

mkdir ./csvs


cat $LIST_ORDERS | while read ORDER; do

    echo $ORDER

    echo "Family_name;Number_sequences;Number_sites;Gap_score" >> ./csvs/Evaluation_scores_$ORDER.csv
    python3 ./Quality_evaluator.py $DATA_PATH $ORDER $METHOD
    Rscript ./distribution.R $ORDER $METHOD

done