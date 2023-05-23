# Libraries
import os as os
import sys as sys

data_path = sys.argv[1]
duration_time = int(sys.argv[2])
method = sys.argv[3]

order = data_path.split("/")[2]
family_name = data_path.split("/")[3]


class TimeConverter:

    def __init__(self):
        self.duration = 0
    
    def seconds(self, time):
        self.duration += time / 60

    def minutes(self, time):
        remaining_seconds = time % 100
        self.duration += time // 100
        self.seconds(remaining_seconds)
    
    def hours(self, time):
        remaining_minutes = time % 10000
        self.duration += (time // 10000) * 60
        self.minutes(remaining_minutes)

    def days(self, time):
        remaining_hours = time % 1000000
        self.duration += (time // 1000000) * 60 * 24
        self.hours(remaining_hours)


# Measure the sequence lengths before alignment and add 4 params: Num_seq; Min_length; Max_length; Mean_length
list_seq_lengths=[]
for line in open("".join([os.path.join(data_path, family_name), ".csv"]), "r"):
    if line.startswith("Sequence_name"):
        continue
    else:
        sequence=line.split(";")[1].replace("-", "")
        list_seq_lengths.append(len(sequence))

Number_seq = len(list_seq_lengths)
Min_length = min(list_seq_lengths)
Max_length = max(list_seq_lengths)
Mean_length = sum(list_seq_lengths) / Number_seq

# Get the time of the alignment process and the end sequence length
converter = TimeConverter()

# Convert seconds into minutes:
if duration_time <= 99:
    converter.seconds(duration_time)
elif 100 <= duration_time <= 9999:
    converter.minutes(duration_time)
elif 10000 <= duration_time <= 999999:
    converter.hours(duration_time)
else:
    converter.days(duration_time)

normalised_time = converter.duration
thing_to_do = "".join(["head -n2 ", ''.join([data_path, family_name, '.csv ']), "| tail -n1 | cut -d';' -f3"])
sequence_length_after_alingment = str(os.popen(thing_to_do).read())


with open("./Alignment_speeds.csv", "a") as f:
    f.write(";".join([order, family_name, str(Number_seq), str(Min_length), str(Max_length), str(Mean_length), str(normalised_time), method, str(sequence_length_after_alingment)]))
    f.close()

