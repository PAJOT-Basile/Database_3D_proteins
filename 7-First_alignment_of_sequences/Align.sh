#! /bin/sh

# Nettoyage dans la phase de debeugage
rm -r ../0-tests/Database/*/*/2-* ./Alignment_speeds.csv
# On prends en entree le chemin relatif vers la base de donnees
DATA_PATH=$1

# Ceci est un fichier qui contient les ordres (c'est une liste avec Archaea, Bacteria et Eukaryota. On fait une boucle sur ces trois ordres.)
LIST_ORDERS="../1-AcnucFamilies/List_superkingdoms.txt"
cat ${LIST_ORDERS} | while read ORDER; do

    # On fait une liste des familles de genes sur lesquelles on va passer par la suite dans chacun des ordres
    LIST_FAMILIES=$(ls ${DATA_PATH}${ORDER}/)
    for FAMILY in ${LIST_FAMILIES}; do

        # On fabrique un directory pour stocker les sequences alignees apres cette etape.
        mkdir ${DATA_PATH}${ORDER}/${FAMILY}/2-Rough_alignment
        # Si le fichier csv suivant existe, on continue, sinon on le cree. Il va prendre differents parametres sur les seqeunces pour faire des analyses sur la vitesse d'alignement si besoin
        if test -f "./Alignment_speeds.csv"; then
            continue
        else
            echo "Number_sequences;Minimum_seq_length;Maximum_seq_length;Mean_seq_length;Clustal_Omega;Seq_length_after_alignment" >> ./Alignment_speeds.csv
        
        # On prends la date avant et apres avoir lance l'alignement.
        time_before=$(date "+%d%H%M%S")
        # On lance l'alignement sur le fichier fasta contenu dans Raw_data dans la base de donnees et on range le output dans le nouveau dossier cree pour cela
        clustalo --in=${DATA_PATH}${ORDER}/${FAMILY}/1-Raw_data/${FAMILY}.fasta --out=${DATA_PATH}${ORDER}/${FAMILY}/2-Rough_alignment/${FAMILY}_aligned.fasta
        wait
        echo $time_after
        # On mesure la difference de temps entre avant et apres pour calculer la duree
        time_difference=$(( time_after - time_before ))
        echo $time_difference
        # Puis on lance un script python qui va completer le fichier csv.
        python3 timer.py ${DATA_PATH}${ORDER}/${FAMILY}/ $time_difference
        fi
    done
done