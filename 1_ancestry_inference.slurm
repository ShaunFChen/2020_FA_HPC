#!/bin/bash
#PBS -l mem=108gb
#PBS -l nodes=1:ppn=16
#PBS -l walltime=48:00:00
#PBS -M [username]@scripps.edu
#PBS -m a

# qsub -v input= 1_ancestry_inference.pbs


# Load essential module on Garibaldi
module load samtools
module load plink2/1.90b3.42
module load R
module load python/3.6.3

# Enter working directory
cd $PBS_O_WORKDIR 

inprefix=$(basename ${input} | sed 's/.vcf.gz//g')

mkdir -p ${inprefix}_tmp


echo "split by chromosome"
split_starttime=$(date +%s)

for i in {1..22}; do
    split_vcf=${inprefix}_tmp/${inprefix}_chr${i}.vcf.gz
    echo "bcftools view ${input} -r ${i} -Oz -o ${split_vcf}; tabix -p vcf ${split_vcf}"
done > ${inprefix}.split.parallel
parallel < ${inprefix}.split.parallel
rm ${inprefix}.split.parallel

split_endtime=$(date +%s)


echo "phasing..."
phase_starttime=$(date +%s)

for i in {1..22}; do
    split_vcf=${inprefix}_tmp/${inprefix}_chr${i}.vcf.gz
    ref_vcf=/gpfs/work/sfchen/1000G/ALL.chr${i}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.clean.vcf.gz
    my_map=data/genetic_map_hg19_withX.txt.gz
    phased_vcf=${inprefix}_tmp/${inprefix}_phased_chr${i}.vcf.gz
    
    echo "required_tools/eagle --vcfTarget=${split_vcf} \
                --vcfRef=${ref_vcf} \
                --noImpMissing \
                --geneticMapFile=${my_map} \
                --Kpbwt=100000 --numThreads=16 \
                --chrom=${i} --allowRefAltSwap \
                --outPrefix=${phased_vcf/.vcf.gz/}; tabix -p vcf ${phased_vcf}"
done > ${inprefix}.phase.parallel
parallel < ${inprefix}.phase.parallel
rm ${inprefix}.phase.parallel

phase_endtime=$(date +%s)


echo "local ancestry inference"
rfmix_starttime=$(date +%s)

for i in {1..22}; do
    phased_vcf=${inprefix}_tmp/${inprefix}_phased_chr${i}.vcf.gz
    ref_vcf=/gpfs/work/sfchen/1000G/ALL.chr${i}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.clean.vcf.gz
    my_map=data/genetic_map_hg19_withX.txt
    pruning=data/HDGP.lifted.sorted.fixref.bi.phased1KG.isec1KG.isec23andMe.geno.50-5-0.2_pairwise.pos
    pruned_vcf=phased_vcf=${inprefix}_tmp/${inprefix}_phased_chr${i}_pruned.vcf.gz
    
    bcftools view ${phased_vcf} -R ${pruning} -Oz -o ${pruned_vcf}
    tabix -p vcf ${pruned_vcf}
    
    required_tools/rfmix \
      -f ${pruned_vcf} \
      -r ${ref_vcf} \
      -m data/1000G.tsv \
      -g ${my_map}  \
      -o ${inprefix}_tmp/${inprefix}_phased_chr${i}_pruned \
      --chromosome=${i} \
      --n-threads=16
done 

rfmix_endtime=$(date +%s)


echo "make plot..."
bash required_tools/get_bed.sh ${inprefix}

cd required_tools

python3 plot_karyogram_ori.py \
  --bed_a ../${inprefix}_tmp/${inprefix}-0.bed \
  --bed_b ../${inprefix}_tmp/${inprefix}-1.bed \
  --ind ${inprefix} \
  --centromeres centromeres_hg19.bed \
  --out ../${inprefix}.png \
  --pop_order='AFR,AMR,EAS,EUR,SAS'

cd ../


echo "clean temp files"
rm -r ${inprefix}_tmp

split_runtime=$((split_endtime-split_starttime))
echo "Split run time: $rfmixruntime"
phase_runtime=$((phase_endtime-phase_starttime))
echo "Phase run time: $rfmixruntime"
rfmix_eruntime=$((rfmix_endtime-rfmix_starttime))
echo "RFMix run time: $rfmixruntime"