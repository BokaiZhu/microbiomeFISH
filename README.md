<p align="left"><img width=30%% src="https://github.com/BokaiZhu/microbiomeFISH/blob/master/media/microbiome_fish.png"></p>

# microbiomeFISH
A protocol for designing oligos for microbiome samples. Under construction now

## Table of content

- [Preparation](#preparation)
    - [ARB install](#ARB-installation)
    - [Sequence pool database](#Sequence-pool-database)
    - [microbiomeFISH install](#R-package-and-dependencies)


## Preparation

Several softwares/datafiles are required for this protocol:
1. **ARB** for initial probe design
2. The curated **human intestinal 16s rRNA pool** files, this is the probe designing pool 
3. **R**, **OligoArrayAux** and **microbiomeFISH** r package for downstream probe screening, modeifeied from [DECIPHER](http://www2.decipher.codes/)

### ARB installation and setup

[The ARB software](http://http://www.arb-home.de/) is a graphically oriented package comprising various tools for sequence database handling and data analysis. We will use this software for intial targeting sequece identification. The installation guidence is [here](http://www.arb-home.de/downloads.html).

After successfuly installing ARB, you should be able to fire it up in terminal by typing arb:

<p align="center"><img width=80%% src="https://github.com/BokaiZhu/microbiomeFISH/blob/master/media/arb_start.gif"></p>

### Sequence Pool Database

These files are the curated sequence pool containing 12,932 near full length 16s rRNA sequences, assigned with taxonomy information. The detailed process of producing these files can be found in the paper.

Here we have 6 files in the data folder, each with the same sequence pool fasta file, but header contains the assigned taxonomy information at each phylogeny level. 

<p align="left"><img width=20%% src="https://github.com/BokaiZhu/microbiomeFISH/blob/master/media/pool_files.png"></p>

You can [download](https://github.com/BokaiZhu/microbiomeFISH/tree/master/data) the files and use them as inputs for probe design.


### R package and dependencies

[R](https://www.r-project.org/) is a prerequiste for this part (not too surprising). You can install the microbiomeFISH r package by in R by:

```R
install.packages("devtools") # if you have not installed "devtools" package
devtools::install_github("BokaiZhu/microbiomeFISH")
```

