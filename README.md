# 2020 FA HPC - Garibaldi (Torque/Maui)

**Author: Shaun Chen**  
**First created: 2020/10/25**

Basic introduction of high-performance computing (HPC) in Scripps Research. This repository worked as class materials and was tested on Garibaldi only. *Shared large datasets will be deprecated at the end of the quarter.*

## Cheat sheet

**Shell commands**  

0. `man`: format and display the on-line manual pages.
0. `ssh`:  OpenSSH SSH client (remote login program).  
0. `scp`: secure copy (remote file copy program).
0. `watch`: execute a program periodically, showing output fullscreen.
0. `vim`, `nano`, `emacs`: programmers text editors.
0. `history`: list command history.
0. `exit`: exit the current session.

0. `Ctrl` + `C`: interrupt a running script when you feel not right...  
0. `Ctrl` + `R`: Recall the last command matching the characters you provide.

**Git commands**  

Prerequisite on Garibaldi: `module load git`

0. `git init`: Create an empty git repository or reinitialize an existing one.  
0. `git clone`: Clone a repository into a new directory.

0. `git status`: Show the working tree status.
0. `git add`: Add file contents to the index.
0. `git commit -m`: Record changes to the repository.
0. `git push`: Update remote refs along with associated objects.

0. `git pull`: Fetch from and merge with another repository or a local branch.

- Note: suggested file size <50MB; limited <100MB.
- Use `.gitignore` to specify intentionally untracked files that Git should ignore.

**Simple Linux Utility for Resource Management (SLURM) Workload Manager**  

0. `showuserjobs`: display the current usage of the entire cluster.
0. `sinfo`: view information about Slurm nodes and partitions.

0. `sbatch -u [username]`: Request  jobs  or  job steps from a comma separated list of users. 
		
0. `sbatch`: submit pbs job  
		`-I`: Declares that the job is to be run "interactively".  
		`-l`: Defines the resources that are required by the job and establishes a limit to the amount of resource that can be consumed. i.e. `mem=4gb`, `walltime=4:00:00`, `nodes=1:ppn=1`.  
		`-M`: Declares the list of users to whom mail is sent by the execution server when it sends mail about the job.  
		`-m`: Defines the set of conditions under which the execution server will send a mail message about the job.  The mail_options argument is a string which consists of either the single character "n", or one or more of the characters "a", "b", and "e". `a` mail is sent when the job is aborted by the batch system. `b`  mail is sent when the job begins execution. `e`  mail is sent when the job terminates.  
		`-N`: Declares a name for the job.  
		`-v`: Expands the list of environment variables that are exported to the job. The variable list is a comma separated list of strings of the form variable or variable=value.  
0. `scancel`: used to signal or cancel jobs, job arrays or job steps.

0. `module`: command interface to the Modules package  
		`av`: display all available modules
		`load`: Load modulefile(s) into the shell environment.  
		`unload`:  Remove modulefile(s) from the shell environment.  
		`purge`: Unload all loaded modulefiles.  
		

## Job script template

```ruby
#!/bin/bash
#SBATCH --time=24:00:00
#SBATCH --mem=16G
## SBATCH --nodes=1                   ### Node count required for the job
## SBATCH --ntasks=1                  ### Number of tasks to be launched per Node
## SBATCH --cpus-per-task=16

# sbatch --export=month=,day= run_slurm.qsub
# slurm will set the working directory with the job script by default.

module purge
module load R 

# always print the path of your working directory
pwd

echo “Hello HPC!! Today is ${month} ${day}”
```

## Case study on Gariabldi


### Requirements

**Modules and shell tools**  

- R (`module load R`)  
	`ggplot2`
