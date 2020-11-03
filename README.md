# 2020 FA HPC - Garibaldi (Torque/Maui)
High-performance computing (HPC) in Scripps Research 

This repository worked as class materials and was tested on Garibaldi only.

---
###Requirements

Modules or shell tools  

- R (`module load R`)
- python >= 3.6.3 (`module load python/3.6.3`)
- [PLINK v1.9](https://www.cog-genomics.org/plink2) (`module load plink2/1.90b3.42`)
- [bcftools >= 1.9](http://samtools.github.io/bcftools/bcftools.html) (`module load samtools`)
- [ADMIXTURE](http://dalexander.github.io/admixture/) (`module load admixture`)  
	_Alexander, David H., and Kenneth Lange. "Enhancements to the ADMIXTURE algorithm for individual ancestry estimation." BMC bioinformatics 12.1 (2011): 246._
- [RFMix2](https://github.com/slowkoni/rfmix) (`required_tools/rfmix2`)  
	_Maples, Brian K., et al. "RFMix: a discriminative modeling approach for rapid and robust local-ancestry inference." The American Journal of Human Genetics 93.2 (2013): 278-288._

Datasets  

- Pruned 1000 Genomes Phase III as VCF.gz files (`/gpfs/sfchen/work/1000G`)

---
###Cheat Sheet

**Shell commands**  

1. `ssh`  
2. `htop`  
3. `watch`
4. `vim`, `nano`, `emacs`

**Git commands**  

On Garibaldi: `module load git-lfs`

1. `git clone`
2. `git add`
3. `git commit -m`
4. `git push`
5. `git pull`


**Schedular commands (Torque/Maui)**  

1. `usage`
2. `qstat`  
	`-f [job_id]`  
	`-u [username]`
3. `qsub`  
	`-I`  
	`-l`  
	`-N`  
	`-v`  
4. `module`  
	`load`  
	`unload`  
	`purge`  

**Schedular varaiables (Torque/Maui)**  

1. `$PBS_O_WORKDIR`
2. `$PBS_O_HOME`
3. `$PBSREMOEDIR`
4. `$PBSTMPDIR`

---
###Job script template


---

###Case study

**1. Ancestry inference using PCA**  



**2. Global acnestry inference with ADMIXTURE**  

**3. Local ancestry inference with RFMix2**  


---

###REFERENCE

1.  Scripps Reserach HPC (in Intranet) [https://intranet.scripps.edu/its/highperformancecomputing/index.html](https://intranet.scripps.edu/its/highperformancecomputing/index.html)
2. HPC Challenges — A Perspective for General Data Analysis and Visualization [http://web.eecs.utk.edu/~huangj/hpc/hpc_intro.php](http://web.eecs.utk.edu/~huangj/hpc/hpc_intro.php)
3. Tutorial: Produce PCA bi-plot for 1000 Genomes Phase III - Version 2  [https://www.biostars.org/p/335605/](https://www.biostars.org/p/335605/)
4. Skoglund, Pontus, and Iain Mathieson. "Ancient genomics of modern humans: the first decade." Annual review of genomics and human genetics 19 (2018): 381-404.
5. Martin, Alicia R., et al. "Clinical use of current polygenic risk scores may exacerbate health disparities." Nature genetics 51.4 (2019): 584-591.