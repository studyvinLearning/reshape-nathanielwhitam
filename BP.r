BP<- readRDS("bloodPressure.RDS")


#1 reshaping
names =colnames(BP)[2:63]
BPL<-tidyr::pivot_longer(BP, cols = names,
                        names_to = 'group', ## new categorical cal name
                        values_to = 'bp' ## new col name for the values 
)
BPL["systolic_diastolic"]<-NA
BPL["date"]<-NA
for (i in 1:nrow(BPL)){
  temp<-BPL[i,'group']
  pos<-gregexpr(pattern=" [1-9]",temp)
  BPL[i,"date"]=substr(temp,pos[[1]]+1,nchar(temp))
  BPL[i,"systolic_diastolic"]=substr(temp,1,pos[[1]]-1)
  
}
#2
library(lubridate)
BPL$date<-ymd(BPL$date)
BPL<-subset(BPL,select=c(1,3,4,5))#BPL  final df with 4 cols with fixed dates


#3
BPLD<-BPL
BPLD["DOW"]<-wday(BPLD$date,label = TRUE)
DOWMeans<-aggregate(bp ~  DOW + systolic_diastolic, data = BPLD, FUN = mean)
#DOWMeans, Calculated means 