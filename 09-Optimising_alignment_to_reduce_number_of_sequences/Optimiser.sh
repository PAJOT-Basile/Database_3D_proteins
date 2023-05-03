#! /bin/sh

# This script takes into account the path to the database
DATA_PATH=$1

# It also takes into account the threshold value giving the minimum number of sequences to keep in the output files in the optimised folder
# If some files have less than the chosen number of sequences, the program will just skip these files. This value can be given when calling 
# the script or can be chosen here
if [ -z "$2" ]; then
    read -r -p "Please give a threshold value to use. 
    This value will be used to stop the optimisation process of files containing more sequences than the chosen threshold value.
    What threshold value should be used ? " THRESHOLD
else
    THRESHOLD=$2
fi

# In the same way, you can chose a proportion of covered sites to have in the output file. It is used to stop the optimisation process as well
# You can chose to give it when the script is called or here. If none of these options are chosen, the default value is 90%
if [ -z "$3" ]; then
    read -r -p "Proportion of covered sites in the total alignment sites.
    It will stop the optimisation process when the number of sites matching the requested coverage is at least the given proportion of total alignment sites.
    The default value is set to 90%. 
    What proportion of covered sites do you want ? (Number between 0 and 1) " MIN_NB_SITES
    if [[ $MIN_NB_SITES = "" ]]; then
        MIN_NB_SITES=0.9
    fi
else
    MIN_NB_SITES=$3
fi

# We make an Optimiser function that takes in input the path to the database, the name of the Super-Kingdom, the gene family name, the filtering 
# threshold value and the minimum coverage percentage to keep in the optimisation process and returns the optimised fasta file for each gene family
# in a newly created folder. This optimisation process is done using the BppAlnOptim program that rmoves phyllogenetically selected sequences in the 
# alignment to get rid of sequences that do not bring any information to the alignment
Optimiser(){

    # Variable input
    DATA_PATH=$1
    ORDER=$2
    FAMILY=$3
    THRESHOLD=$4
    MIN_NB_SITES=${5}

    # If the file of the considered gene family to optimise exists, we continue. For the gene families that do not have this file, one of the 
    # previous steps did not produce any output file so the analysis will not be prolonged
    if [ -f "$DATA_PATH$ORDER/$FAMILY/04-Similar_sequences_removed/$FAMILY.fasta" ]; then

        # We create a new folder to store the optimised fasta file for each gene family
        mkdir $DATA_PATH$ORDER/$FAMILY/05-Optimised_alignment

        # We count the number of sequences in the file to optimise. If it has more sequences than the chosen threshold, we continue the optimisation
        # process and if not, we simply copy the file from the previous folder (04-Similar_sequences_removed) to the newly ceated one
        NUM_SEQ=$(grep -c ">" $DATA_PATH$ORDER/$FAMILY/04-Similar_sequences_removed/$FAMILY.fasta)
        if [[ $NUM_SEQ -gt $THRESHOLD ]]; then

            # As the BppAlnOptim program only takes into account the absolute path to files, we use variables to get these absolute paths
            INPUT_FILE=$(readlink -f $DATA_PATH$ORDER/$FAMILY/04-Similar_sequences_removed/$FAMILY.fasta)
            OUTPUT_FILE=$(echo $(readlink -f $DATA_PATH$ORDER/$FAMILY/05-Optimised_alignment)/$FAMILY.fasta)

            # We execute the BppAlnOptim program on the file from the previous folder using the threshold and coverage values selected and wait for 
            # it to finish
            ~/Downloads/physamp/bppalnoptim param=$PWD/params.bpp \
                    input.sequence.file=$INPUT_FILE \
                    output.sequence.file=$OUTPUT_FILE \
                    method=Auto\(min_nb_sequences=$THRESHOLD,min_relative_nb_sites=${MIN_NB_SITES}\) \
                    comparison=MaxSites
            wait
        else
            cp $DATA_PATH$ORDER/$FAMILY/04-Similar_sequences_removed/$FAMILY.fasta $DATA_PATH$ORDER/$FAMILY/05-Optimised_alignment
        fi
    fi
}

# We export the Optimiser function to be able to use it with sem
export -f Optimiser

# This file contains all the names of the considered Super-Kingdoms. We iterate over them
LIST_ORDERS="../01-AcnucFamilies/List_superkingdoms.txt"
cat $LIST_ORDERS | while read ORDER; do

    # In each Super-Kingdom folder in the database, we make a list of all the gene families and iterate over them. For each gene family, we 
    # execute the Optimiser function.
    LIST_FAMILIES=$(ls $DATA_PATH$ORDER)
    for FAMILY in $LIST_FAMILIES; do
        sem --jobs -0 Optimiser ${DATA_PATH} ${ORDER} ${FAMILY} ${THRESHOLD} ${MIN_NB_SITES}
    done
done

# We remove the unwanted output of the BppAlnOptim program
rm bppalnoptim.log

# Finaly, we run the Stats.sh script and the launcher.sh script from the previous steps. These scripts are slightly modified in this folder
bash ./Stats.sh "After" ../Database/
bash ./launcher.sh ../Database/