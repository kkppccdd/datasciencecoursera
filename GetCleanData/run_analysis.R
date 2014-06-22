
# read data of train
X_train<-read.csv(file="train/X_train.txt",header=FALSE,sep="")
y_train<-read.csv(file="train/y_train.txt",header=FALSE,sep="")
subject_train<-read.csv(file="train/subject_train.txt",header=FALSE,sep="")

# merge train data
train<-merge(y_train,X_train,by=0)
train<-merge(subject_train,train,by=0)
train<-train[,c(2,4:565)]

# read data of test
X_test<-read.csv(file="test/X_test.txt",header=FALSE,sep="")
y_test<-read.csv(file="test/y_test.txt",header=FALSE,sep="")
subject_test<-read.csv(file="test/subject_test.txt",header=FALSE,sep="")

# merge test data
test<-merge(y_test,X_test,by=0)
test<-merge(subject_test,test,by=0)
test<-test[,c(2,4:565)]

# merge data of train and test
dataset<-rbind(train,test)

extractData<-t(apply(dataset,1,FUN=function(e){c(e[1],e[2],mean(e[3:563]),sd(e[3:563]))}))
colnames(extractData)<-c("subject","activityCode","mean","sd")

activityLabels<-read.csv("activity_labels.txt",header=FALSE,sep="")
colnames(activityLabels)<-c("activityCode","label")


# merge label and extract data
x<-merge(extractData,activityLabels,by=c("activityCode"))
extractData<-x[,c("subject","label","mean","sd")]

# calculate average fro variables mean and sd
x<-aggregate(extractData[,],by=list(subject=extractData$subject,label=extractData$label),mean)

tidyData<-x[,c(1,2,5,6)]

# write tidyDat to file
write.csv(tidyData,file="tidy.csv",row.names=FALSE)
