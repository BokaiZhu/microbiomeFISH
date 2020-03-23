


probeFilter= function(candidate_probes, FA, Temperature, ions){
  candidate_probes$secondary=NA
  # first calculate the secondary structure
  for (i in c(1:nrow(candidate_probes))){
    sequence2test=candidate_probes$probe[i]
    # geting the secondary structure through oligoarray aux
    dG2=as.numeric(system(paste("hybrid-ss-min -n DNA -t", Temperature, "-T",Temperature,"-N",1,"-E -q", sequence2test),intern=TRUE))
    candidate_probes$secondary[i]=dG2
  }

  # second caluculate the hybirdization efficiency, with the DECIPHER calculateefficiency FISH function
  candidate_probes$Hybeff=NA
  for (i in c(1:nrow(candidate_probes))){
    sequence2test=candidate_probes$probe[i]
    target2test=candidate_probes$target[i]
    result=as.data.frame(CalculateEfficiencyFISH(sequence2test,target2test, temp= Temperature, P=250e-9, ions=ions, FA))
    candidate_probes$Hybeff[i]=result$HybEff
  }
  # calculate the Tm, corrected by Ion and formamide concentration
  for (i in c(1:nrow(candidate_probes))){
    sequence2test=as.character(candidate_probes$probe[i])
    Tm=Tm_GC(sequence2test,Na=ions*1000)
    Tm_FA=chem_correction(Tm, fmd=FA)
    candidate_probes$Tm[i]=Tm_FA
  }

  return(candidate_probes)
}
