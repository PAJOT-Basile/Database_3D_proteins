#! /bin/sh

# Importing variables

FOLDER=$1

for FILE in $(ls $FOLDER | grep '.csv'); do
	
	PATH_FILE="${FOLDER}${FILE}"
	ORDER=$(echo "${FILE}" | cut -d'_' -f2)
	echo ${ORDER}
	
	for INFO in ID Classification Sequence Folding_data; do
		if [[ "${INFO}" = "ID" ]]; then
			cut -d';' -f1 ${PATH_FILE} > ${ORDER}_${INFO}.csv
	
		elif [[ "${INFO}" = "Classification" ]]; then
			cut -d';' -f2 ${PATH_FILE} > ${ORDER}_${INFO}.csv
	
		elif [[ "${INFO}" = "Sequence" ]]; then
			cut -d';' -f3 ${PATH_FILE} > ${ORDER}_${INFO}.csv
	
		elif [[ "${INFO}" = "Folding_data" ]]; then
			cut -d';' -f4 ${PATH_FILE} > ${ORDER}_${INFO}.csv
		
		fi
	done
	
	paste ${ORDER}_ID.csv ${ORDER}_Classification.csv ${ORDER}_Folding_data.csv | sed 's/\t/;/g' | sed 's/^/>/g' > ${ORDER}_temporary.txt
	paste ${ORDER}_temporary.txt ${ORDER}_S* | sed 's/\t/\n/g' | tail -n+3 > ${ORDER}_sequences.fasta
done

# Cleaning up
rm *.csv *.txt
