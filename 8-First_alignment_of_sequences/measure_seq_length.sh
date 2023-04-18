#! /bin/sh

DATA_PATH=$1

extracting="no"
echo $extracting
cat $DATA_PATH | while read line; do

    if [[ $line = ">"*  ]] && [[ $extracting = "no" ]]; then
		extracting="yes"
    elif [[ $line != ">"* ]] && [[ $extracting = "y"* ]]; then
        echo $line | tr "\n" " " | sed "s/^/\n/g" >> sequences.txt
    elif [[ $line = ">"* ]] && [[ $extracting = "y"* ]]; then
        break
    fi
done

# We take out the first line of the file given with the method used earlier, we added a back to the line at the beginning of every 
# first sequence line. Therefore, the first line of the file is an empty line
echo "$(tail -n+2 sequences.txt | sed 's/ //g')" > sequences.txt
cat sequences.txt | while read line; do
	return ";${#line}"
done