#! /bin/sh

# This script takes into account the path to the database
DATA_PATH=$1

# Say what action you want the script to run. Either, you evaluate the data, you filter it after the evaluation process or you do both
if [ -z "$2" ]; then
    read -r -p "What do you want to do (evaluate, filter or both) ? " ACTION
else
    ACTION=$2
fi
ACTION_TO_DO=$(echo $ACTION | tr "[:lower:]" "[:upper:]")
# We take into account the method to calculate the gap score. If the method is not given, the default value is "simple"
METHOD=${3:-"simple"}

# Depending on the answer, we attribute values to the "EVALUATION" and "FILTER" variables which will be used later
if [[ $ACTION_TO_DO = "E"* ]]; then
    EVALUATION="TRUE"
    FILTER="FALSE"
elif [[ $ACTION_TO_DO = "F"* ]]; then
    FILTER="TRUE"
    EVALUATION="FALSE"
elif [[ $ACTION_TO_DO = "B"* ]]; then
    EVALUATION="TRUE"
    FILTER="TRUE"
    # If we want to do both, we select the threshold value to do the filtration step on
    read -r -p "Here, you have to chose a threshold value for the gap score. This value will be used to filter the family gene files 
        evaluated previously to select only some of them that are clean enough to keep going. This value has to be between 0 and 1 and 
        the decimal shall be indicated with a dot. The filtration step requires that you have run the evaluation proccess before and chosen
        a gap score valueas threshold. If you did not select the threshold value, simply press enter. This will let you go through the 
        evaluation process and you can take a look at your data before answering. The threshold question will be asked later.
        Given the graphs that were written using this program, what threshold gap score should be used to filter the data ? " THRESHOLD
fi

# This file contains a list of the Super-Kingdoms we are working on. We will iterate over these orders
LIST_ORDERS="../01-AcnucFamilies/List_superkingdoms.txt"


# We make an evaluate function. It iterates over the Super-Kingdoms to calculate the gap score per gene family file and appends it to 
# a dedicated csv
function Evaluate() {

    # This function takes as input the path to the parallel folder, the list of Super-Kingdoms and the method to use to calculate the gap score
    DATA_PATH=$1
    LIST_ORDERS=$2
    METHOD=$3

    # If the script was never run, we create the csvs folder where the gap scores will be stored in one csv file per Super-Kingdom
    if [ ! -d "./csvs" ]; then
        mkdir ./csvs
    fi

    # We iterate over the Super-Kingdoms and run the "Quality_evaluator.py" script that calculates the gap score and adds it per gene family
    # to the csv of the appropriate Super-Kingdom and method. Therefore, you can compare methods if needed. This loop also runs the 
    # "distribution.R" script plotting the gap score for the different gene families
    cat $LIST_ORDERS | while read ORDER; do

        # If the script was run before, we remove the evaluation outputs (the csv and the graph)
        rm -r ./csvs/*${ORDER}_$METHOD.csv ./*${ORDER}_$METHOD.png

        echo "Evaluating $ORDER"

        # We create the csv file where the gap scores will be stored. We also add a header to this csv file
        echo "Family_name;Number_sequences;Number_sites;Gap_score" >> ./csvs/Evaluation_scores_${ORDER}_$METHOD.csv
        
        # We run the "Quality_evaluator.py" script that takes into account the path to the parallel folder, the name of the Super-Kingdom 
        # and the method to calculate the gap score
        python3 ./Quality_evaluator.py $DATA_PATH $ORDER $METHOD

        # We then run the "distribution.R" script taking into account the name of the Super-Kingdom and the gap score calculation method
        Rscript ./distribution.R $ORDER $METHOD
    done
}

# If the "EVALUATION" variable is set to "TRUE", then, we evaluate the file. At the end of the evaluation process for all Super-Kingdoms,
# as the process is long, and you may have decided on a gap score threshold during the loading time, we ask if you wish to filter the gene 
# family files right away. If it is the case, we set the "FILTER" parameter to "TRUE" and otherwise, the code ends
if [[ $EVALUATION = "T"* ]]; then
    Evaluate ${DATA_PATH} ${LIST_ORDERS} ${METHOD}
fi