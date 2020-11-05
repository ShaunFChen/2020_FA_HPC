#!/bin/bash 

samp=$1

for hap in 0 1; do
    for chrom in {1..22}; do
        tail -n+2 ${samp}_tmp/${samp}_phased_chr${chrom}_pruned.msp.tsv |\
          awk -v samp=${samp}_${samp} -v hap=${hap} -F '\t' 'NR==1 { for (i=1; i<=NF; i++) { f[$i] = i } } { print $(f["#chm"]), $(f["spos"]), $(f["epos"]), $(f[samp"."hap]), $(f["sgpos"]), $(f["egpos"]) }' | tail -n+2
    done > ${samp}_tmp/${samp}-${hap}.bed
    
    awk -F' ' '{gsub(/0/, "AFR", $4) gsub(/1/, "AMR", $4) gsub(/2/, "EAS", $4) gsub(/3/, "EUR", $4) gsub(/4/, "SAS", $4) }1' ${samp}_tmp/${samp}-${hap}.bed > ${samp}_tmp/${samp}-${hap}.tmp
    mv ${samp}_tmp/${samp}-${hap}.tmp ${samp}-${hap}.bed
    
done



