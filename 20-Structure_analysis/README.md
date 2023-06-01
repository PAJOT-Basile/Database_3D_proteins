# 20-Structure_analysis

In this step, all the gene family structure information was pulled together by Super-Kingdom using the `Data_puller.R` script. 
Once it was pulled together, it was analysed by using a simple regression model to see if there is an impact of the structure on the site-specific posterior probability of rate shifts on the sequences. The model used is the following
```
Posterior_probability = a*Helix + b*Sheet +c*Turn + (1|Rsa) + (1|Gene_family)
```
Where the variables "Helix", "Sheet"and  "Turn" are a reference to the 3D structure of a protein, the Rsa is the Residue-solvent action and "Gene_family" is the gene family considered.