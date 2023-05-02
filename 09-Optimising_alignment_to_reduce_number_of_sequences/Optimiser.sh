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

Optimiser(){
    DATA_PATH=$1
    ORDER=$2
    FAMILY=$3
    THRESHOLD=$4
    MIN_NB_SITES=${5:-0.9}

    if [ -f "$DATA_PATH$ORDER/$FAMILY/04-Similar_sequences_removed/$FAMILY.fasta" ]; then

        mkdir $DATA_PATH$ORDER/$FAMILY/05-Optimised_alignment
        NUM_SEQ=$(grep -c ">" $DATA_PATH$ORDER/$FAMILY/04-Similar_sequences_removed/$FAMILY.fasta)

        if [[ $NUM_SEQ -gt $THRESHOLD ]]; then
            printf "\n"
            INPUT_FILE=$(readlink -f $DATA_PATH$ORDER/$FAMILY/04-Similar_sequences_removed/$FAMILY.fasta)
            OUTPUT_FILE=$(echo $(readlink -f $DATA_PATH$ORDER/$FAMILY/05-Optimised_alignment)/$FAMILY.fasta)
            ~/Downloads/physamp/bppalnoptim param=$PWD/params.bpp \
                    input.sequence.file=$INPUT_FILE \
                    output.log=$PWD/logs/${ORDER}_${FAMILY}.out \
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
            done < ./logs/${ORDER}_${FAMILY}.out

            echo $OPTIM_THRESH
            ~/Downloads/physamp/bppalnoptim param=$PWD/params.bpp \
                    input.sequence.file=$INPUT_FILE \
                    output.sequence.file=$OUTPUT_FILE \
                    method=Auto\(min_nb_sequences=$OPTIM_THRESH,min_relative_nb_sites=${MIN_NB_SITES}\) \
                    comparison=MaxSites
            wait
        else
            cp $DATA_PATH$ORDER/$FAMILY/04-Similar_sequences_removed/$FAMILY.fasta $DATA_PATH$ORDER/$FAMILY/05-Optimised_alignment
        fi
    fi
}

export -f Optimiser

rm -r ./logs
mkdir ./logs

LIST_ORDERS="../01-AcnucFamilies/List_superkingdoms.txt"
cat $LIST_ORDERS | while read ORDER; do

    LIST_FAMILIES=$(ls $DATA_PATH$ORDER)
    for FAMILY in $LIST_FAMILIES; do
        # We implement a progress bar to the code to follow the progress
        sem --jobs -0 Optimiser ${DATA_PATH} ${ORDER} ${FAMILY} ${THRESHOLD} ${MIN_NB_SITES}
    done
done


rm bppalnoptim.log