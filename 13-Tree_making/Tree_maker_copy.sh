#! /bin/sh


# We take the path to the database as an argument
DATA_PATH=$1

# This file contains a list of all the gene families and the Super-Kingdom they are a part of. We will iterate over it using a slurm array
LIST_FAMILIES="List_gene_families.xtxt"

for ORDER in  $(ls ${DATA_PATH}); do
    for FAMILY in $(ls $DATA_PATH$ORDER); do

        echo ${FAMILY}

        # If the considered gene family has a Phylip file folder, we run the phyml program to do a tree of this phylip file
        if [[ -d "${DATA_PATH}$ORDER/${FAMILY}/08-Phylip_file" ]]; then

            # We create a folder in which the output files will be stored if it does not already exist
            if [[ ! -d "${DATA_PATH}$ORDER/${FAMILY}/09-PhyML_tree" ]]; then
                mkdir ${DATA_PATH}$ORDER/${FAMILY}/09-PhyML_tree
            fi

            # We run the PhyML program
            sem --jobs -0 ~/Downloads/phyml-3.3.20220408/src/phyml --input ${DATA_PATH}$ORDER/${FAMILY}/08-Phylip_file/${FAMILY}.phylip \
                            -d aa \
                            -m LG \
                            -f m \
                            --quiet \
                            --no_memory_check
            wait
            # The output files of the PhyML program are stored in the Phylip file folder so we move them to the newly creted folder
            mv ${DATA_PATH}$ORDER/${FAMILY}/08-Phylip_file/${FAMILY}.phylip_* ${DATA_PATH}$ORDER/${FAMILY}/09-PhyML_tree

        fi
    done
done

echo "Done !"