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

### Sequence pool database

These files are the curated sequence pool containing 12,932 near full length 16s rRNA sequences, assigned with taxonomy information. The detailed process of producing these files can be found in the paper.




### R package and dependencies

The latest version can be installed via composer too. This is especially useful if you want to create new TYPO3 installations automatically or play with the latest code. You need to install the composer package first if it isn't already available:
