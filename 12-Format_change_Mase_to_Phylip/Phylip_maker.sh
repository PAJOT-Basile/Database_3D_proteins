#! /bin/sh

# This script takes as input the path to the database
DATA_PATH=$1

# We define a Phylip function to be used in parallel on all of the gene families we have. It takes the path to the database, the name of the
# Super-Kingdom and the gene family name to run the BppSeqMan program from the BppSuite (See doc : https://github.com/BioPP/bppsuite/tree/master)
# on the appropriate file. It returns the phylip file for each gene family in a new directory in the database
# To select only the right file, we check if the gene family folder has a "Consensus" folder
Phylip(){

    # Variable input
    DATA_PATH=$1
    ORDER=$2
    FAMILY=$3

    # If the file has a consensus folder
    if [ -d "${DATA_PATH}${ORDER}/${FAMILY}/07-Consensus" ]; then
        
        # Create the new directory where the consensus output will be stored if it does not already exist
        if [[ ! -d "${DATA_PATH}${ORDER}/${FAMILY}/08-Phylip_file" ]]; then
            mkdir ${DATA_PATH}${ORDER}/${FAMILY}/08-Phylip_file
        fi

        # The BppAlnScore takes absolute paths as input, therefore, we get the absolute paths to the files we want to analyse and the outputs
        # of the program
        INPUT_FILE=$(readlink -f ${DATA_PATH}${ORDER}/${FAMILY}/07-Consensus/${FAMILY}.mase)

        OUTPUT_FILE=$(echo $(readlink -f ${DATA_PATH}${ORDER}/${FAMILY}/08-Phylip_file)/${FAMILY}.phylip)
        # Run the BppAlnScore program.
        ~/Downloads/bppSuite/bppseqman alphabet=Protein \
                    input.alignment=yes \
                    input.sequence.file=${INPUT_FILE} \
                    input.sequence.format=Mase\(siteSelection=SPS\) \
                    input.sequence.sites_to_use=all \
                    output.sequence.file=${OUTPUT_FILE} \
                    output.sequence.format=Phylip\(order=interleaved,type=extended,split=spaces\)

    fi
}

# We export the Consensus function so it can be used in parallel
export -f Phylip
# We iterate over each gene family in each Super-Kingdom to apply the Consensus program to the appropriate file.
for ORDER in $(ls ${DATA_PATH}); do
    for FAMILY in $(ls ${DATA_PATH}${ORDER}); do
        sem --jobs -0 Phylip ${DATA_PATH} ${ORDER} ${FAMILY}
    done
done