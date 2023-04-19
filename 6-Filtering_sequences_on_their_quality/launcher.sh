#! /bin/sh

# Importing data path
DATA_PATH=$1
# Selecting the method to use for the evaluation ("simple" or "complex")
METHOD=$2

# Chose the action you want to do
read -r -p "What do you want to do (evaluate, filter or both) ?" ACTION
ACTION_TO_DO=$(echo $ACTION | tr "[:lower:]" "[:upper:]")

if [[ $ACTION_TO_DO = "E"* ]]; then
    EVALUATION="TRUE"
    FILTER="FALSE"
elif [[ $ACTION_TO_DO = "F"* ]]; then
    FILTER="TRUE"
    EVALUATION="FALSE"
elif [[ $ACTION_TO_DO = "B"* ]]; then
    EVALUATION="TRUE"
    FILTER="TRUE"
fi

# Importing the list of the order to iterate over
LIST_ORDERS="../1-AcnucFamilies/List_superkingdoms.txt"

QUESTION="NO"

# Make an evaluate function to evaluate the gap score in the files
function Evaluate() {
    # Takes the data path, the list of orders and the method as argument
    DATA_PATH=$1
    LIST_ORDERS=$2
    METHOD=$3

    # We clean up the evaluation files produced
    rm -r csvs/*$METHOD.csv ./*$METHOD.png
    rmdir ./csvs/

    # Create a storage directory
    mkdir ./csvs

    # Iterate over the orders
    cat $LIST_ORDERS | while read ORDER; do

        # Print order
        echo $ORDER

        # Add header to csv file produced and starting python and r scripts
        echo "Family_name;Number_sequences;Number_sites;Gap_score" >> ./csvs/Evaluation_scores_${ORDER}_$METHOD.csv
        python3 ./Quality_evaluator.py $DATA_PATH $ORDER $METHOD
        Rscript ./distribution.R $ORDER $METHOD
    done
}

# Function filter
function Filter() {

    # Takes the data path, the list of orders and the method as argument
    DATA_PATH=$1
    LIST_ORDERS=$2
    METHOD=$3

    # Takes into account the threshold to consider
    read -r -p "Here, you have to chose a threshold value for the gap score. \nThis value will be used to filter the family gene files evaluated previously to select
        only some of them that are clean enough to keep going.\n This value has to be between 0 and 1 and the decimal shall be indicated with a dot.
        Given the graphs that were written using this program, what threshold gap score should be used to filter the data ? " THRESHOLD

    # ITerate over the orders
    cat $LIST_ORDERS | while read ORDER; do

        # Clean up the files in the Super-Kingdom giles
        rm -r ./$ORDER

        echo $ORDER
        mkdir $ORDER

            # The two following variables are used to define and use the progress bar
        data_length=$(wc -l ./csvs/Evaluation_scores_${ORDER}_$METHOD.csv)
        counter=1

        # Iterate over the csv to take the family name and copy the according file
        cat ./csvs/Evaluation_scores_${ORDER}_$METHOD.csv | while read line; do

            # We implement the progress bar to the code
            ProgressBar ${counter} ${data_length}

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

# Create a progress bar function to show how we advance in the progress as it is a long process
function ProgressBar {
    # The first variable is the total number of files to iterate over
    total_files=${2}
    # The second variable calculates the percentage of advancement of the process taking into account the beginning and the end of the process to follow
    let _progress=(${1}*100/$((total_files-1))*100)/100
    # The third variable transforms the advancement of the progress into a number between 1 and 40 to represent it using "#" in the progress bar
    let _done=(${_progress}*4)/10
    # The _left variable takes the complementary number to 40 to be able to fill the empty spots with "-" when the progress bar is loaded
    let _left=40-$_done
    # The "_fill" and "_empty" variables are used to get the number of times we will print each character
    _fill=$(printf "%${_done}s")
    _empty=$(printf "%${_left}s")
    

    # Once all of this is done, we print the progress bar
    printf "\rFiltering : [${_fill// /#}${_empty// / }] ${_progress}%%; doing file number ${1}/$((total_files-1))"

}


# If we evaluate, then we evaluate and are asked if we want to filter and if yes, we start filtering
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
if [[ $FILTER = "T"* ]]; then
    Filter ${DATA_PATH} ${LIST_ORDERS} ${METHOD}
fi