- python >= 3.6.3 (`module load python/3.6.3`)
- [PLINK v2](https://www.cog-genomics.org/plink/2.0/) (`required_tools/plink2`)
- [bcftools >= 1.9](http://samtools.github.io/bcftools/bcftools.html) (`module load samtools`)
- [vcftools >= 0.1.14](http://vcftools.sourceforge.net/) (`module load vcftools`)
- [ADMIXTURE](http://dalexander.github.io/admixture/) (`module load admixture`)  
	_Alexander, David H., and Kenneth Lange. "Enhancements to the ADMIXTURE algorithm for individual ancestry estimation." BMC bioinformatics 12.1 (2011): 246._
- [RFMix2](https://github.com/slowkoni/rfmix) (`required_tools/rfmix2`)  
	_Maples, Brian K., et al. "RFMix: a discriminative modeling approach for rapid and robust local-ancestry inference." The American Journal of Human Genetics 93.2 (2013): 278-288._

**Datasets**  

- Phased 1000 Genomes Phase III as VCF.gz files (post-QCed: `/gpfs/sfchen/work/1000G`)
	[ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/](ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/)
- 1000 Genomes sample data (`required_tools/1000G.tsv`)
	[http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/working/20130606_sample_info/20130606_sample_info.xlsx](http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/working/20130606_sample_info/20130606_sample_info.xlsx)
- Reference genome build - GRCh37 (uncompressed: `/gpfs/sfchen/work/GRCh37`)
	[http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/human_g1k_v37.fasta.gz](http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/human_g1k_v37.fasta.gz)
	[http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/human_g1k_v37.fasta.fai](http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/human_g1k_v37.fasta.fai)


**Test case**

- 1000 Genomes Project
	[http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/](http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/)

### Unsupervised ancestry inference using PCA

- Note: edit the mail address to your own one.

Run:  

```
sbatch --job-name=PCA_TGP 0_TGP_PCA.slurm.sh 
```

Expected output: `figure_tgp_pca.png`

<p align="center"><img src="/data/pca.png?raw=true"/></p>


### Extra practice: supervised ancestry inference

**0. (Optional) Convert personal 23andMe genetic data to VCF**

It is sufficient to be done by `srun --pty bash -i`.

```
bcftools convert --tsv2vcf ${input_txt_path} -f ${ref_fasta_path) -s ${subject_ID} -Oz -o ${output_filename}.vcf.gz
tabix -p vcf ${output_filename}.vcf.gz
```

GRCh37 on Gariabldi: `/gpfs/work/sfchen/human_g1k_v37.fasta`

**1. Local ancestry inference with RFMix2**  

sample input: `/gpfs/work/sfchen/HGDP`

```
qsub -v input=[vcf_gz_path] 1_ancestry_inference.pbs
```

sample metadata:

```
Sample_ID       sub_pop          sup_pop
HGDP00001       Brahui           CENTRAL_SOUTH_ASIA
HGDP01041       Pima             AMERICA
HGDP00977       Han              EAST_ASIA
HGDP01062       Sardinian        EUROPE
HGDP00580       Druze            MIDDLE_EAST
HGDP01419       BantuKenya       AFRICA
HGDP00664       Bougainville     OCEANIA
```


<p align="center"><img src="/data/HGDP00001.png?raw=true"/></p>

## REFERENCE

0. Scripps Reserach HPC (in Intranet) [https://intranet.scripps.edu/its/highperformancecomputing/index.html](https://intranet.scripps.edu/its/highperformancecomputing/index.html)
0. HPC Challenges — A Perspective for General Data Analysis and Visualization [http://web.eecs.utk.edu/~huangj/hpc/hpc_intro.php](http://web.eecs.utk.edu/~huangj/hpc/hpc_intro.php)
0. Tutorial: Produce PCA bi-plot for 1000 Genomes Phase III - Version 2. *Biostars*  [https://www.biostars.org/p/335605/](https://www.biostars.org/p/335605/)
0. Converting from 23andMe to VCF [https://samtools.github.io/bcftools/howtos/convert.html](https://samtools.github.io/bcftools/howtos/convert.html)
0. Bergström, Anders, et al. "Insights into human genetic variation and population history from 929 diverse genomes." Science 367.6484 (2020).
0. Skoglund, Pontus, and Iain Mathieson. "Ancient genomics of modern humans: the first decade." *Annual review of genomics and human genetics* 19 (2018): 381-404.
0. Martin, Alicia R., et al. "Clinical use of current polygenic risk scores may exacerbate health disparities." *Nature genetics* 51.4 (2019): 584-591.
0. Tian, Rui, Malay K. Basu, and Emidio Capriotti. "Computational methods and resources for the interpretation of genomic variants in cancer." BMC genomics 16.S8 (2015): S7.
0. Alicia R., "Ancestry pipeline". *GitHub*, [https://github.com/armartin/ancestry_pipeline](https://github.com/armartin/ancestry_pipeline)
0. Bernie Pope, "pbs2slurm". *Github*, [https://github.com/bjpop/pbs2slurm](https://github.com/bjpop/pbs2slurm)
