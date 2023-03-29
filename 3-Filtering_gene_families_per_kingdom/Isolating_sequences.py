# Libraries
import os as os
import sys as sys
import tqdm as tqdm

# Taking into account all the variables that have been passed on by the launcher.
order = sys.argv[1].strip("/")
data_path = sys.argv[2]
list_files = [file for file in os.listdir(os.path.join(data_path, order)) if file.endswith(".fasta")]

reference_file = [line.strip() for line in open("".join([os.path.join(data_path, order), "_sequences.mne"]), "r")]
file_sequences_families = [line.strip().replace(".", "_") for line in open("".join([os.path.join(data_path, order), "_sequences_in_families.txt"]), "r")]

intersection_of_files = list(set(reference_file) & set(file_sequences_families))

def Convert(lst):
    res_dct = {hash(lst[i]): i for i in range(len(lst))}
    return(res_dct)

hash_dict = Convert(intersection_of_files)

# Create an extractor class that will be used to extract all the needed sequences and create new files with the extracted data.
class Extractor:

    # Initialise method. It will be used to re-initialise the extractor once the sequence is done being extracted.
    def init(self):
        self.extracting = False
    
    # The "check_seqeunce" method checks if the read sequence ID is in the ".mne" file for each Super-Kingdom. 
    def check_sequence(self, line, hash_dict):
        # If the line in the ".mne" file corresponds to a line in the gene-family file, it returns True and False otherwise.
        if hash(line.strip(">").strip().replace(".", "_")) in hash_dict:
            return(True)
        else:
            return(False)

    # The "extract_sequence_name" method extracts the sequence ID from the gene-family file.
    def extract_sequence_name(self, line, directory, family_name):
        # We create a new file with the gene-family name in the appropriate Super-Kingdom folder and add the sequence ID.
        with open("#".join([os.path.join(directory, "".join(["#", family_name])), "sequences_filtered.fasta"]), "a") as f:
            f.write(line)
            f.close()
        # We set the extracting parameter to True to be able to keep extracting all the lines in the file for the matching sequences.
        self.extracting = True

    # The "extracting_sequence_line" method just opens the file of the family name and writes the sequence line to extract in the file.
    def extracting_sequence_line(self, sequence_line, directory, family_name):
        with open("#".join([os.path.join(directory, "".join(["#", family_name])), "sequences_filtered.fasta"]), "a") as f:
            f.write(sequence_line)
            f.close()


#Make the extractor object and initialise it.
extractor = Extractor()
extractor.init()

# Open the paths to the files. The first one is the file containing all the sequences for one family and the second
# one contains all the sequence IDs for a Super-Kingdom.

#file_number = 1
length_list_files = len(list_files)
for name_file_to_test in tqdm.tqdm(list_files):

    file_to_test = open(os.path.join(data_path, order, name_file_to_test), "r")
    # Taking out the family name of the gene family we are treating here.
    family_name = name_file_to_test.split("#")[1]

    # This loop iterates over each line in the gene family file. It tests several parameters. Each new sequence strats with ">". Therefore, for each
    # line like this we will test if the sequence ID matches one from the ".mne" file.
    for line in file_to_test:

        # If the line starts with ">" and we are extracting, we have finished extracting one sequence and we are looking at a new one. We have to 
        # test if the we want to extract the sequence. If the test is positive, we keep going. If not, we re-initailise the extractor and keep moving
        # forward in the file.
        if line.startswith(">") and extractor.extracting:
            extractor.init()
        
        # If the line starts with ">", and we are not extracting, it means that we have a sequence ID to test. If the test is positive, we extract the
        # sequence name. If not, we continue.
        if line.startswith(">") and not extractor.extracting:
            if extractor.check_sequence(line, hash_dict):
                extractor.extract_sequence_name(line, order, family_name)
        
        # If the line does not start with ">" and we are extracting, we are in the middle of a sequence. Therefore, we extract the line.
        if not line.startswith(">") and extractor.extracting:
            extractor.extracting_sequence_line(line, order, family_name)

    #print(f"Done with file number {file_number} out of {length_list_files}")
    #file_number += 1
