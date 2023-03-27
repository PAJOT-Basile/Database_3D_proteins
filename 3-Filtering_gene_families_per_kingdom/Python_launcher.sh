#! /bin/bash

#BATCH --ntasks=1
#BATCH --cpus-per-task=2
#BATCH --array=1-25
#BATCH -o Output.txt


DATA_PATH=$1
ORDER=$2
FAMILY=$3

python3 test.py $ORDER $DATA_PATH $FAMILY
