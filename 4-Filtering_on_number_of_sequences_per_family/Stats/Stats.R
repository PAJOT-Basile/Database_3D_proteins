# Libraries

library(dplyr)
library(ggplot2)
library(stringr)
library(forcats)
library(cowplot)


Number_of_families_per_kingdom <- read.csv("Stats/Number_of_families_per_superkingdom.csv", sep = ";", header = TRUE) %>% 
  as.data.frame()

p1 <-ggplot(data = Number_of_families_per_kingdom, aes(x = Super_kingdom, y = Number_of_families)) +
  geom_col(aes(fill = Super_kingdom)) +
  geom_text(aes(x = Super_kingdom, y = Number_of_families, label = Number_of_families), vjust = 1) +
  ggtitle("Number of families per Super-Kingdom after filtering") +
  theme(legend.position = "none")

p2 <- ggplot(data = Number_of_families_per_kingdom, aes(x = Super_kingdom, y = log(Number_of_sequences))) +
  geom_col(aes(fill = Super_kingdom)) +
  geom_text(aes(x = Super_kingdom, y = log(Number_of_sequences), label = Number_of_sequences), vjust = 1) +
  ggtitle("Number of sequences per Super-Kingdom after filtering") +
  theme(legend.position = "none")

plot_grid(p1, p2, ncol = 2, nrow = 1, labels = c("A", "B"))

ggsave("Stats/Stats per Super-Kingdom after filtration.png")


