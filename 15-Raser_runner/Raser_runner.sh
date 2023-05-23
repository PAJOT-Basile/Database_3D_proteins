#! /bin/sh

DATA_PATH=$1

for ORDER in $(ls ${DATA_PATH}); do
    for FAMILY in $(ls ${DATA_PATH}${ORDER}); do

        if [[ -d "${DATA_PATH}${ORDER}/${FAMILY}/10-Tree_without_bootstrap" ]]; then

            if [[ ! -d "${DATA_PATH}${ORDER}/${FAMILY}/11-Raser_outputs" ]]; then
                mkdir ${DATA_PATH}${ORDER}/${FAMILY}/11-Raser_outputs
            fi

            echo ${ORDER}/${FAMILY}
            bash ./Raser_paramfile_maker.sh ${DATA_PATH} ${ORDER} ${FAMILY}
            wait

            ~/Downloads/RaserDir/programs/raser/raser ${FAMILY}.params
            wait 

            mv ${FAMILY}.params ${DATA_PATH}${ORDER}/${FAMILY}/11-Raser_outputs/

        fi
    done
done