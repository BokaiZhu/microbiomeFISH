<p align="left"><img width=20%% src="https://github.com/BokaiZhu/microbiomeFISH/blob/master/media/microbiome_fish.png"></p>

# microbiomeFISH
A protocol for designing oligos for microbiome samples. Under construction now
<p align="left"><img width=80%% src="https://github.com/BokaiZhu/microbiomeFISH/blob/master/media/place-holder.png"></p>

## Table of content

- [Preparation](#preparation)
    - [ARB install](#ARB-installation)
    - [Sequence pool database](#Sequence-pool-database)
    - [microbiomeFISH install](#R-package-and-dependencies)
- [Probe designing showcase](#probe-designing-showcase)
    - [Part 1 arb](#part-1-arb)
    - [Part 2 R](#part-2-r)
- [F&Q](#f&q)    

## Preparation

Several softwares/datafiles are required for this protocol:
1. **ARB** for initial probe design
2. The curated **human intestinal 16s rRNA pool** files, this is the probe designing pool 
3. **R**, **OligoArrayAux** and **microbiomeFISH** r package for downstream probe screening, modeifeied from [DECIPHER](http://www2.decipher.codes/)

### ARB installation and setup

[The ARB software](http://http://www.arb-home.de/) is a graphically oriented package comprising various tools for sequence database handling and data analysis. We will use this software for intial targeting sequece identification. The installation files are [here](http://www.arb-home.de/downloads.html). The detailed installation instruction is [here](http://download.arb-home.de/release/latest/arb_README.txt)

After successfuly installing ARB, you should be able to fire it up in terminal by typing arb:

<p align="center"><img width=70%% src="https://github.com/BokaiZhu/microbiomeFISH/blob/master/media/arb_start.gif"></p>

### Sequence Pool Database

These files are the curated sequence pool containing 12,932 near full length 16s rRNA sequences, assigned with taxonomy information. The detailed process of producing these files can be found in the [paper]().

[Here](https://github.com/BokaiZhu/microbiomeFISH/tree/master/data) we have 6 files in the data folder, each with the same sequence pool fasta file, but header contains the assigned taxonomy information at each phylogeny level. You can download the fasta files and use them as inputs for probe design.


### R package and dependencies

[R](https://www.r-project.org/) is a prerequiste for this part (not too surprising). You can install the microbiomeFISH r package in R by:

```R
install.packages("devtools") # if you have not installed "devtools" package yet
install.packages("BiocManager") # if you have not installed bioconductor yet
devtools::install_github("BokaiZhu/microbiomeFISH",auth_token="230b203a38ae97ff5187cb24ba75205dce2e27d5", repos=BiocManager::repositories(),force = TRUE)
```

This r package also requires **OligoArrayAux** to calculate the secondary structure of the probes. [Download](http://mfold.rna.albany.edu/?q=DINAMelt/OligoArrayAux) and install the software. 

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
### wait for yh's code to check
export PATH=$PATH:/Path/To/Jellyfish/jellyfish-2.2.6
```

Test if the software is installed correctly by runing the code in r :

```R
### in R
system("hybrid-min -V") # calling the hybrid-min function in r

# or when you are using R on a windows system:
system("bash something hybrid-min -V") # calling the hybrid-min function in r
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
Now should be able to call oligoarrayaux in R on a server.



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

Then we will filter the candidate probes. Here we will perform the hybridization as the protocol described in the [paper](http:), therefore the input of the function will be 35% formamide, 46C hybridization, with 0.39Molar sodium (2 x SSCT). 

We will select the candidate probes with ΔGo2 > -1.5 kcal/mol (Good secondary structure described by [mathFISH](http://mathfish.cee.wisc.edu/helpdocuments.html#deltaG2%20series)), [predicted hybridization effieciency](https://aem.asm.org/content/80/16/5124)  > 85%. You can also select probes with the conventional Tm (at the supplied experiment condition) provided in the table.

```R
# only test the ones with 100% coverage, since we have plenty of them
high_coverage <- subset(staph,staph$cover==18) 
filtered <- probeFilter(high_coverage,35,46,0.39) # at the very harsh condidtion
probes <- subset(filtered,filtered$secondary>-1.5 & filtered$Hybeff>0.85)
View(probes)
```
<p align="center"><img width=120%% src="https://github.com/BokaiZhu/microbiomeFISH/blob/master/media/filtered.png"></p>

Here we can see the table has three new columns added to the end : secondary, the ΔGo2 value; Hybeff, the predicted hybridization effieciency; and the Conventional Tm. The filtered probes we got here are bascially different variations of the same location. You can order the probes directly for testing, or you can also use the secondary system ([in method](somelink to paper secondary part)) to test more probes (as we would expect not all probes will work perfectly in the actual experimental validation).

### F&Q

1. Q: I'm having trouble installing arb

**Q**: During target site selection in ARB, what parameters I should input?

**A**: Generally, depends on the biological question you want to ask. Usually a probe with 100% coverage and 0 outgroup hitting will be rare to find. Play with the parameters a few times until you feel comfotable about the result. Also, you should tolerate some out-group hitting sometimes. You can check the matching result in ARB, and if you see your Staphylococcus probe is hitting sequences annotated as "unknown_staphylococcus", it is advised to ignore these hitting.


