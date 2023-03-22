# Variables
FOLDER=$1

# Path to archive
PATH_ARCHIVE="${FOLDER}final_clusters.isoforms.hogenom7.clu.bz2"

# Making a file containing all the names of the gene family in the archive
grep "^>" ${PATH_ARCHIVE} | sed 's/^>//g' > Gene_families.txt
nb_lines_archive=$(bzcat ${PATH_ARCHIVE} | wc -l)
nb_lines_names_families_archive=$(wc -l Gene_families.txt)

for FILE in $(ls $FOLDER | grep '.fam'); do

	PATH_FILE="${FOLDER}${FILE}"
	ORDER=$(echo ${FILE} | cut -d'.' -f1 | cut -d's' -f2)
	nb_lines_file=$(wc -l ${PATH_FILE})
	
	echo "${ORDER}"

	line_family_to_extract=1
	
	while [ $line_family_to_extract -le ${nb_lines_file} ]; do
	
		counter_family_names_archive=1
		
		name_family_to_extract=$(head -n $line_family_to_extract ${PATH_FILE} | tail -n1)
		# Create a new empty file
		touch Family_${ORDER}_${name_family_to_extract}.fasta
		
		while [ $counter_family_names_archive -le ${nb_lines_names_families_archive} ]; do
			
			line_list_of_families=$(head -n $counter_family_names_archive Gene_families.txt | tail -n1)
			counter_archive_file=1
			while [ ">${line_list_of_families}" != bzcat ${PATH_ARCHIVE} | head -n ${counter_archive_file} | tail -n1 ]; do
				counter_archive_file=$(( $counter_archive_file + 1 ))
			done
			
			while [ ">$(head -n $(( $counter_family_names_archive + 1 )) Gene_families.txt | tail -n1)" != bzcat ${PATH_ARCHIVE} | head -n ${counter_archive_file} | tail -n1 ]; do
				
				bzcat ${PATH_ARCHIVE} | head -n ${counter_archive_file} | tail -n1  >> Family_${ORDER}_${name_family_to_extract}.fasta
				counter_archive_file=$(( $counter_archive_file + 1 ))
			done
			counter_family_names_archive=$(( $counter_family_names_archive + 1 ))
		done
		line_family_to_extract=$(( line_family_to_extract + 1 ))
	done
done

# Cleaning up
rm *.txt
