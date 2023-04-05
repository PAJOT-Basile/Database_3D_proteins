# Libraries
import sys as sys
import pandas as pd
import tqdm as tqdm

# This file uses the path to the file to analyse as input. It must be a csv file and have semicolons as separators
File_path=sys.argv[1]

# Read the input file
data=pd.read_csv(File_path, delimiter=";")

# Make a function transforming the dataframe into a dictionary to search it more rapidly
def Convert(df):
    res_dct = {df["Sequence_name"][i]: df["Length"][i] for i in range(len(df.index))}
    return(res_dct)

# Convert the input file into a dictionary containing the name of the sequence as key and the sequence length as value
dict=Convert(data)
# Taking the first value of the sequence length as reference
length_of_sequence=data["Length"][0]

# We iterate over each line in the dataframe to compare the sequence length to the one chosen as reference.
for counter, _ in tqdm.tqdm(enumerate(data.index)):

    # If the length of the sequence is not the same, we print the sequence name
    if data["Length"][counter] != length_of_sequence:
        print(dict.keys()[dict.values().index(data["Length"][counter])])