#! /bin/sh

for error_file_to_treat in $(grep -l [Ee][Rr][Rr][Oo][Rr] logs/Prank/run*/*); do

    if [ "$error_file_to_treat" = "logs/Prank/run2/slurm_15793091_841.out" ]; then
        continue
    else
        family_path=$(head -n6 ${error_file_to_treat} | tail -n1)
        echo $family_path >> List_gene_families_for_mafft.xtxt
    fi
done