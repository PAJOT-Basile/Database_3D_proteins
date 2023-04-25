#! /bin/sh

DATA_PATH=$1
if [ -z "$2" ]; then
    read -r -p "Please give a threshold value to use. 
    This value will be used to stop the optimisation process of files containing more sequences than the chosen threshold value.
    What threshold value should be used ? " THRESHOLD
else
    THRESHOLD=$2
fi

if [ -z "$3" ]; then
    read -r -p "Proportion of covered sites in the total alignment sites.
    It will stop the optimisation process when the number of sites matching the requested coverage is at least the given proportion of total alignment sites.
    The default value is set to 90%. 
    What proportion of covered sites do you want ? (Number between 0 and 1) "
else
    MIN_NB_SITES=$3
fi

HERE=$(pwd)
# Create a progress bar function to show how we advance in the progress as it is a long process
function ProgressBar {
    # The first variable is the total number of files to iterate over
    total_files=${2}
    # The second variable calculates the percentage of advancement of the process taking into account the beginning and the end of the process to follow
    let _progress=(${1}*100/${total_files}*100)/100
    # The third variable transforms the advancement of the progress into a number between 1 and 40 to represent it using "#" in the progress bar.
    let _done=(${_progress}*10)/10
    # The _left variable takes the complementary number to 40 to be able to fill the empty spots with "-" when the progress bar is loaded
    let _left=100-$_done
    # The "_fill" and "_empty" variables are used to get the number of times we will print each character
    _fill=$(printf "%${_done}s")
    _empty=$(printf "%${_left}s")
    

    # Once all of this is done, we print the progress bar
    printf "\rFiltering : |${_fill// /█}${_empty// / }| ${_progress}%%; doing file number ${1}/${total_files}"

}

rm -r ./logs
mkdir ./logs

LIST_ORDERS="../01-AcnucFamilies/List_superkingdoms.txt"
cat $LIST_ORDERS | while read ORDER; do

    printf "\n$ORDER\n"

    rm -r $ORDER
    mkdir ./$ORDER
    LIST_FILES=$(ls $DATA_PATH$ORDER)

    # The two following variables are used to define and use the progress bar
    data_length=$(ls $DATA_PATH$ORDER | wc -l)
    counter=1
    for FILE in $LIST_FILES; do
        # We implement a progress bar to the code to follow the progress
        ProgressBar ${counter} ${data_length}

        NUM_SEQ=$(grep -c ">" $DATA_PATH$ORDER/$FILE)
        cp $DATA_PATH$ORDER/$FILE ./$ORDER/$FILE
        FAMILY_NAME=$(echo $FILE | cut -d"." -f1)
        if [[ $FAMILY_NAME = "CLU_071589_0_1"* ]]; then
            continue
        elif [[ $NUM_SEQ -gt $THRESHOLD ]]; then
            printf "\n"
            ~/Downloads/physamp/bppalnoptim param=$HERE/params.bpp \
                    input.sequence.file=$HERE/$ORDER/$FILE \
                    output.log=$HERE/logs/${ORDER}_${FAMILY_NAME}.out \
                    method=Diagnostic \
                    comparison=MaxSites
            wait
            OPTIM_THRESH=0
            while read line; do

                if [[ $line = "Iteration"* ]]; then
                    continue
                else
                    NB_SEQ_AFTER_IT=$(echo $line | cut -d" " -f4)
                    if [[ $NB_SEQ_AFTER_IT -lt $THRESHOLD ]]; then
                         let OPTIM_THRESH=$(( NB_SEQ_AFTER_IT - 1 ))
                        break
                    fi
                fi
            done < ./logs/${ORDER}_${FAMILY_NAME}.out

            echo $OPTIM_THRESH
            ~/Downloads/physamp/bppalnoptim param=$HERE/params.bpp \
                    input.sequence.file=$HERE/$ORDER/$FILE \
                    output.sequence.file=$HERE/$ORDER/${FAMILY_NAME}_out.fasta \
                    method=Auto\(min_nb_sequences=$OPTIM_THRESH,min_relative_nb_sites=${MIN_NB_SITES:-0.9}\) \
                    comparison=MaxSites
            wait
            mv ./$ORDER/${FAMILY_NAME}_out.fasta ./$ORDER/$FILE
        fi
        ((counter+=1))
    done
done


rm bppalnoptim.log