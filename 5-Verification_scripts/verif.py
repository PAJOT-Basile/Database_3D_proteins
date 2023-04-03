# Libraries
import sys as sys
import os as os
import pandas as pd
import tqdm as tqdm

File_path=sys.argv[1]

data=pd.read_csv(File_path, delimiter=";")

def Convert(df):
    res_dct = {df["Length"][i]: df["Sequence_name"][i] for i in range(len(df.index))}
    return(res_dct)

dict=Convert(data)
length_of_sequence=data["Length"][0]

for counter, _ in tqdm.tqdm(enumerate(data.index)):

    if data["Length"][counter] != length_of_sequence:
        print(dict[data["Length"][counter]])