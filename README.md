<p align="left"><img width=20%% src="https://github.com/BokaiZhu/microbiomeFISH/blob/master/media/microbiome_fish.png"></p>

# microbiomeFISH
An R package with wrapped-up probe designing functions presented in the [manuscript](link). NOTE: This GitHub is still a work-in-progress, and the code is still being finalized. Early public accessibility was intended the accompany of the preprint.

## Table of content

- [Preparation](#preparation)
    - [ARB install](#ARB-installation)
    - [Sequence pool database](#Sequence-pool-database)
    - [microbiomeFISH install](#R-package-and-dependencies)
- [Probe designing showcase](#probe-designing-showcase)
    - [Part 1 arb](#part-1-arb)
    - [Part 2 R](#part-2-r)
    - [Part 3 Optional multiple probe design](#part-3-optional-multiple-probe-design)
- [F&Q](#f&q)    

## Requirements 

Several software/datafiles are required for this protocol:
1. **ARB** for initial probe design.
2. The curated **human intestinal 16s rRNA pool** files, this is the probe designing pool.
3. **R**, **OligoArrayAux** and **microbiomeFISH** r package for downstream probe screening, modified from [DECIPHER](http://www2.decipher.codes/).
4. Optional: **Usearch** for fast alignment. Utilized in dual or tri probe combination design.

## ARB installation and setup

[The ARB software](http://http://www.arb-home.de/) is a graphically oriented package comprising various tools for sequence database handling and data analysis. We will use this software for initial targeting sequence identification. The installation files can be [downloaded](http://www.arb-home.de/downloads.html). The detailed guidance can be found [here](http://download.arb-home.de/release/latest/arb_README.txt). For Mac users, it is suggested to use Macport to easily install ARB.

If you are experiencing trouble installing arb in Windows, refer to the **F&Q** section

After successfully installing ARB, you should be able to fire it up in the terminal by typing arb:

<p align="center"><img width=70%% src="https://github.com/BokaiZhu/microbiomeFISH/blob/master/media/arb_start.gif"></p>

## 16s rRNA sequence pool database

These files are the curated sequence pool containing 12,932 near full-length 16s rRNA sequences, assigned with taxonomy information. The detailed process of producing these files can be found in the [paper]().

[Here](https://github.com/BokaiZhu/microbiomeFISH/tree/master/data) we have 6 files in the data folder, each with the same sequence pool fasta file, but header contains the assigned taxonomy information at each phylogeny level. You can download the fasta files and use them as inputs for probe design.


## R package: 'microbiomeFISH'

[R](https://www.r-project.org/) is a prerequisite for this part. You can install the microbiomeFISH r package in R by:

```R
install.packages("devtools") # if you have not installed "devtools" package yet
install.packages("BiocManager") # if you have not installed bioconductor yet
devtools::install_github("BokaiZhu/microbiomeFISH",auth_token="230b203a38ae97ff5187cb24ba75205dce2e27d5", repos=BiocManager::repositories(),force = TRUE)
```

## OligoArrayAux (oligo structures)

This r package also requires functions from **OligoArrayAux** to calculate the secondary structure of the probes. [Download](http://www.unafold.org/Dinamelt/software/oligoarrayaux.php) and install the software. 

For people installing from source (.tar.bz2/.tar.gz files), here is a brief tutorial:

```sh
### in your bash terminal :
### uncompress the oligoarryaux
tar xzf oligoarrayaux-3.8.tar.gz 
### or: tar oligoarrayaux-3.8.tar.bz2
```
Then move to the uncompressed directory.
```sh
### in your bash terminal :
cd /Path/to/oligoarrayaux-3.8/
```
Then compile the source code:
```sh
### in your bash terminal :
make
```

If you are compiling on a **server**, or compiling on windows-loaded-ubuntu, try something like this instead ($HOME should be your home directory):
```sh
### in your bash terminal :
/.configure --prefix=$HOME
make
make install
```
Finally, add the path to oligoauxarray to your system files ```~/.bashrc``` or ```~/.bash_profile```:
```sh
### in your bash terminal :
export PATH=$PATH:/Path/to/oligoarrayaux-3.8/..
```

Test if the software is installed correctly by running the code in r :

```R
### in R
system("hybrid-min -V") # calling the hybrid-min function in r

# or when you are using R on a Windows system:
system("/Path/TO/Function/hybrid-min -V") # calling the hybrid-min function in r
```
it should give something like:
```
### result in R console
hybrid-min (OligoArrayAux) 3.8
By Nicholas R. Markham and Michael Zuker
Copyright (C) 2006
Rensselaer Polytechnic Institute
Troy, NY 12810-3590 USA
```

If you are using Rstudio on a server, you need to tell R to use the local user's path too:
```R
### in R
Sys.setenv(PATH=paste(Sys.getenv("PATH"), "/home/user/bin", sep=":"))
```
Now  you should be able to call oligoarrayaux in R (Rstudio) on a server.

## (Optional) Usearch:

Usearch will be utilized for fast alignment process, to optimize the designing process for multiple probe combination designing. Details can be found: [Download](https://www.drive5.com/usearch/download.html) Usearch (can be used directly). The detailed guidance can be found [here](https://www.drive5.com/usearch/manual/install.html). Successful installment should give:

```R
## in your R console
system("~/directory/to/usearch/file/usearch6.0.98_i86linux32-or-something-like-that")
```

```zsh
usearch v11.0.667_i86linux32, 4.0Gb RAM (462Gb total), 40 cores
(C) Copyright 2013-18 Robert C. Edgar, all rights reserved.
https://drive5.com/usearch

License: <your email etc>
```


## Probe designing showcase

### Part 1 arb
Here we will showcase a probe designing scenario, where we want to design a probe that targets the genus **Staphylococcus** in the context of human microbiome containing samples. We can input the **Genus.fasta** file into ARB:

<p align="center"><img width=40%% src="https://github.com/BokaiZhu/microbiomeFISH/blob/master/media/input_arb.png"></p>

We will use the 'found ID' during the input popup. Then will build the arb server with the option under **Probes** -> **PT_Server_admin**. It should be relatively fast. Once the server is build we can start to design the probes. Search for all the sequence names Staphylococcus, select them by **mark listed and unmark rest**:
<p align="center"><img width=100%% src="https://github.com/BokaiZhu/microbiomeFISH/blob/master/media/search_staph.png"></p>

We have 18 sequences in the sequence pool assigned to the genuse Staphylococcus. Let ARB find signature sequence that covers this 18 sequences at the same time does not cover out-group bacteria sequences. Design by option under **Probes** -> **Design Probes**. 

Here we will let ARB find candidate sequences that cover > 85% of the Staphylococcus sequences, and hitting 0 sequences outside of the group. 

<p align="center"><img width=50%% src="https://github.com/BokaiZhu/microbiomeFISH/blob/master/media/arb_design.png"></p>

Hit **Go** , save the resulting .prb file and we are ready for the next step.

In some other cases you might want to tolerate a few outgroup hitting, as some outgroup sequence might belong to the target group but not assigned to that taxonomy with enough confident, discussed in the [paper](https://unix.stackexchange.com/questions/26047/how-to-correctly-add-a-path-to-path), or simply one single probe is naturally incabable to cover some target groups without outgroup hitting. We will discuss more in the optional section.

### Part 2 R

Now you can load your saved .prb file into r for downstream analysis by:
```R
Library(microbiomeFISH)
staph <- read_arb("/directory/to/.prb") # read and format arb output
view(staph)
```
<p align="center"><img width=90%% src="https://github.com/BokaiZhu/microbiomeFISH/blob/master/media/r_input_arnb.png"></p>
From left to right the columns are: candidate target sequence, length of target, region of the target, start site (Ecoli position), in-group sequence coverage, out-group hit (perfect match), out-group hit (+ 0.3 C), out-group hit (+ 0.6 C) and the corresponding candidate probe sequence.

Then we will filter the candidate probes. Here we will perform the hybridization as the protocol described in the [paper](http:https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4135741/), therefore the input of the function will be 35% formamide, 46C hybridization, with 0.39Molar sodium (2 x SSCT). 

We will select the candidate probes with ΔGo2 > -1.5 kcal/mol (Good secondary structure described by [mathFISH](http://mathfish.cee.wisc.edu/helpdocuments.html#deltaG2%20series)), [predicted hybridization effieciency](https://aem.asm.org/content/80/16/5124)  > 85%. You can also select probes with the conventional Tm (at the supplied experiment condition) provided in the table.

```R
# Only test the ones with 100% coverage, since we have plenty of them
high_coverage <- subset(staph,staph$cover==18) 
filtered <- probeFilter(high_coverage,35,46,0.39) # at the very harsh condition
probes <- subset(filtered,filtered$secondary>-1.5 & filtered$Hybeff>0.85)
View(probes)
```
<p align="center"><img width=120%% src="https://github.com/BokaiZhu/microbiomeFISH/blob/master/media/filtered.png"></p>

Here we can see the table has three new columns added to the end : secondary, the ΔGo2 value; Hybeff, the predicted hybridization effieciency; and the Conventional Tm. The filtered probes we got here are bascially different variations of the same location. You can order the probes directly for testing, or you can also use the secondary system ([in method](somelink to paper secondary part)) to test more probes (as we would expect not all probes will work perfectly in the actual experimental validation).

### Part 3 Optional multiple probe design

We have briefly mentioned before, that in some cases, single probe does not provide the desired coverage and specificity. For example, we want to design a probe targeting the class **Gammaproteobacteria**, with Coverage **> 80%** of the sequences and less than **10 hits** outside of the target group. After screening the candidate probes based on our experiment condition (2 x SSCT, 35% formamide, 46C):

```R
gammaproteobacteria=read_arb("~/paper/Num1/code_related/microbiomeFISH/data/gamma_10_80_1000.prb")
lowhit=subset(gammaproteobacteria,gammaproteobacteria$third<=10)
filtered=probeFilter(lowhit,35,46,0.39)
View(filtered)
```
We can see **none** of these probes will perform well in our setting, with the low hybridization efficiency and low Tm.

<p align="center"><img width=120%% src="https://github.com/BokaiZhu/microbiomeFISH/blob/master/media/gamma_80%25_result.png"></p>

How do we tackle this problem? We can combine multiple single probes, with each probe having lower-than-required coverage, together covering the desired numbers and providing specificity. In the package, we provided two functions to combine and test the coverage and specificity of 2 or 3 probe-combinations. Those steps require another stand-alone software **Usearch**, an ultrafast blast tool. We also suggest this step to be performed on a server, since it could take time and space.

Once the Usearch is installed in your system, we can use the ```Dual_optimization()``` and ```Trio_optimization()```functions in r.

Coming back to the gammaproteobacteria probe designing problem, with the strategy of combining single probes, we can let ARB start with lower coverage requirements. This time, we let ARB design probes >55% coverage and 10 out-group hits, instead of 80% and 10 we tried before.

```R
## in R

gammaproteobacteria=read_arb("~/paper/Num1/code_related/microbiomeFISH/data/gamma_10_55_1000.prb") # the 55-10 ARB results
lowhit=subset(gammaproteobacteria,gammaproteobacteria$third<=10) # less than 10 hits outgroup
filtered=probeFilter(lowhit,35,46,0.39) # filters conditions as before
candidate=subset(filtered,filtered$secondary>-2 & filtered$Hybeff>0.8) # filtered-out single probes

# then the combining and testing the probes
# the input include: the candidate table from previous step
# target group name
# number of combinations to try
# directory to usearch
# reference sequence pool file (here the class.fasta file)
dual_comb=Dual_optimization(candidate,target_group = "Gammaproteobacteria",
                            num_result=3000,
                            usearch_location="~/applications/usearch/usearch6.0.98_i86linux32",
                            reference_fasta = "~/paper/Num1/code_related/microbiomeFISH/data/Class.fasta")
```
 And the result produced by combining two probes:
 <p align="center"><img width=70%% src="https://github.com/BokaiZhu/microbiomeFISH/blob/master/media/pool_result.png"></p>

We can see by combing low coverage pools we can acquire probe sets that will **work well in our experimental conditions**, and at the same time with **coverage > 80% and optimal out-group hitting**. 

For other even more challenging target groups, as we have shown in the [paper]() by targeting the phylum **Firmicutes**, we used ARB to find probes covering **>30%** with desired out-group hitting, then used function ```Trio_optimization()``` to combine three probes together, achieving a **77%** coverage of the diverse Firmicutes.

### F&Q

**Q**: I'm having trouble installing arb/ using the R package in Windows.

**A**: For installing arb in Windows, please follow the instructions from their website, basically installing from source. Also when using the R package in Windows, because the command of calling outside functions is different from Mac and Linux, it is suggested to change some of the source code in the package when we are using 'systems' command: for example use ```system(paste("bash -c",usearch_location,"-usearch_global", "temp.fasta -db",temp_header_fasta, "-id 1 -strand plus -maxaccepts 100000 -blast6out temp2.txt --quiet"))``` instead.

**Q**: During target site selection in ARB, what parameters I should input?

**A**: Generally, depends on the biological question you want to ask. Usually, a probe with 100% coverage and 0 outgroup hitting will be rare to find. Play with the parameters a few times until you feel comfotable about the result. Also, you should tolerate some out-group hitting sometimes. You can check the matching result in ARB, and if you see your Staphylococcus probe is hitting sequences annotated as "unknown_staphylococcus", it is advised to ignore these hitting.


