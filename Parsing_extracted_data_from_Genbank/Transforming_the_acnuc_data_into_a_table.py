# This file is a transformation file that takes the files in a parallel folder called "Acnuc_sequences_Genbank". 
# It extracts several informations (sequence ID, Taxonomy, the sequence, and if it has any folding information, it extracts it too).
# The files must be extracted from the ACNUC database and in the Genbank format.
# This script will go through the file line by line and compare test several informations. It extarcts the lines that contain information.

# Libraries

import numpy as np
import os as os
import pandas as pd
import csv as csv
import time as time  # This library is optional. It is used to time several scripts to compare their speed.


# We create an access path to be able to make a tuple out of the files in the parallel folder and iterate over the files.
data_path = '../Acnuc_sequences_Genbank'
list_files = os.listdir(data_path)

# We create a class called Extractor that will serve as a constant variable throughout the extraction loop.
class Extractor:

    # First, we define the init mehtod that will be used when we first call the extractor and when we will change from one 
    # file to the next one in the iterations in the parallel folder. We initialize all the variables of the extractor we will be using.
    def init(self):
        self.id = None
        self.classification = None
        self.sequence = None
        self.pdb = None
        self.temporary_classification = ''
        self.temporary_sequence = ''
        self.extracted_data = None
        self.counter = 0
        # self.extracted_data = np.array([['ID', 'Classification', 'Sequence', 'Folding data']])

    # We then define the contains info method that will be used as a quick verificaiton of the line we are on to see if it contains any 
    # useful information for us to extract. It is a way to win some time to not have to check if each line contains all the information 
    # we are looking for.
    def contains_info(self, line):

        # If the line we are testing contains the information we are looking for, we will return True, and false otherwise.
        if line.startswith("ID") or line.startswith('OC') or line.startswith('     ') or line.startswith('DR   PDB;') or line.startswith('//'):
            return(True)
        else:
            return(False)
    
    # This method is complementary to the contains info method. If we saw the line contains information we want to extract, we test it 
    # on the different type of information we want to extract to apply the good treatment to the line and extract the correct information
    # without compromising it. If one line contains one type of information, it is not necessary to test other types of information given
    # the format we are working with only contains one of the seeked information per line.
    def check_parameters(self, line):
        
        # Check for ID
        if line.startswith('ID'):
            # We extract only the part of the line containing the ID, without the rest of it.
            self.id = line.split()[1]

        # Check for classification
        elif line.startswith('OC'):
            # If the line starts with "OC", it means it contains one part of the classification.
            # But, the classification is cut out in several lines so we use a temporary variable
            # that we will modify later to take out some special operators that result from the
            # separation of the classificaiton over several lines.
            self.temporary_classification += line


        # Check for sequence
        elif line.startswith('     '):
            # If the line starts with "     " (five spaces), it means it contains one part of
            # the sequence. But, the sequence is cut out in several lines so we use a temporary
            # variable that we will modify later to take out some special operators that result
            # from the separation of the sequence over several lines.
            self.temporary_sequence += line

        # Check for folding data
        elif line.startswith('DR   PDB;'):
            self.pdb = line.replace('DR   ', '')
            self.pdb = self.pdb.replace('\n', '')

    # Here we define the add method. This method allows to add the data we extracted in the previous
    # lines into an array allowing us to save it later. Each sequence information in the ACNUC file
    # starts with an ID and ends with "//". Thus, we use "//" to mark the end of the sequence information
    # and add the extracted information to the array. The add method checks if we have extracted the
    # information. If we did, we will add this information to the array and if we did not, we will add
    # a np.nan to the array. 
    def add(self, file):
        
        if self.id is None:
            self.id = np.nan
        
        if self.temporary_classification != '':
            # Here we replace all the special characters that are due to having the classificaiton on several
            # lines to be able to have it as one string on one line that will be added to the array later.
            self.temporary_classification = self.temporary_classification.replace('OC   ', ' ')       
            self.temporary_classification = self.temporary_classification.replace('\nOC   ', ' ')
            self.temporary_classification = self.temporary_classification.replace('\n', '')
            self.temporary_classification = self.temporary_classification.replace(";", ",")
            self.classification = self.temporary_classification
        if self.temporary_classification == '':
            self.classification = np.nan

        if self.temporary_sequence != '':
            # Here we replace all the special characters that are due to having the sequence on several
            # lines to be able to have it as one string on one line that will be added to the array later.
            self.temporary_sequence = self.temporary_sequence.replace(' ', '')
            self.temporary_sequence = self.temporary_sequence.replace('\n', '')
            self.sequence = self.temporary_sequence
        if self.temporary_sequence == '':
            self.sequence = np.nan

        if self.pdb is None:
            self.pdb = np.nan

        # Putting the extracted data in a single vaiable to be calles later
        self.extracted_data = [self.id, self.classification, self.sequence, self.pdb]
        if self.counter == 0:
            pd.DataFrame([['ID', 'Classification', 'Sequence', 'Folding data']]).to_csv('_'.join(['Families', kingdom_names(file), 'Sequences_Extracted.csv']), header=False, index=False, sep=";")
            self.counter = 1

            
        
        else:
            with open('_'.join(['Families', kingdom_names(file), 'Sequences_Extracted.csv']), 'a', newline='') as f_object:
                writer_object = csv.writer(f_object, delimiter=";")
                writer_object.writerow(self.extracted_data)
                f_object.close()

        # We then reinitialize the variables so they do not cloud the memory.
        self.reinit()

    # The reinit method is made to reinitialize the variables once they have been added to the array to not cloud the memory.
    def reinit(self):
        self.id = None
        self.classification = None
        self.sequence = None
        self.pdb = None
        self.temporary_classification = ''
        self.temporary_sequence = ''
        self.extracted_data = None

    # The end method is used to return the extracted data when we are done extracting all the data.
    def end(self):
        return(self.extracted_data)


# This function is used to return the kingdom name from the file. It is used to make file names on measure.
def kingdom_names(file_name):
    kdname = file_name.split('_')[1]
    return(kdname)

# Here we will use everyting we have done above. We will iterate over the files in the parallel folder to extract the information from each file.
for file in list_files:
    start = time.time()

    # For debugging purposes and see where we are in the extraction if we have several files.
    print(kingdom_names(file))

    # Data importation
    data = open(os.path.join(data_path, file), 'r')

    # Making the extractor object and initializing it
    extractor = Extractor()
    extractor.init()

    # Making an iteration over the lines in the data file
    for line in data:

        # First step is to see if the line contains some information we are interested in. If not, it skips the rest.
        if not extractor.contains_info(line):
            continue

        # If the line contians some information, we check the parameters and store the information in the extractor variables.
        else:
            extractor.check_parameters(line)

            # If the line starts with "//", it means we are at the end of one sequence's information. Therefore, we add it to the
            # array containing all the information we want to extract.
            if line.startswith('//'):
                extractor.add(file)

            # To be able to save some data even if the the program shuts down, we add a security save every time we add 100,000 values
            # to the array. It is added in a temporary folder to not cloud the folder we are in.
            # Each time we save a file, the information in the last saved file contain the information of the previously saved files
            # in this folder.

    # The rest is optional. It measures the elapsed time between the beginning of the iterations and the end.
    end = time.time()
    elapsed = end - start

    print(f'Running time on {kingdom_names(file)}: {elapsed:.5}.')
