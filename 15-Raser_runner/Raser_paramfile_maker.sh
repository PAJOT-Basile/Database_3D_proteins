#! /bin/sh

DATA_PATH=$1
ORDER=$2
FAMILY=$3

if [[ -f ${FAMILY}.params ]]; then
    rm ${FAMILY}.params
fi

printf "# Inputs\n" >> ${FAMILY}.params
printf "_inSeqFile\t${DATA_PATH}${ORDER}/${FAMILY}/07-Consensus/${FAMILY}.mase\n" >> ${FAMILY}.params
printf "_inTreeFile\t${DATA_PATH}${ORDER}/${FAMILY}/10-Tree_without_bootstrap/${FAMILY}.tree\n" >> ${FAMILY}.params
printf "_modelName\tjtt\n" >> ${FAMILY}.params
printf "\n" >> ${FAMILY}.params

printf "# Outputs\n" >> ${FAMILY}.params
printf "_outResFile\t\t\t${DATA_PATH}${ORDER}/${FAMILY}/11-Raser_outputs/${FAMILY}_results_file.txt\n" >> ${FAMILY}.params
printf "_outNodesResFile\t${DATA_PATH}${ORDER}/${FAMILY}/11-Raser_outputs/${FAMILY}_nodes_results_file.txt\n" >> ${FAMILY}.params
printf "_logFile\t\t\t${DATA_PATH}${ORDER}/${FAMILY}/11-Raser_outputs/${FAMILY}_log_file.txt\n" >> ${FAMILY}.params
printf "_outTreeFile\t\t${DATA_PATH}${ORDER}/${FAMILY}/11-Raser_outputs/${FAMILY}_out_tree.ph\n" >> ${FAMILY}.params
printf "_outTreeFileWithBranchesNames\t${DATA_PATH}${ORDER}/${FAMILY}/11-Raser_outputs/${FAMILY}_out_tree.namesBS.ph\n" >> ${FAMILY}.params
printf "\n" >> ${FAMILY}.params

printf "# Running Mode\n" >> ${FAMILY}.params
printf "_numBranchesToPrint\t3\n" >> ${FAMILY}.params 