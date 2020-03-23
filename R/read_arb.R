

read_arb= function(prb_file){
  read_in=read.table(prb_file, skip = 8,sep='|', fill = NA)
  # read the table
  suppressWarnings({
    formated=read_in %>% separate(V1,c("target","len","location","pos","start","qual","cover")) %>% separate(V2,c("empty","first","second","third"),sep = "[ ]{1,}")
    })
  # this step only takes in certain columns in the original file
  # ignore the warnings

  ### more formating
  formated=formated[,c(-4,-6,-8)] # get rid of the unused columns
  formated[formated=="-"]=0 # change - to 0 hits
  formated[,c("len","start","cover","first","second","third")]=sapply(formated[,c("len","start","cover","first","second","third")], as.integer) # change to int

  formated$target=RNAStringSet(formated$target) # change the format to rnastring set
  formated$probe=reverseComplement(formated$target)
  formated$probe=gsub("U","T",formated$probe) # change probe sequence from RNA to DNA

  return(formated)
}

