# 2020 FA HPC - Garibaldi (Torque/Maui)
High-performance computing (HPC) in Scripps Research 

This repository worked as class materials and was tested on Garibaldi only.


## Requirements

**Modules and shell tools**  

- R (`module load R`)
- python >= 3.6.3 (`module load python/3.6.3`)
- [PLINK v1.9](https://www.cog-genomics.org/plink2) (`module load plink2/1.90b3.42`)
- [bcftools >= 1.9](http://samtools.github.io/bcftools/bcftools.html) (`module load samtools`)
- [ADMIXTURE](http://dalexander.github.io/admixture/) (`module load admixture`)  
	_Alexander, David H., and Kenneth Lange. "Enhancements to the ADMIXTURE algorithm for individual ancestry estimation." BMC bioinformatics 12.1 (2011): 246._
- [RFMix2](https://github.com/slowkoni/rfmix) (`required_tools/rfmix2`)  
	_Maples, Brian K., et al. "RFMix: a discriminative modeling approach for rapid and robust local-ancestry inference." The American Journal of Human Genetics 93.2 (2013): 278-288._

**Datasets**  

- Pruned 1000 Genomes Phase III as VCF.gz files (`/gpfs/sfchen/work/1000G`)
	[ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/](ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/)
- Reference genome build - GRCh37 (`/gpfs/sfchen/work/GRCh37`)
	[http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/human_g1k_v37.fasta.gz](http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/human_g1k_v37.fasta.gz)
	[http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/human_g1k_v37.fasta.fai](http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/human_g1k_v37.fasta.fai)

## Cheat Sheet

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

1. `usage`: display the current usage of the entire cluster
2. `qstat`: show status of pbs batch jobs  
		`-f [job_id]`: Specifies that a full status display be written to standard out.  
		`-u [username]`: Specifies all of the user's job status.
3. `qsub`: submit pbs job  
		`-I`: Declares that the job is to be run "interactively".  
		`-l`: Defines the resources that are required by the job and establishes a limit to the amount of resource that can be consumed.  
			`mem`
			`walltime`
			`nodes=1:ppn=1`  
		`-N`: Declares a name for the job.  
		`-v`: Expands the list of environment variables that are exported to the job. The variable list is a comma separated list of strings of the form variable or variable=value.  
		`-M`: Declares the list of users to whom mail is sent by the execution server when it sends mail about the job.  
		`-m`: Defines the set of conditions under which the execution server will send a mail message about the job.  The mail_options argument is a string which consists of either the single character "n", or one or more of the characters "a", "b", and "e". `a` mail is sent when the job is aborted by the batch system. `b`  mail is sent when the job begins execution. `e`  mail is sent when the job terminates.

		
4. `qdel`
5. `module`  
		`load`  
		`unload`  
		`purge`  

**Schedular varaiables (Torque/Maui)**  

1. `$PBS_O_WORKDIR`
2. `$PBS_O_HOME`
3. `$PBSREMOEDIR`
4. `$PBSTMPDIR`


## Job script template




## Case study

**0. (Optional) Convert from 23andMe to VCF**

```
bcftools convert --tsv2vcf ${input_txt_path} -f ${ref_fasta_path) -s ${subject_ID} -Ov -o ${output_filename}.vcf
```

GRCh37 on Gariabldi: `/gpfs/work/sfchen/human_g1k_v37.fasta`

**1. Ancestry inference using PCA**  

**2. Global acnestry inference with ADMIXTURE**  

**3. Local ancestry inference with RFMix2**  



## REFERENCE

1.  Scripps Reserach HPC (in Intranet) [https://intranet.scripps.edu/its/highperformancecomputing/index.html](https://intranet.scripps.edu/its/highperformancecomputing/index.html)
2. HPC Challenges — A Perspective for General Data Analysis and Visualization [http://web.eecs.utk.edu/~huangj/hpc/hpc_intro.php](http://web.eecs.utk.edu/~huangj/hpc/hpc_intro.php)
3. Tutorial: Produce PCA bi-plot for 1000 Genomes Phase III - Version 2  [https://www.biostars.org/p/335605/](https://www.biostars.org/p/335605/)
4. Converting from 23andMe to VCF [https://samtools.github.io/bcftools/howtos/convert.html](https://samtools.github.io/bcftools/howtos/convert.html)
5. Skoglund, Pontus, and Iain Mathieson. "Ancient genomics of modern humans: the first decade." Annual review of genomics and human genetics 19 (2018): 381-404.
6. Martin, Alicia R., et al. "Clinical use of current polygenic risk scores may exacerbate health disparities." Nature genetics 51.4 (2019): 584-591.
7. Tian, Rui, Malay K. Basu, and Emidio Capriotti. "Computational methods and resources for the interpretation of genomic variants in cancer." BMC genomics 16.S8 (2015): S7.
8. Alicia R., Ancestry pipeline. GitHub, [https://github.com/armartin/ancestry_pipeline](https://github.com/armartin/ancestry_pipeline)