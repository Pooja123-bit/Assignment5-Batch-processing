library(tidyverse)
library(plyr)



Batch.Files<-list.files("Batch.Files",full=TRUE,pattern="4")

phy<-adply(.data=Batch.Files, .margins=1, function(file) {
  
  #read the data
  d<-read.table(file, sep="\t", skip=10, header=TRUE, fileEncoding="ISO-8859-1",
                stringsAsFactors=FALSE, quote="\"",check.names=FALSE,
                encoding="UTF-8",na.strings=9999.99)
  
  
  #clean names
  head<-names(d)
  head<-str_replace(head, "\\(.*\\)", "")
  head<-str_trim(head)
  head<-make.names(head)
  head<-tolower(head)
  head<-str_replace(head,fixed(",."),".")
  
  #assign names
  names(d) = head
  
  #create a proper date time format
  date<-scan(file,what="character",skip=1,nlines=1,quiet=TRUE)
  
  d$date<-date[2]
  
  d$dateTime<-str_c(d$date, d$ttime, sep=" ")
  
  d$dateTime<-as.POSIXct(strptime(d$dateTime,format="%m/%d/%y %H:%M:%OS",
                                  tz="America/New_York"))
  
  return(d)
},.inform=T,.progress = "text")