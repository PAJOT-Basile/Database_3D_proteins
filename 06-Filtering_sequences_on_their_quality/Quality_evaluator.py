# Libraries
import sys as sys
import os as os
import tqdm as tqdm
import csv as csv
import decimal as dec

# This script takes into account the path to the parallel folder to analyse, the name of the Super-Kingdom to analyse and the gap score calculation method
# The calculation method can be one of "simple" or "complex"
data_path = sys.argv[1]
order = sys.argv[2]
method = sys.argv[3]


# We define a quality evaluator class
class QualityEvaluator:

    # The __init__ method is called when the quality evaluator is called. It creates several variables that will be used
    def __init__(self, family):
        self.init()
        self.number_sequences = 0
        self.nb_gaps = 0
        self.family_name = family
        self.scores_file = []
        self.sequence_length = None
        self.sequence_length_file = []

        # We also define a dictionary of all the amino acids given we will have to differenciate the gaps from amino acids
        self.AA_dict = {
            "A": "Alanine",
            "R": "Argnine",
            "N": "Asparagine",
            "D": "Aspartic acid",
            "C": "Cysteine",
            "Q": "Glycine",
            "E": "Glutamic acid",
            "G": "Glycine",
            "H": "Histidine",
            "I": "Isoleucine",
            "L": "Leucine",
            "K": "Lysine",
            "M": "Methionine",
            "F": "Phenylalanine",
            "P": "Proline",
            "S": "Serine",
            "T": "Threonine",
            "W": "Tryptophan",
            "Y": "Tyrosine",
            "V": "Valine",
            "B": "Asparagine/aspartic acid",
            "Z": "Glutamine/glutamic acid",
        }

    # The init method defines variables that will be changed in a loop, therefore different from the variables defined in the __init__ method
    def init(self):
        self.sequence = ""
        self.extracting = False
        self.sequence_gaps = 0

    # The evaluate method. It iterates over the lines in a file to evaluate the gap score in said file. It therefore extracts the sequences and 
    # evaluates each sequence independintly and takes the mean of the sequence evaluation as a file gap score  
    def evaluate(self, file, method):
        
        # Before starting, we initialise the quality evaluator
        self.init()
        
        # We iterate over the lines in the file and consider two cases. The first one is that we read a line starting with ">"
        # This line contains a sequence name. Therefore, we will start extracting the sequence at the next line so we set the "extracting"
        # parameter to "True" and add one to the sequence counter. The second case is if the "extracting" parameter is set to "True"
        # If this is the case, we have two more cases. The line does not start with ">", which means we are reading part of a 
        # sequence, therefore we extract it (an additional modification phase is done if we chose the complex method) to only count amino acids
        # The final case is if the "extracting" parameter is set to "True" and the line starts with ">". It means we are looking at a new sequence name,
        # so we evaluate the previous sequence and re-initialise the quality evaluator 
        for line in open(file, "r"):

            if self.extracting:
                if line.startswith(">"):
                    self.evaluate_seq(method)
                    self.init()
                elif not line.startswith(">"):
                    self.sequence += line.replace("\n", "")

            if line.startswith(">") and not self.extracting:
                self.extracting = True
                self.number_sequences += 1
                            
    # The evaluate_seq method calculates the number of gaps/unknown characters in the sequence and adds it to a gap counter. If we use the 
    # simple gap score calculation method, the gap counter is the same for the whole file. In the "complex" method, we have one per sequence
    # and we also count the number of amino acids in the sequence 
    def evaluate_seq(self, method):
        for site in self.sequence:
            if site not in self.AA_dict:
                self.nb_gaps += 1
                if method == "complex":
                    self.sequence_gaps += 1
        if self.sequence_length is None:
            self.sequence_length = len(self.sequence)

        if method == "complex":
            self.scores_file.append(self.sequence_gaps)
            self.sequence_length_file.append(len(self.sequence.replace("-", "")))
       
    # The "score_file" method takes into account the method and calculates the gap score accordingly. It returns the output (gene family name, 
    # number of sequences in the file, number of sites per sequence and the calculated gap score)
    def score_file(self, method):
        dec.getcontext().prec = 17
        if method == "simple":
            return([self.family_name, self.number_sequences,
                    self.sequence_length,
                    (dec.Decimal(self.nb_gaps) / dec.Decimal(self.sequence_length * self.number_sequences))])
        elif method == "complex":
            self.scores = []
            for score, seq_len in zip(self.scores_file, self.sequence_length_file):
                self.scores.append(dec.Decimal(score) / dec.Decimal(seq_len))
            self.score = dec.Decimal(sum(self.scores)) / dec.Decimal(len(self.scores))
            return([self.family_name, self.number_sequences,
                    self.sequence_length,
                    dec.Decimal(self.score)])
        else:
            print("The method you requested is not recognised. Please chose in the following: 'simple' or 'complex'.")

            

# We make a list of all the gene family files in the parallel folder and iterate over these files.
list_families = [family for family in os.listdir(os.path.join(data_path, order))]
for family in tqdm.tqdm(list_families):

    # We exxtract the family name from the gene family filename
    family_name = family.split(".")[0]

    # We define and initialise the quality evaluator
    qualityeval = QualityEvaluator(family_name)

    # We evaluate the file we are iterating over
    qualityeval.evaluate(os.path.join(data_path, order, family), method)
    
    # We get the score from said file
    score = qualityeval.score_file(method)

    # Finaly, we write the score in the output csv file
    with open("".join(["./csvs/Evaluation_scores_", order, "_", method, ".csv"]), "a") as f:
        wr = csv.writer(f, delimiter=";")
        wr.writerows([score])
        f.close()