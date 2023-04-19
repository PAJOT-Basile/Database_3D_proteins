#! /bin/sh

DATA_PATH=$1
HERE=$(pwd | cut -d"5" -f1)
DATA=$(echo $DATA_PATH | cut -d"/" -f2)


LIST_ORDERS="../1-AcnucFamilies/List_superkingdoms.txt"

cat $LIST_ORDERS | while read ORDER; do
    rm -r $ORDER
    echo $ORDER
    mkdir $ORDER

    LIST_FAMILIES=$(ls $DATA_PATH$ORDER/)
    for FAMILY in $LIST_FAMILIES; do
        #echo $FAMILY
        FAMILY_NAME=$(echo $FAMILY | cut -d"#" -f2)
        NSEQ=$(grep -c "^>" $DATA_PATH$ORDER/$FAMILY)
        THRESHOLD=$((1-1/$NSEQ))
        ~/Downloads/bppSuite/bppseqman param=./params.bpp\
            input.sequence.file="$HERE$DATA/$ORDER$FAMILY"\
            output.sequence.file=$HERE/$ORDER/$FAMILY_NAME.fasta\
            sequence.manip=KeepComplete\(maxGapAllowed=$THRESHOLD%\)


    done
done