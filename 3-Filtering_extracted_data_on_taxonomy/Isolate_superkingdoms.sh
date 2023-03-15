# Variable importation

FOLDER=$1
ORDERS="Bacteria Eukaryota Archaea Rest"

for FILE in $(ls $FOLDER | grep '.csv'); do
	
	PATH_TO_FILE="${FOLDER}${FILE}"
	ORDER=$(echo "${FILE}" | cut -d'_' -f2)
	echo "Extracting ${ORDER} from:"

	for NAME in ${ORDERS}; do
	
		echo "     ${NAME}"
	
		if [[ "${NAME}" = "Rest" ]]; then 
			grep -Ev 'Bacteria|Eukaryota|Archaea' ${PATH_TO_FILE} > Rest_from_Families_${ORDER}_Sequences_Extracted.csv
		else
			grep "${NAME}" ${PATH_TO_FILE} > ${NAME}_from_Families_${ORDER}_Sequences_Extracted.csv
		fi
	done
done


for ORDER in ${ORDERS}; do
	if [[ "${ORDER}" = "Rest" ]]; then
		cat ${ORDER}_* > ${ORDER}_1
		grep -v "^ID" ${ORDER}_1* > ${ORDER}_2
		sort ${ORDER}_1 | uniq > Only_${ORDER}_Extracted_Sequences.csv
		sed -i $"1s/^/ID;Classification;Sequence;Folding data\n/" Only_${ORDER}_Extracted_Sequences.csv
	else
		cat ${ORDER}_* > ${ORDER}_1
		sort ${ORDER}_1 | uniq > Only_${ORDER}_Extracted_Sequences.csv
		sed -i $"1s/^/ID;Classification;Sequence;Folding data\n/" Only_${ORDER}_Extracted_Sequences.csv
	fi
done

# Removing the construction files
rm Bacteria* Eukaryota* Archaea* Rest*
