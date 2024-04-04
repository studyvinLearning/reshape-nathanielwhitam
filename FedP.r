data(federalistPapers, package='syllogi')


#1 create dataframe
FP<-as.data.frame(federalistPapers[[1]]$meta)
for (i in 2:length(federalistPapers)){
  FP<-rbind(FP,federalistPapers[[i]]$meta)
}
FP<-subset(FP,select=-3)

#2 get DOW for each paper
library(lubridate)
FP["DOW"]<-wday(FP$date,label = TRUE)


#3get count of paper by DOW and author
FPCnt<-aggregate(number ~  DOW + author, data = FP, FUN = length) #got idea from https://stackoverflow.com/questions/9809166/count-number-of-rows-within-each-group
colnames(FPCnt)[3]<-"Count"

#4
temp<-subset(FP,select=c(1,2,4))
class(temp$date)
Author_Date<-tidyr::pivot_wider(temp, #not sure how to stop pivot from turning the dates into ints
                  id_cols= 'number',
                   names_from = 'author', ##cat col name
                   values_from = 'date' ##values col name
)
