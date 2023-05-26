# 07-Filtering_sequences_on_their_quality

This step is complementary to the previous one. It calculates the number of gaps/unknowns per sequence and uses it as indicator to filter the sequences.
The purpose of this folder is to evaluate a gap score in the data after removing the empty sites. The gap score is defined as follows
`gap_score = number_gaps_in_file / (number_sequences x number_sites)`
You may chose another method to calculate the gap score differently.

The `launcher.sh` script takes as arguments the path to the previous folder (5-Taking_out_gaps_in_sequences) and the method to calculate the gap score.
The method can be one of two: "simple" for the gap score calculation depicted above or "complex". The complex method calculates the gap score as follows:
`gap_score = mean( number_gaps_per_sequence / max(number_AA_per_sequence) )`
If the method is not given, it will by default be the simple depicted first.

The `launcher.sh` script is interactive. Once you have started it, the following message appears in the terminal:
`What do you want to do (evaluate, filter or both) ?`
Type in the answer and the script will execute the selected action. The "both" option allows to evaluate and filter the files.
If you choose the "evaluate" option, once the evaluation is done, you will be asked if you want to filter or not. If not, the program will end. If you chose to filter after evaluating or the "filter" option in the first option, a new message will appear:
`Here, you have to chose a threshold value for the gap score. \nThis value will be used to filter the family gene files evaluated previously to select
only some of them that are clean enough to keep going.\n This value has to be between 0 and 1 and the decimal shall be indicated with a dot.
Given the graphs that were written using this program, what threshold gap score should be used to filter the data ?`
You have to add a threshold value to filter the data on.
:warning: **The filtration step requires the output of the evaluation step to run**. Therefore, if you chose the "filter" option only, make shure that you have the ouput of the evaluation step. 

The `Quality_evaluator.py` script is a python script caluclating the gap score on every gene family file. It adds the calculated score in a created csv file inside the `csvs` folder created by the launcher. The csv file of each order is named using the following format:
`Evaluation_scores_ORDER_METHOD.csv`
> with `ORDER` being the name of the considered Super-Kingdom and `METHOD` is the name of the selected method.

The `distribution.R` script is a Rscript run at the end of the evaluation phase for each order taking into account the name of the order and the method used and plots the graphs showing the distribution of the gap score in the gene family files or considering the sequence length and the number of sequences per file.

To run the script, set your working directory in this folder and run the script : 
```
cd Database_3D_proteins/07-Filtering_sequences_on_their_quality
bash ./launcher.sh ../5-Taking_out_gaps_in_sequences/ "simple"
```
This steps lasts for :warning: :warning: with the considered database.