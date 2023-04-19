# Libraries

import sys as sys
import os as os
import tqdm as tqdm
import csv as csv

data_path = sys.argv[1]
order = sys.argv[2]
method = sys.argv[3]  # Can be one of "simple" or "complex"


class QualityEvaluator:

    def __init__(self, family):
        self.init()
        self.number_sequences = 0
        self.nb_gaps = 0
        self.nb_sites_tot = 0
        self.family_name = family
        self.scores_file = []
        self.sequence_length = None

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

    def init(self):
        self.sequence_untouched = ""
        self.sequence_modif = ""
        self.extracting = False
        self.sequence_gaps = 0


    def evaluate(self, file, method):
        self.init()
        for line in open(file, "r"):

            if self.extracting:
                if line.startswith(">"):
                    self.evaluate_seq(method)
                    self.init()
                elif not line.startswith(">"):
                    self.sequence_untouched += line.replace("\n", "")
                    self.sequence_modif += line.replace("\n", "").replace("-", "")

            if line.startswith(">") and not self.extracting:
                self.extracting = True
                self.number_sequences += 1
                            

    def evaluate_seq(self, method):
        for site in self.sequence_untouched:
            if site not in self.AA_dict:
                self.nb_gaps += 1
                if method == "complex":
                    self.sequence_gaps += 1
            self.nb_sites_tot += 1
        if self.sequence_length is None:
            self.sequence_length = len(self.sequence_untouched)

        if method == "complex":
            self.scores_file.append(self.sequence_gaps)
       
    
    def score_file(self, method):
        if method == "simple":
            return([self.family_name, self.number_sequences,
                    (self.nb_sites_tot / self.number_sequences),
                    (self.nb_gaps / (self.sequence_length * self.number_sequences))])
        elif method == "complex":
            self.scores = 0
            for score in self.scores_file:
                self.scores += score
            return([self.family_name, self.number_sequences,
                    (self.nb_sites_tot / self.number_sequences),
                    (self.scores / self.sequence_length)])
        else:
            print("The method you requested is not recognised. Please chose in the following: 'simple' or 'complex'.")

            



list_families = [family for family in os.listdir(os.path.join(data_path, order))]
for family in tqdm.tqdm(list_families):
    family_name = family.split(".")[0]
    qualityeval = QualityEvaluator(family_name)
    qualityeval.evaluate(os.path.join(data_path, order, family), method)
    score = qualityeval.score_file(method)
    with open("".join(["./csvs/Evaluation_scores_", order, "_", method, ".csv"]), "a") as f:
        wr = csv.writer(f, delimiter=";")
        wr.writerows([score])
        f.close()