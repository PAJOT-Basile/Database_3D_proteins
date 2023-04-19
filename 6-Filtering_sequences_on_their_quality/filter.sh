#! /bin/sh


DATA_PATH=$1
METHOD=$2
LIST_ORDERS="../1-AcnucFamilies/List_superkingdoms.txt"

read -r -p "Here, you have to chose a threshold value for the gap score. \nThis value will be used to filter the family gene files evaluated previously to select
    only some of them that are clean enough to keep going.\n This value has to be between 0 and 1 and the decimal shall be indicated with a dot.
    Given the graphs that were written using this program, what threshold gap score should be used to filter the data ? " THRESHOLD

cat $LIST_ORDERS | while read ORDER; do

    rm -r ./$ORDER

    echo $ORDER
    mkdir $ORDER

    cat ./csvs/Evaluation_scores_${ORDER}_$METHOD.csv | while read line; do

        if [[ $line = "Family_name"* ]]; then
            continue
        else
            GAP_SCORE=$(echo $line | cut -d";", -f4)
            FAMILY_NAME=$(echo $line | cut -d";" -f1)
            if [[ $GAP_SCORE -lt $THRESHOLD ]]; then
                cp $DATA_PATH$ORDER/$FAMILY_NAME.fasta ./$ORDER/$FAMILY_NAME.fasta
            fi
        fi
    done
done