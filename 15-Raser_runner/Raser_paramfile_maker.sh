#! /bin/sh

# Variable input
DATA_PATH=$1
ORDER=$2
FAMILY=$3

# If the param files already exist localy, we remove to prevent ourselves from adding lines to the params file indefinitely.
if [[ -f ${FAMILY}.params ]]; then
    rm ${FAMILY}.params
fi

# We add the inputs. It takes into account the path to the multiple alignment and the tree file of the selected gene family
# We also select the model to use
printf "# Inputs\n" >> ${FAMILY}.params
printf "_inSeqFile\t${DATA_PATH}${ORDER}/${FAMILY}/07-Consensus/${FAMILY}.mase\n" >> ${FAMILY}.params
printf "_inTreeFile\t${DATA_PATH}${ORDER}/${FAMILY}/10-Tree_without_bootstrap/${FAMILY}.tree\n" >> ${FAMILY}.params
printf "_modelName\tjtt\n" >> ${FAMILY}.params
printf "\n" >> ${FAMILY}.params

# We add the names of the output files. All these files are not necessary for the rest of the project but some are useful
printf "# Outputs\n" >> ${FAMILY}.params
printf "_outResFile\t\t\t${DATA_PATH}${ORDER}/${FAMILY}/11-Raser_outputs/${FAMILY}_results_file.txt\n" >> ${FAMILY}.params
printf "_outNodesResFile\t${DATA_PATH}${ORDER}/${FAMILY}/11-Raser_outputs/${FAMILY}_nodes_results_file.txt\n" >> ${FAMILY}.params
printf "_logFile\t\t\t${DATA_PATH}${ORDER}/${FAMILY}/11-Raser_outputs/${FAMILY}_log_file.txt\n" >> ${FAMILY}.params
printf "_outTreeFile\t\t${DATA_PATH}${ORDER}/${FAMILY}/11-Raser_outputs/${FAMILY}_out_tree.ph\n" >> ${FAMILY}.params
printf "_outTreeFileWithBranchesNames\t${DATA_PATH}${ORDER}/${FAMILY}/11-Raser_outputs/${FAMILY}_out_tree.namesBS.ph\n" >> ${FAMILY}.params
printf "\n" >> ${FAMILY}.params

# We chose which runnning mode to use
printf "# Running Mode\n" >> ${FAMILY}.params
printf "_numBranchesToPrint\t3\n" >> ${FAMILY}.params 