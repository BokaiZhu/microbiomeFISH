

Trio_optimization=function(df,target_group,usearch_location,reference_fasta,num_result=200){

  locations=unique(df$location)
  combination=combn(locations,3) # the combinations of the locations, combination of three

  ## first we need to make a temp fasta file with unique header, modified with the input reference data
  awk_command="awk '/^>/{$0=$0\"_\"(++i)}1'"
  temp_header_fasta=paste0(reference_fasta,".temp.fa")
  system(paste(awk_command,reference_fasta,">",temp_header_fasta))

  # a dataframe to store the combination

  per_comb=as.integer(num_result/dim(combination)[2]) # the number of results per combination

  contain_comb=matrix(NA,per_comb*dim(combination)[2],3) # make the result table, with rows of per_com*conbination possibilities
  contain_comb=as.data.frame(contain_comb)
  colnames(contain_comb)=c("target1","target2","target3")

  for (i in c(1:dim(combination)[2])){ # each possible combinations of locations

    target_comb=subset(df,df$location==combination[1,i] | df$location==combination[2,i]| df$location==combination[3,i]) # a subset that only contains the target locations

    for (j in c(1:per_comb)){
      contain_comb$target1[(i-1)*per_comb+j]=as.character(df[sample(which(df$location==combination[1,i]),1),"target"]) # sample one random from combination 1 member 1
      contain_comb$target2[(i-1)*per_comb+j]=as.character(df[sample(which(df$location==combination[2,i]),1),"target"])
      contain_comb$target3[(i-1)*per_comb+j]=as.character(df[sample(which(df$location==combination[3,i]),1),"target"])

      contain_comb$probe1[(i-1)*per_comb+j]=gsub("U","T",reverseComplement(RNAStringSet(contain_comb$target1[(i-1)*per_comb+j]))) # also get the corresponding probe sequence
      contain_comb$probe2[(i-1)*per_comb+j]=gsub("U","T",reverseComplement(RNAStringSet(contain_comb$target2[(i-1)*per_comb+j])))
      contain_comb$probe3[(i-1)*per_comb+j]=gsub("U","T",reverseComplement(RNAStringSet(contain_comb$target3[(i-1)*per_comb+j])))

    }

  }

  # now we make the fasta files:
  contain_comb$goodhit=NA
  contain_comb$badhit=NA

  # progress bar part
  pb <- progress_bar$new(
    format = "  progress [:bar] :percent eta: :eta",
    total = nrow(contain_comb), clear = FALSE, width= 60)
  # progress bar preset end

  for (m in c(1: nrow(contain_comb))){
    # progress bar
    pb$tick()
    Sys.sleep(1 / 100)
    # bar end
    write.fasta(contain_comb[m,c("target1","target2","target3")],c("1","2","3"),"temp.fasta")

    # start the usearching
    system(paste(usearch_location,"-usearch_global", "temp.fasta -db",temp_header_fasta, "-id 1 -strand plus -maxaccepts 100000 -blast6out temp2.txt --quiet"))
    #system("~/applications/usearch/usearch_test -usearch_global temp.fasta -db phylum_header.fasta -id 1 -strand plus -maxaccepts 10000 -blast6out temp2.txt")
    #
    if (file.size("./temp2.txt") == 0) next
    # empty temp2.txt protection

    # check the result
    usearch_out=read.table("./temp2.txt")

    names=unique(usearch_out$V1)
    probe1=subset(usearch_out,usearch_out$V1==names[1])
    probe2=subset(usearch_out,usearch_out$V1==names[2])
    probe3=subset(usearch_out,usearch_out$V1==names[3])

    probe1_target=unique(probe1$V2) # actually no unique needed here
    probe2_target=unique(probe2$V2)
    probe3_target=unique(probe3$V2)

    combine=c(as.character(probe1_target),as.character(probe2_target),as.character(probe3_target))
    goodhit=sum(grepl(target_group,unique(combine))) # the correct hit number
    badhit=length(unique(combine))-goodhit # out grouphit

    contain_comb$goodhit[m]=goodhit
    contain_comb$badhit[m]=badhit

    # clear out temp fasta files for usearch
    file.remove("temp.fasta")
    file.remove("temp2.txt")
    # clear out complete
  }

  # clear out unused columns
  contain_comb$target1=NULL
  contain_comb$target2=NULL
  file.remove(temp_header_fasta)
  # clear out complete
  return(contain_comb)
}
