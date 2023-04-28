#! /bin/sh

# This script takes into account the path to the database
DATA_PATH=$1

# We make a variable to have the location of this file and use it in the bppseqman program
HERE=$(pwd)

# This file contains a list of the Super-Kingdoms we are working on. We will iterate over these orders
LIST_ORDERS="../01-AcnucFamilies/List_superkingdoms.txt"
cat $LIST_ORDERS | while read ORDER; do

    echo $ORDER


    # We make a list of the gene family folders in the parallel folder. We will iterate over these files
    LIST_FAMILIES=$(ls $DATA_PATH$ORDER/)
    for FAMILY_NAME in $LIST_FAMILIES; do
        
        # If we have run the script before, we remove the output
        rm -r $DATA_PATH$ORDER/$FAMILY_NAME/02-Gaps_removed

        # We create a folder in which we will put the newly created data at the end of the gap removing
        mkdir $DATA_PATH$ORDER/$FAMILY_NAME/02-Gaps_removed

        # We copy the gene family file into the newly created folder
        cp $DATA_PATH$ORDER/$FAMILY_NAME/01-Raw_data/$FAMILY_NAME.fasta $DATA_PATH$ORDER/$FAMILY_NAME/02-Gaps_removed/$FAMILY_NAME.fasta

        # We count how many sequences we have in the gene family file
        NSEQ=$(grep -c "^>" $DATA_PATH$ORDER/$FAMILY_NAME/02-Gaps_removed/$FAMILY_NAME.fasta)

        # We use the number of sequences to define a threshold value. This threshold values gives the limit percentage of gaps to leave in 
        # the gene family file. It has to be a percentage
        THRESHOLD=$(echo 0$(echo "scale=7;1-1/$NSEQ" | bc))
        THRESH=$(echo "scale=7;$THRESHOLD*100" | bc)

        # As the bppseqman takes only qbsolute paths, we create a variable containing the absolute path to the input and output files
        INPUT_PATH=$(readlink -f $DATA_PATH$ORDER/$FAMILY_NAME/02-Gaps_removed/$FAMILY_NAME.fasta)
        OUTPUT_PATH=$(echo $(echo $INPUT_PATH | cut -d"." -f1)_out.fasta)
        
        # We execute the bppseqman program that takes into account a parameters file called params.bpp and several other informations
        # The first one is the path to the input sequence file. It has to be the absolute path to the file.
        # The second one is the absolute path to the output file. We save it in the corresponding Super-Kingdom folder
        # The last parameter is the manipulations to execute on the sequences. See bpp manual for more info: 
        # https://bioweb.pasteur.fr/docs/modules/bppsuite/0.8.0/
        ~/Downloads/bppSuite/bppseqman param=$HERE/params.bpp\
            input.sequence.file="$INPUT_PATH"\
            output.sequence.file=$OUTPUT_PATH\
            sequence.manip=CoerceToAlignment,KeepComplete\(maxGapAllowed=$THRESH%\)
        
        # Finaly, we change the name of the output file to overwrite the input file in the appropriate local Super-Kingdom folder
        mv $OUTPUT_PATH $INPUT_PATH
    done
done