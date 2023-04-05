# Libraries
library(dplyr)
library(ggplot2)
library(stringr)
library(forcats)
library(cowplot)

# Import the number of families per Super-Kingdom
Number_of_families_per_kingdom <- read.csv("Stats/Number_of_families_per_superkingdom.csv", sep = ";", header = TRUE) %>% 
  as.data.frame()

# Do a first plot counting the number of gene families per Super-Kingdom.
p1 <-ggplot(data = Number_of_families_per_kingdom, aes(x = Super_kingdom, y = Number_of_families)) +
  geom_col(aes(fill = Super_kingdom)) +
  geom_text(aes(x = Super_kingdom, y = Number_of_families, label = Number_of_families), vjust = 1) +
  ggtitle("Number of families per Super-Kingdom after filtering") +
  theme(legend.position = "none")

# Do a second one counting the number of sequences per Super-Kingdom
p2 <- ggplot(data = Number_of_families_per_kingdom, aes(x = Super_kingdom, y = log(Number_of_sequences))) +
  geom_col(aes(fill = Super_kingdom)) +
  geom_text(aes(x = Super_kingdom, y = log(Number_of_sequences), label = Number_of_sequences), vjust = 1) +
  ggtitle("Number of sequences per Super-Kingdom after filtering") +
  theme(legend.position = "none")

# Make a grid with these two lots to save them together.
plot_grid(p1, p2, ncol = 2, nrow = 1, labels = c("A", "B"))

# Save the plots
ggsave("Stats/Stats per Super-Kingdom after filtration.png", width = 10, height = 7, dpi = 300)


