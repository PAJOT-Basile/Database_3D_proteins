library(dplyr)
library(ggplot2)

method <- commandArgs()[6]


df <- read.csv(paste0("./csvs/Evaluation_scores_Archaea_", method, ".csv"), sep = ";", header = TRUE) %>% 
  mutate(order="Archaea")
df1 <- read.csv(paste0("./csvs/Evaluation_scores_Bacteria_", method, ".csv"), sep = ";", header = TRUE) %>% 
  mutate(order="Bacteria")
df2 <- read.csv(paste0("./csvs/Evaluation_scores_Eukaryota_", method, ".csv"), sep = ";", header = TRUE) %>% 
  mutate(order="Eukaryota")


rbind(df, df1, df2) %>% 
  ggplot(aes(x=order, y=Number_sequences)) +
    geom_violin(aes(fill=order)) +
    labs(title = "Distribution of number of sequences per Super-Kingdom", 
         x="Order", 
         y="Number of sequences") +
    geom_point(aes(y=Number_sequences, col=Gap_score), alpha=0.02) +
    scale_color_continuous(low="blue", high="red")

ggsave("./Distribution number of sequences per superkingdom.png", width = 10, height = 7, dpi = 300)
