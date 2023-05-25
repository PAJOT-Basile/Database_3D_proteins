#! /bin/sh

#SBATCH --time=5-00:00:00
#SBATCH --mem=20G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1
#SBATCH --array=1-1964%20
#SBATCH --output=./logs/run1/slurm_%j_%a.out

# We take the path to the database as an argument
DATA_PATH=$1

# This file contains a list of all the gene families and the Super-Kingdom they are a part of. We will iterate over it using a slurm array.
LIST_FAMILIES="List_gene_families.xtxt"

# We take into account the path to the gene family once in the database and extract the name of the order and gene family
FAMILY_PATH=$(cat ${LIST_FAMILIES} | head -n ${SLURM_ARRAY_TASK_ID} | tail -n1)

echo ${FAMILY_PATH}

# We extract the name of the Super-Kingdom and gene family from this variable
ORDER=$(echo ${FAMILY_PATH} | cut -d"/" -f1)
FAMILY=$(echo ${FAMILY_PATH} | cut -d"/" -f2)

echo ${FAMILY}

# If the tree without bootstrap exists, then we make the directory in which the outputs and the param file will be stored
if [[ -d "${DATA_PATH}${ORDER}/${FAMILY}/10-Tree_without_bootstrap" ]]; then

    # If the storing folder does not exist, we create it
    if [[ ! -d "${DATA_PATH}${ORDER}/${FAMILY}/11-Raser_outputs" ]]; then
        mkdir ${DATA_PATH}${ORDER}/${FAMILY}/11-Raser_outputs
    fi

    # We run the Raser_paramfile_maker.sh script allowing us to make the file containing the parameters to run the Raser program
    bash ./Raser_paramfile_maker.sh ${DATA_PATH} ${ORDER} ${FAMILY}
    wait

    # We run the Raser program
     ~/Downloads/RaserDir/programs/raser/raser ${FAMILY}.params
    wait 

    # We move the params file to the output storage folder.
    mv ${FAMILY}.params ${DATA_PATH}${ORDER}/${FAMILY}/11-Raser_outputs/

fi