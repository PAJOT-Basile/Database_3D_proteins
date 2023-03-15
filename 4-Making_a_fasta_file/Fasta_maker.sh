# Importing variables

FOLDER=$1

# Function to extract one info
extract(){
	local COLUMN_TO_EXTRACT=$1
	local FILE=$2
	local ORDER=$3
	
	if [[ "${COLUMN_TO_EXTRACT}" == "ID" ]]; then
		cut -d';' -f1 ${FILE} > ${ORDER}_${COLUMN_TO_EXTRACT}.csv
	
	elif [[ "${COLUMN_TO_EXTRACT}" == "Classification" ]]; then
		cut -d';' -f2 ${FILE} > ${ORDER}_${COLUMN_TO_EXTRACT}.csv
	
	elif [[ "${COLUMN_TO_EXTRACT}" == "Sequence" ]]; then
		cut -d';' -f3 ${FILE} > ${ORDER}_${COLUMN_TO_EXTRACT}.csv
	
	elif [[ "${COLUMN_TO_EXTRACT}" == "Folding_data" ]]; then
		cut -d';' -f4 ${FILE} > ${ORDER}_${COLUMN_TO_EXTRACT}.csv
		
	fi
}

for FILE in $(ls $FOLDER | grep '*.csv'); do
	
	PATH_FILE="${FOLDER}${FILE}"
	ORDER=$(echo "${FILE}" | cut -d'_' -f2)
	
	for INFO in "ID Classification Sequence Folding_data"; do
		extract ${INFO} ${PATH_FILE} ${ORDER}
	done
	
	paste ${ORDER}_[ICF]* | sed 's/\t/;/g' | sed 's/^/>/g' > ${ORDER}_temporary.txt
	paste ${ORDER}_temporary.txt ${ORDER}_S* | sed 's/\t/\n/g' > ${ORDER}_sequences.fasta
done

# Cleaning up
rm *.[ct]*
