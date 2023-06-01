#! /bin/sh

# We take into account the path to the database
DATA_PATH=$1

# We make a Presentation function to see at which gene family we are each time we start a new one
Presentation(){
    # Variable input. It takes as argument the gene family name
    family=$1
    # We calculate the length of the gene family name and set the lengths of the top line and number of spaces between the gene family 
    # name and the frame. We also transfrom the ones that we can into a machine-comprehensible format
    len_fam=${#family}
    _ref_len=100
    _space_len=6
    _part_fill=""
    _fill_char="-"
    _ref_fill=$(printf "%${_ref_len}s")
    _space_fill=$(printf "%${_space_len}s")
    # We distinguish the case of an even or odd number of characters in the gene family name to calculate the length of the sides of
    # the frame
    if [[ $(expr ${len_fam} % 2) -eq 0 ]]; then
        # We calculate how many blocks are to be seen on the sides of the frame
        _part_line_d=$((${_ref_len} - ${len_fam} - 2*${_space_len}))
        # We calculate how many blocks are to be seen on each side of the frame
        _part_line=$(echo "$_part_line_d / 2" | bc)
        # We transform this into a machine-comprehensible format
        _part_fill=$(printf "%${_part_line}s")
        # We print the output
        printf "\n${_ref_fill// /${_fill_char}}\n${_part_fill// /${_fill_char}}${_space_fill// / }${family}${_space_fill// / }${_part_fill// /${_fill_char}}\n${_ref_fill// /${_fill_char}}\n"
    else
        # For the odd part, we separate the left and right parts of the frame to simplify this
        _part_line_d=$((${_ref_len} - ${len_fam} - 2*${_space_len}-1))
        _part_line_left=$(echo "($_part_line_d / 2) + 1" | bc)
        _part_fill_left=$(printf "%${_part_line_left}s")
        _part_line_right=$(echo "($_part_line_d / 2)" | bc)
        _part_fill_right=$(printf "%${_part_line_right}s")
        printf "\n${_ref_fill// /${_fill_char}}\n${_part_fill_left// /${_fill_char}}${_space_fill// / }${family}${_space_fill// / }${_part_fill_right// /${_fill_char}}\n${_ref_fill// /${_fill_char}}\n"
    fi
}

# We export the Presentation function to be able to parallelise the work
export -f Presentation

# We define a Translate function to parallelise the work for several gene families at once
Translate(){

    # Variable input
    DATA_PATH=$1
    ORDER=$2
    FAMILY=$3

    # If the considered gene family has an index file and a SGED file comming fromthe raser conversion, we can run this step
    if [[ -f "${DATA_PATH}${ORDER}/${FAMILY}/12-Pdb_information/${FAMILY}_sged.csv" ]] &&  [[ -f "${DATA_PATH}${ORDER}/${FAMILY}/12-Pdb_information/${FAMILY}_index.txt" ]]; then

            # We implement the Presentation function
            Presentation ${FAMILY}

            # If the folder 13-Structure_info does not exist, we create it
            if [[ ! -d "${DATA_PATH}${ORDER}/${FAMILY}/13-Structure_info" ]]; then
                mkdir ${DATA_PATH}${ORDER}/${FAMILY}/13-Structure_info
            fi

            # We extract the chain reference used for the index and the name of PDB reference file used for the index file
            CHAIN=$(head -n5 ${DATA_PATH}${ORDER}/${FAMILY}/12-Pdb_information/${FAMILY}_index.txt | tail -n1 | cut -d" " -f7)
            TMPPDB=$(head -n4 ${DATA_PATH}${ORDER}/${FAMILY}/12-Pdb_information/${FAMILY}_index.txt | tail -n1 | cut -d" " -f6)
            PDB_REF=$(echo $(echo "${TMPPDB#./pdb}" | sed "s/\.ent//g").pdb)


            # We run the sged-translate-coords.py script that modifies the coordinates of the sged file according to the alignment index 
            # positions 
            echo "Translating coordinates ..."
            python3 ~/Downloads/sgedtools/src/sged-translate-coords.py \
                -s ${DATA_PATH}${ORDER}/${FAMILY}/12-Pdb_information/${FAMILY}_sged.csv \
                -i ${DATA_PATH}${ORDER}/${FAMILY}/12-Pdb_information/${FAMILY}_index.txt \
                -o ${DATA_PATH}${ORDER}/${FAMILY}/13-Structure_info/${FAMILY}_translated_coords.csv \
                -n PDB

            # We run the sged-structure-infos.py script that allows us to get some 3D information from the PDB reference file and to add it to
            # the sged file.
            echo "Getting 3D structure information ..."
            python3 ~/Downloads/sgedtools/src/sged-structure-infos.py \
                -s ${DATA_PATH}${ORDER}/${FAMILY}/13-Structure_info/${FAMILY}_translated_coords.csv \
                -p ${DATA_PATH}${ORDER}/${FAMILY}/12-Pdb_information/${PDB_REF} \
                -f PDB \
                -g PDB \
                -a ${CHAIN} \
                -m DSSP \
                -o ${DATA_PATH}${ORDER}/${FAMILY}/13-Structure_info/${FAMILY}_structinfos.csv
    fi
}

# We export the Translate function to be able to paralellise the jobs
export -f Translate

# We iterate over the gene families in the database and run the Translate function
for ORDER in $(ls ${DATA_PATH}); do
    for FAMILY in $(ls ${DATA_PATH}${ORDER}); do
        sem --jobs -0 Translate ${DATA_PATH} ${ORDER} ${FAMILY}
    done
done