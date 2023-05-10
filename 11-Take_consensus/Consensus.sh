#! /bin/sh

DATA_PATH=$1

# See doc : https://github.com/BioPP/bppsuite/tree/master
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

Consensus(){

    # Variable input.
    DATA_PATH=$1
    ORDER=$2
    FAMILY=$3
    THRESHOLD=$4

    if [ -d "${DATA_PATH}${ORDER}/${FAMILY}/06-Muscle_alignment" ] && [ -d "${DATA_PATH}${ORDER}/${FAMILY}/06-Prank_alignment" ]; then
        
        mkdir ${DATA_PATH}${ORDER}/${FAMILY}/07-Consensus

        INPUT_REF=$(readlink -f ${DATA_PATH}${ORDER}/${FAMILY}/06-Muscle_alignment/${FAMILY}.fasta)
        INPUT_TEST=$(readlnk -f ${DATA_PATH}${ORDER}/${FAMILY}/06-Prank_alignment/${FAMILY}.fasta.best.fas)

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



export Consensus

for ORDER in $(ls ${DATA_PATH}); do
    for FAMILY in $(ls ${DATA_PATH}${ORDER}); do
        sem --jobs -0 Consensus ${DATA_PATH} ${ORDER} ${FAMILY} ${THRESHOLD}
    done
done