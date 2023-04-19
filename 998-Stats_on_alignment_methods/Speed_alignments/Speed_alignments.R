# Libraries

library(tidyverse)

data <- read.csv("../Stats_alignment_speed.csv", header = TRUE, sep = ";") %>% 
  mutate_at(vars(c(Clustalo_user, Clustalo_real, Clustalw, Muscle, Mafft, Prank, T.coffee)), as.numeric) %>% 
  mutate(Length_range = Maximum_seq_length_before_alignment - Minimum_seq_length_before_alignment)

ggplot(data, aes(x = log10(Number_sequences))) +
  geom_smooth(aes(y = log10(Mafft), color = "Mafft"))+
  geom_smooth(aes(y = log10(Muscle), color = "Muscle")) +
  geom_smooth(aes(y = log10(Clustalw), color = "ClustalW")) +
  geom_smooth(aes(y = log10(Clustalo_real), color = "Clustal Omega")) +
  labs(title = "Alignment time depending on the number of sequences",
       x = "Log(Number of sequences)",
       y = "Log(Alignment time) (s)") +
  scale_color_manual(values = c("blue", "red", "forestgreen", "darkorchid4"))

ggplot(data %>% 
         arrange(Length_range),
       aes(x = Length_range)) +
  geom_smooth(aes(y = log(Mafft), color = "Mafft"))+
  geom_smooth(aes(y = log(Muscle), color = "Muscle")) +
  geom_smooth(aes(y = log(Clustalw), color = "ClustalW")) +
  geom_smooth(aes(y = log(Clustalo_real), color = "Clustal Omega")) +
  labs(title = "Alignment time depending on length range of the sequences",
       x = "Length range (max length - min length)",
       y = "Log(Alignment time) (s)") +
  scale_color_manual(values = c("blue", "red", "forestgreen", "darkorchid4"))

ggplot(data %>% 
         arrange(Mean_seq_length_before_alignment),
       aes(x = Mean_seq_length_before_alignment)) +
  geom_smooth(aes(y = log(Mafft), color = "Mafft"))+
  geom_smooth(aes(y = log(Muscle), color = "Muscle")) +
  geom_smooth(aes(y = log(Clustalw), color = "ClustalW")) +
  geom_smooth(aes(y = log(Clustalo_real), color = "Clustal Omega")) +
  labs(title = "Alignment time depending on the mean sequence length \nbefore alignment",
       x = "Mean seqeunce length on the file",
       y = "Log(Alignment time) (s)") +
  scale_color_manual(values = c("blue", "red", "forestgreen", "darkorchid4"))

ggplot(data) +
  geom_smooth(aes(x= Seq_length_after_alignment_.MAFFT., y = log(Mafft), color = "Mafft"))+
  geom_smooth(aes(x = Seq_length_after_alignment_.MUSCLE., y = log(Muscle), color = "Muscle")) +
  geom_smooth(aes(x = Seq_length_after_alignment_.MUSCLE., y = log(Clustalw), color = "ClustalW")) +
  geom_smooth(aes(x = Seq_length_after_alignment_.Clustalo., y = log(Clustalo_real), color = "Clustal Omega")) +
  labs(title = "Alignment time depending on sequence length",
       x = "Sequence length",
       y = "Log(Alignment time) (s)") +
  scale_color_manual(values = c("blue", "red", "forestgreen", "darkorchid4"))
