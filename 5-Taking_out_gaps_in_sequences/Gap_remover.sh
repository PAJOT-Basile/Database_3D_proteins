#! /bin/sh

# This script takes into account the path to the folder to transform
DATA_PATH=$1

# We create a variable taking into account the absolute path to this folder because bppseqman needs the absolute path to the data
HERE=$(pwd)

# This file contains a list of the Super-Kingdoms we are working on. We will iterate over these orders
LIST_ORDERS="../1-AcnucFamilies/List_superkingdoms.txt"
cat $LIST_ORDERS | while read ORDER; do

    # If we have run the script before, we remove the output
    rm -r $ORDER
    echo $ORDER

    # We create a folder per Super-Kingdomm to store the gene family files
    mkdir $ORDER

    # We make a list of the gene family files in the parallel folder. We will iterate over these files
    LIST_FAMILIES=$(ls $DATA_PATH$ORDER/)
    for FAMILY in $LIST_FAMILIES; do

        # We extract the family name from the name of the gene family file
        FAMILY_NAME=$(echo $FAMILY | cut -d"#" -f2)

        # We copy and rename the gene family file into the local Super-Kingdom folder
        cp $DATA_PATH$ORDER/$FAMILY ./$ORDER/$FAMILY_NAME.fasta

        # We count how many sequences we have in the gene family file
        NSEQ=$(grep -c "^>" ./$ORDER/$FAMILY_NAME.fasta)

        # We use the number of sequences to define a threshold value. This threshold values gives the limit percentage of gaps to leave in the gene
        # family file. It has to be a percentage
        THRESHOLD=$(echo 0$(echo "scale=7;1-1/$NSEQ" | bc))
        THRESH=$(echo "scale=7;$THRESHOLD*100" | bc)

        # We execute the bppseqman program that takes into account a parameters file called params.bpp and several other informations
        # The first one is the path to the input sequence file. It has to be the absolute path to the file.
        # The second one is the absolute path to the output file. We save it in the corresponding Super-Kingdom folder
        # The last parameter is the manipulations to execute on the sequences. See bpp manual for more info: https://bioweb.pasteur.fr/docs/modules/bppsuite/0.8.0/
        ~/Downloads/bppSuite/bppseqman param=./params.bpp\
            input.sequence.file="$HERE/$ORDER/$FAMILY_NAME.fasta"\
            output.sequence.file=$HERE/$ORDER/${FAMILY_NAME}_out.fasta\
            sequence.manip=CoerceToAlignment,KeepComplete\(maxGapAllowed=$THRESH%\)
        
        # Finaly, we change the name of the output file to overwrite the input file in the appropriate local Super-Kingdom folder
        mv ./$ORDER/${FAMILY_NAME}_out.fasta ./$ORDER/$FAMILY_NAME.fasta
    done
done