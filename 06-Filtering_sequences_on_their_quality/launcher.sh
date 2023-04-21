#! /bin/sh

# This script takes into account the path to the parallel folder and the method to calculate the gap score
# If the method is not given, the default value is "simple"
DATA_PATH=$1
METHOD=${2:-"simple"}

# Say what action you want the script to run. Either, you evaluate the data, you filter it after the evaluation process or you do both
read -r -p "What do you want to do (evaluate, filter or both) ? " ACTION
ACTION_TO_DO=$(echo $ACTION | tr "[:lower:]" "[:upper:]")

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
    read -r -p "Here, you have to chose a threshold value for the gap score. This value will be used to filter the family gene files evaluated previously to select
        only some of them that are clean enough to keep going. This value has to be between 0 and 1 and the decimal shall be indicated with a dot. 
        The filtration step requires that you have run the evaluation proccess before and chosen a gap score valueas threshold. If you did not
        select the threshold value, simply press enter. This will let you go through the evaluation process and you can take a look at your data before 
        answering. The threshold question will be asked later.
        Given the graphs that were written using this program, what threshold gap score should be used to filter the data ? " THRESHOLD
fi

# This file contains a list of the Super-Kingdoms we are working on. We will iterate over these orders
LIST_ORDERS="../01-AcnucFamilies/List_superkingdoms.txt"


