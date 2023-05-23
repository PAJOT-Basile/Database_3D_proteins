# Libraries
import os as os
import sys as sys
import tqdm as tqdm
import subprocess as subprocess

# Taking in the variables

data_path = sys.argv[1]

# We create a function that converts a list into a hash dictionnary that takes the hash of each gene family ID as a key
def Convert(lst):
    res_dct = {hash(lst[i]): i for i in range(len(lst))}
    return(res_dct)

list_orders = open("../01-AcnucFamilies/List_superkingdoms.txt", "r")

for ORDER in list_orders:
    order = ORDER.replace("\n", "")
    print(order)
    list_families = list(os.popen("".join(["tail -n+2 ", order, "_pdbs.csv | cut -d';' -f1 | sed 's/\.//g'"])).read().split("\n"))

    dict_families = Convert(list_families)

    list_families_database = [file for file in os.listdir(os.path.join(data_path, order))]

    for family in tqdm.tqdm(list_families_database):
        if hash(family) in dict_families:
            if os.path.isdir(os.path.join(data_path, order, family, "06-Muscle_alignment")):
                subprocess.call(" ".join(["bash ./Copier.sh", data_path, order, family]), shell=True)
                    

