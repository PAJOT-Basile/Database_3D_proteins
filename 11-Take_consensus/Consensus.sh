#! /bin/sh

# This script takes as input the path to the database
DATA_PATH=$1

# Here, we ask the user to define a threshold value on the sites to conserve in the consensus. It will only add sites having a bigger SPS 
# (Sum of Pair Score) than the threshold value selected
if [ -z "$2" ]; then
    read -r -p "Please give a threshold value to use. 
    This value will be used to select the sites to conserve. All positions that have at least the threshold value will be included in the selection.
    The default value is 0.8.
    What threshold value should be used ? " THRESHOLD
    if [[ $THRESHOLD = "" ]]; then
        THRESHOLD=0.8
    fi
else
    THRESHOLD=$2
fi

# We define a Consensus function to be used in parallel on all of the gene families we have. It takes the path to the database, the name of the
# Super-Kingdom and the threshold value as inputs and runs the BppAlnScore program from the BppSuite (See doc : https://github.com/BioPP/bppsuite/tree/master)
# on the aprropriate file. It returns the consensus of two alignment methods into a new directory in the database. As some gene families did not get aligned 
# using always the same method (Prank did not work for every sequence), we distinguish the cases where the file is aligned using Prank or where it is 
# aligned using Mafft
# To select only the right file, we check if the gene family folder has an "_alignment" folder
Consensus(){

    # Variable input
    DATA_PATH=$1
    ORDER=$2
    FAMILY=$3
    THRESHOLD=$4

    # If the file was aligned using Prank
    if [ -d "${DATA_PATH}${ORDER}/${FAMILY}/06-Muscle_alignment" ] && [ -d "${DATA_PATH}${ORDER}/${FAMILY}/06-Prank_alignment" ]; then
        
        # Create the new directory where the consensus output will be stored
        mkdir ${DATA_PATH}${ORDER}/${FAMILY}/07-Consensus

        # The BppAlnScore takes absolute paths as input, therefore, we get the absolute paths to the files we want to analyse and the outputs.
        # of the program
        INPUT_REF=$(readlink -f ${DATA_PATH}${ORDER}/${FAMILY}/06-Muscle_alignment/${FAMILY}.fasta)
        INPUT_TEST=$(readlnk -f ${DATA_PATH}${ORDER}/${FAMILY}/06-Prank_alignment/${FAMILY}.fasta.best.fas)

        OUTPUT_SCORES=$(echo $(readlink -f ${DATA_PATH}${ORDER}/${FAMILY}/07-Consensus)/${FAMILY}_scores.txt)
        OUTPUT_MASE=$(echo $(readlink -f ${DATA_PATH}${ORDER}/${FAMILY}/07-Consensus)/${FAMILY}.mase)

        # Run the BppAlnScore program
        ~/Downloads/bppSuite/bppalnscore alphabet=Protein \
                    input.sequence.file.test=${INPUT_TEST} \
                    input.sequence.format.test=Fasta \
                    input.sequence.file.ref=${INPUT_REF} \
                    input.sequence.format.test=Fasta \
                    output.scores=${OUTPUT_SCORES} \
                    ouptut.mase=${OUTPUT_MASE} \
                    output.sps_threshold=${THRESHOLD}
    
    # If the file is aligned using Mafft
    elif [ -d "${DATA_PATH}${ORDER}/${FAMILY}/06-Muscle_alignment" ] && [ -d "${DATA_PATH}${ORDER}/${FAMILY}/06-Mafft_alignment" ]; then

        mkdir ${DATA_PATH}${ORDER}/${FAMILY}/07-Consensus

        INPUT_REF=$(readlink -f ${DATA_PATH}${ORDER}/${FAMILY}/06-Muscle_alignment/${FAMILY}.fasta)
        INPUT_TEST=$(readlnk -f ${DATA_PATH}${ORDER}/${FAMILY}/06-Mafft_alignment/${FAMILY}.fasta)

        OUTPUT_SCORES=$(echo $(readlink -f ${DATA_PATH}${ORDER}/${FAMILY}/07-Consensus)/${FAMILY}_scores.txt)
        OUTPUT_MASE=$(echo $(readlink -f ${DATA_PATH}${ORDER}/${FAMILY}/07-Consensus)/${FAMILY}.mase)

        ~/Downloads/bppSuite/bppalnscore alphabet=Protein \
                    input.sequence.file.test=${INPUT_TEST} \
                    input.sequence.format.test=Fasta \
                    input.sequence.file.ref=${INPUT_REF} \
                    input.sequence.format.test=Fasta \
                    output.scores=${OUTPUT_SCORES} \
                    ouptut.mase=${OUTPUT_MASE} \
                    output.sps_threshold=${THRESHOLD}
    fi
}

# We export the Consensus function so it can be used in parallel
export Consensus

# We iterate over each gene ffamily in each Super-Kingdom to apply the Consensus program to the appropriate file
for ORDER in $(ls ${DATA_PATH}); do
    for FAMILY in $(ls ${DATA_PATH}${ORDER}); do
        sem --jobs -0 Consensus ${DATA_PATH} ${ORDER} ${FAMILY} ${THRESHOLD}
    done
done