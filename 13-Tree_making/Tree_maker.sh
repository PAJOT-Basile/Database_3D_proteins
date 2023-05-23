#! /bin/sh

#SBATCH --time=24:00:00
#SBATCH --mem=20G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1
#SBATCH --array=1-2000%15
#SBATCH --output=./logs/run1/slurm_%j_%a.out

# We take the path to the database as an argument
DATA_PATH=$1

# This file contains a list of all the gene families and the Super-Kingdom they are a part of. We will iterate over it using a slurm array
LIST_FAMILIES="List_gene_families.xtxt"

# We take into account the path to the gene family once in the database and extract the name of the order and gene family
FAMILY_PATH=$(cat ${LIST_FAMILIES} | head -n ${SLURM_ARRAY_TASK_ID} | tail -n1)

echo ${FAMILY_PATH}

# We extract the name of the Super-Kingdom and gene family from this variable
ORDER=$(echo ${FAMILY_PATH} | cut -d"/" -f1)
FAMILY=$(echo ${FAMILY_PATH} | cut -d"/" -f2)

echo ${FAMILY}

# If the considered gene family has a Phylip file folder, we run the phyml program to do a tree of this phylip file
if [[ -d "${DATA_PATH}${FAMILY_PATH}/08-Phylip_file" ]]; then

    # We create a folder in which the output files will be stored if it does not already exist
    if [[ ! -d "${DATA_PATH}${FAMILY_PATH}/09-PhyML_tree" ]]; then
        mkdir ${DATA_PATH}${FAMILY_PATH}/09-PhyML_tree
    fi

    # We run the PhyML program
    ~/Downloads/phyml-3.3.20220408/src/phyml --input ${DATA_PATH}${FAMILY_PATH}/08-Phylip_file/${FAMILY}.phylip \
                    -d aa \
                    -m LG \
                    -f m \
                    --quiet \
                    --no_memory_check

    # The output files of the PhyML program are stored in the Phylip file folder so we move them to the newly creted folder
    mv ${DATA_PATH}${FAMILY_PATH}/08-Phylip_file/${FAMILY}.phylip_* ${DATA_PATH}${FAMILY_PATH}/09-PhyML_tree

fi

echo "Done !"