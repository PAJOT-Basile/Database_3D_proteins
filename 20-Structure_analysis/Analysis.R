# Libraries
require(dplyr)
library(dplyr)
require(ggplot2)
library(ggplot2)
require(stringr)
library(stringr)
require(readr)
library(lme4)


df <- read.csv("~/Database_3D_proteins/Database/Bacteria/Bacteria_structure_info.csv", header=TRUE, sep = ";") %>% 
  filter(!is.na(probability),
         !is.na(SecondaryStructure)) 
code <- read.csv("~/Database_3D_proteins/20-Structure_analysis/DSSP_code.csv", header = TRUE, sep = ";")

df <- merge(df, code, by.x = "SecondaryStructure", by.y = "Code", all.x = TRUE)
  


df %>% 
    ggplot(aes(x=probability, fill = Structure)) +
    geom_histogram()+
    facet_wrap(~Structure)

dftest <- df %>% mutate(SecondaryStructure = as.factor(SecondaryStructure),
                        test = ifelse(SecondaryStructure == "H" | SecondaryStructure == "G" | SecondaryStructure == "P" | SecondaryStructure == "I", "Helix", 
                                      ifelse(SecondaryStructure == "B" | SecondaryStructure == "E" | SecondaryStructure == "S", "Sheet", 
                                             ifelse(SecondaryStructure == "T", "Turn", "Other"))))


dftest  %>% 
  ggplot(aes(x=test, y=probability, fill = test)) +
    geom_boxplot()

dftest  %>% 
  ggplot(aes(x=AlnPosition, y=probability, fill = test)) +
  geom_col()+
  facet_wrap(~test)
  
dftest %>%
  ggplot(aes(x=test, y=Rsa, fill = test)) +
  geom_boxplot()
  
  
dftest <- dftest %>% 
  mutate(Helix = as.factor(ifelse(test == "Helix", 1, 0)),
         Sheet = as.factor(ifelse(test == "Sheet", 1, 0)),
         Turn = as.factor(ifelse(test == "Turn", 1, 0)),
         Other = as.factor(ifelse(test == "Other", 1, 0)))

mod <- glm(probability ~ test + Rsa + Gene_family, data = dftest, family = "binomial")
summary(mod)

