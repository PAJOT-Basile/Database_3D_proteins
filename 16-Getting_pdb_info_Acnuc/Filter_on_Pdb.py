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

# This file contains the list of all the Super-Kingdoms to analyse here
list_orders = open("../01-AcnucFamilies/List_Archaea.txt", "r")

# We iterate over the Super-Kingdoms
for ORDER in list_orders:
    # We take out the Super-Kingdom name
    order = ORDER.replace("\n", "")
    print(order)
    # We make a list of all the gene families that have a pdb structure in the previously made csv file
    list_families = list(os.popen("".join(["tail -n+2 ", order, "_pdbs.csv | cut -d';' -f1 | sed 's/\.//g'"])).read().split("\n"))

    # We transform this list into a dictionnary to search it more rapidly
    dict_families = Convert(list_families)

    # We make a list of all the gene families that we have in the database
    list_families_database = [file for file in os.listdir(os.path.join(data_path, order))]

    # We iterate over each gene family in the database and check if it is in the dictionnary. Theoretically, it should be but 
    # it is preferable to re-check.
    for family in tqdm.tqdm(list_families_database):
        if hash(family) in dict_families:
            # If the families in the database that are in the csv file have a raser output, then we use the Copier.sh to
            # copy the corresponding pdb information to the database.
            if os.path.isfile(os.path.join(data_path, order, family, "11-Raser_outputs", "".join([family, "_results_file.txt"]))):
                subprocess.call(" ".join(["bash ./Copier.sh", data_path, order, family]), shell=True)
                    

