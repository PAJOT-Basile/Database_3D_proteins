#! /bin/sh

DATA_PATH=$1
METHOD=$2
read -r -p "Is the evaluation of the gap score done ?(yes or no): " EVALUATION_Q
EVALUATION=$(echo $EVALUATION_Q | tr "[:lower:]" "[:upper:]")
LIST_ORDERS="../1-AcnucFamilies/List_superkingdoms.txt"


function Evaluate() {
    DATA_PATH=$1
    LIST_ORDERS=$2
    METHOD=$3

    rm -r csvs/*$METHOD.csv ./*$METHOD.png
    rmdir ./csvs/

    mkdir ./csvs


    cat $LIST_ORDERS | while read ORDER; do

        echo $ORDER

        echo "Family_name;Number_sequences;Number_sites;Gap_score" >> ./csvs/Evaluation_scores_${ORDER}_$METHOD.csv
        python3 ./Quality_evaluator.py $DATA_PATH $ORDER $METHOD
        Rscript ./distribution.R $ORDER $METHOD

    done
}

function Filter() {

    DATA_PATH=$1
    LIST_ORDERS=$2
    METHOD=$3

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

}



if [[ $EVALUATION = "N"* ]]; then
    Evaluate ${DATA_PATH} ${LIST_ORDERS} ${METHOD}
elif [[ $EVALUATION = "Y"* ]]; then
    Filter ${DATA_PATH} ${LIST_ORDERS} ${METHOD}
else
    echo "Sorry, please tell us if the evaluation of the gap score has been done yet. Try again!"
fi