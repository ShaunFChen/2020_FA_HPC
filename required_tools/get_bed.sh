#!/bin/bash 

anc=$1
samp=$2

main=/mnt/stsi/stsi0/sfchen/200412_local_ancestry/MESA/ancestry-${anc}

for hap in 0 1; do
    for chrom in {1..22}; do
        tail -n+2 ${main}/mesa.c1.ancestry-${anc}.chr${chrom}.msp.tsv |\
          awk -v samp=${samp} -v hap=${hap} 'NR==1 { for (i=1; i<=NF; i++) { f[$i] = i } } { print $(f["#chm"]), $(f["spos"]), $(f["epos"]), $(f[samp"."hap]), $(f["sgpos"]), $(f["egpos"]) }' | tail -n+2
    done > mesa-${samp}-${hap}.bed
done

