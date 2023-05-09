# Libraries
import os as os
import sys as sys

# This script takes into account the path to the folder that has been created containing the aligned file, the time of the alignment and 
# the alignment method
data_path = sys.argv[1]
duration_time = int(sys.argv[2])
method = sys.argv[3]

# We extract the name of the Super-Kingdom and the name of the gene family we consider here from the data path
order = data_path.split("/")[2]
family_name = data_path.split("/")[3]


# We create a TimeConverter that converts the time from the "date" function in Linux into minutes. This TimeConverter works by consecutive iterations to
# convert parts of the time into minutes and then goes on to convert smaller time values. For example, 2h30min15sec will be written 023015 (output of the 
# "date" function). The first step is to see that the date output is a number between 10000 and 999999. Therefore, in this interval, the biggest time that 
# can be measured is an hour. So, we call the hours method that converts the two first numbers of the date output to minutes and send the rest to the minutes
# method. This one converts the two following numbers to minutes and calls the seconds methods that converts the remaining numbers to minutes   
class TimeConverter:

    # The __init__ method is used to define the duration that will be used in the other methods
    def __init__(self):
        self.duration = 0
    
    # This method adds the converted time (from days to minutes) to the duration. The remaining time is sent to the hours method 
    def days(self, time):
        remaining_hours = time % 1000000
        self.duration += (time // 1000000) * 60 * 24
        self.hours(remaining_hours)

    # This method adds the remaining converted time (from hours to minutes) to the duration. The remaining time is sent to the minutes method
    def hours(self, time):
        remaining_minutes = time % 10000
        self.duration += (time // 10000) * 60
        self.minutes(remaining_minutes)

    # This method adds the remaining time to the duration. The remaining time is sent to the seconds method.
    def minutes(self, time):
        remaining_seconds = time % 100
        self.duration += time // 100
        self.seconds(remaining_seconds)

    # Finally, this method adds the remaining converted time (from seconds to minutes) to the duration
    def seconds(self, time):
        self.duration += time / 60


# Here, we measure the length of the sequences in the folder to analyse before the alignment (by removing the "-"). We use the csv created earlier
list_seq_lengths=[]
for line in open("".join([os.path.join(data_path, family_name), ".csv"]), "r"):
    if line.startswith("Sequence_name"):
        continue
    else:
        sequence=line.split(";")[1].replace("-", "")
        list_seq_lengths.append(len(sequence))

# We measure 4 parameters on the sequence lengths in the folder to analyse. The number of sequences, the minimum, maximum and mean sequence length
Number_seq = len(list_seq_lengths)
Min_length = min(list_seq_lengths)
Max_length = max(list_seq_lengths)
Mean_length = sum(list_seq_lengths) / Number_seq

# Define and initialise the TimeConverter
converter = TimeConverter()

# We convert the time into minutes. As explained before, the output of the date method can be separated into several classes. Once the appropriate 
# class is found, we run the appropriate method in the TimeConverter
if duration_time <= 99:
    converter.seconds(duration_time)
elif 100 <= duration_time <= 9999:
    converter.minutes(duration_time)
elif 10000 <= duration_time <= 999999:
    converter.hours(duration_time)
else:
    converter.days(duration_time)

# We extract the duration from the TimeConverter
normalised_time = converter.duration

# Next, we want to get the length of the sequence after alignment. To do so, we use a linux subprocess to extract the length from the csv file 
# created earlier
thing_to_do = "".join(["head -n2 ", ''.join([data_path, family_name, '.csv ']), "| tail -n1 | cut -d';' -f3"])
sequence_length_after_alignment = str(os.popen(thing_to_do).read())

# Finaly, we write all these parameters in a csv file to compare everything
with open("./Alignment_speeds.csv", "a") as f:
    f.write(";".join([order, family_name, str(Number_seq), str(Min_length), str(Max_length), str(Mean_length), str(normalised_time), method, str(sequence_length_after_alignment)]))
    f.close()

