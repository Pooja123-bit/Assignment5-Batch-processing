library(tidyverse)
library(plyr)



Batch.Files<-list.files("Batch.Files",full=TRUE,pattern="4")

phy<-adply(.data=Batch.Files, .margins=1, function(file) {
  
  d<-read_table(file, col_names=T)
  d = d[-1,]
 
  d$COND=NULL
  d$match=1:nrow(d)
   
  head<-names(d)
  head<-str_replace(head, "\\(.*\\)", "")
  head<-str_trim(head)
  head<-make.names(head)
  head<-tolower(head)
  head<-str_replace(head,fixed(",."),".")
  
  names(d) = head
  
  date<-scan(file,what="character",skip=1,nlines=1,quiet=TRUE)
  
  d$date<-date[2]
  
  d$dateTime<-str_c(d$date, d$time, sep=" ")
  
  d$dateTime<-as.POSIXct(strptime(d$dateTime,format="%m/%d/%y %H:%M:%OS",
                                  tz="America/New_York"))
  
  return(d)
},.inform=T,.progress = "text")