# We make an evaluate function. It iterates over the Super-Kingdoms to calculate the gap score per gene family file and appends it to a dedicated csv
function Evaluate() {

    # This function takes as input the path to the parallel folder, the list of Super-Kingdoms and the method to use to calculate the gap score
    DATA_PATH=$1
    LIST_ORDERS=$2
    METHOD=$3

    # If the script was never run, we create the csvs folder where the gap scores will be stored in one csv file per Super-Kingdom
    if [ ! -d "./csvs" ]; then
        mkdir ./csvs
    fi

    # We iterate over the Super-Kingdoms and run the "Quality_evaluator.py" script that calculates the gap score and adds it per gene family to the 
    # csv of the appropriate Super-Kingdom and method. Therefore, you can compare methods if needed
    # This loop also runs the "distribution.R" script plotting the gap score for the different gene families
    cat $LIST_ORDERS | while read ORDER; do

        # If the script was run before, we remove the evaluation outputs (the csv and the graph)
        rm -r csvs/*${ORDER}_$METHOD.csv ./*${ORDER}_$METHOD.png

        echo $ORDER

        # We create the csv file where the gap scores will be stored. We also add a header to this csv file
        echo "Family_name;Number_sequences;Number_sites;Gap_score" >> ./csvs/Evaluation_scores_${ORDER}_$METHOD.csv
        
        # We run the "Quality_evaluator.py" script that takes into account the path to the parallel folder, the name of the Super-Kingdom and the method
        # to calculate the gap score
        python3 ./Quality_evaluator.py $DATA_PATH $ORDER $METHOD

        # We then run the "distribution.R" script taking into account the name of the Super-Kingdom and the gap score calculation method
        Rscript ./distribution.R $ORDER $METHOD
    done
}

# We make a filter function. It iterates over the Super-Kingdoms to copy gene family files that have a lower gap score than the defined threshold
# into this folder
function Filter() {

    # This function takes as input the path to the parallel folder, the list of Super-Kingdoms, the gap score calculation method and the threshold value
    # to filter on. If the threshold value is not given, we ask for it
    DATA_PATH=$1
    LIST_ORDERS=$2
    METHOD=$3
    if [ -z "$4" ]; then
        read -r -p "Here, you have to chose a threshold value for the gap score. This value will be used to filter the family gene files evaluated previously to select
        only some of them that are clean enough to keep going. This value has to be between 0 and 1 and the decimal shall be indicated with a dot.
        Given the graphs that were written using this program, what threshold gap score should be used to filter the data ? " THRESHOLD
    else
        THRESHOLD=$4
    fi
    
    # We iterate over the Super-Kingdoms. For each Super-Kingdom, we compare the value of gap score for each gene family file to the chosen threshold
    # If it is lower, the corresponding gene family file is copied in the local folder.
    cat $LIST_ORDERS | while read ORDER; do

        # If the script was run before, we clean up the folder containing the gene family files
        rm -r ./$ORDER
        printf "\n$ORDER\n"

        # We create a new Super-Kingdom folder where all the filtered gene family files will be stored
        mkdir $ORDER

        # The two following variables are used to define and use the progress bar
        data_length=$(wc -l ./csvs/Evaluation_scores_${ORDER}_$METHOD.csv)
        counter=1

        # We iterate over the csv file created in the evaluation phase to extract the gap score and the gene family name to compare the gap score
        # to the threshold and copy the according file if needed
        cat ./csvs/Evaluation_scores_${ORDER}_$METHOD.csv | while read line; do

            # We implement a progress bar to the code to follow the progress
            ProgressBar ${counter} ${data_length}

            # If the line in the csv file starts with "Family_name", it is the header, not containing any gap score so we continue
            # In the other cases, we extract the gap score, the family name and compare the gap score to the threshold. If it is lower than the threshold, 
            # we copy the according gene family file in the right Super-Kingdom folder in this folder
            if [[ $line = "Family_name"* ]]; then
                continue
            else
                GAP_SCORE=$(echo "$line" | cut -d";" -f4 | sed "s/\r//g")
                FAMILY_NAME=$(echo "$line" | cut -d";" -f1)
                if [ 1 -eq $(echo "${GAP_SCORE} < ${THRESHOLD}" | bc) ]; then
                    cp $DATA_PATH$ORDER/$FAMILY_NAME.fasta ./$ORDER/$FAMILY_NAME.fasta
                fi
            fi
            ((counter+=1))
        done
    done
}

# Create a progress bar function to show how we advance in the progress as it is a long process
function ProgressBar {
    # The first variable is the total number of files to iterate over
    total_files=${2}
    # The second variable calculates the percentage of advancement of the process taking into account the beginning and the end of the process to follow
    let _progress=(${1}*100/$((total_files-1))*100)/100
    # The third variable transforms the advancement of the progress into a number between 1 and 40 to represent it using "#" in the progress bar.
    let _done=(${_progress}*10)/10
    # The _left variable takes the complementary number to 40 to be able to fill the empty spots with "-" when the progress bar is loaded
    let _left=100-$_done
    # The "_fill" and "_empty" variables are used to get the number of times we will print each character
    _fill=$(printf "%${_done}s")
    _empty=$(printf "%${_left}s")
    

    # Once all of this is done, we print the progress bar
    printf "\rFiltering : |${_fill// /█}${_empty// / }| ${_progress}%%; doing file number ${1}/$((total_files-1))"

}


# If the "EVALUATION" variable is set to "TRUE", then, we evaluate the file. At the end of the evaluation process for all Super-Kingdoms,
# as the process is long, and you may have decided on a gap score threshold during the loading time, we ask if you wish to filter the gene family files
# right away. If it is the case, we set the "FILTER" parameter to "TRUE" and otherwise, the code ends
if [[ $EVALUATION = "T"* ]]; then
    Evaluate ${DATA_PATH} ${LIST_ORDERS} ${METHOD}
    if [[ $FILTER != "T"* ]]; then
        read -r -p "Do you want to filer the sequences right now (yes or no)? " QUESTION_Q
        QUESTION=$(echo $QUESTION_Q | tr "[:lower:]" "[:upper:]")
        if [[ $QUESTION = "Y"* ]]; then
            FILTER="TRUE"
        fi
    fi
fi

# If the "FILTER" parameter is set to "TRUE", then, we filter the files in all Super-Kingdoms
if [[ $FILTER = "T"* ]]; then
    Filter ${DATA_PATH} ${LIST_ORDERS} ${METHOD} ${THRESHOLD}
fi

# We print the end of the file
printf "\nDone !\n"