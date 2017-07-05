#load and rename test data
subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt")
y_test<-read.table("UCI HAR Dataset/test/y_test.txt")
x_test<-read.table("UCI HAR Dataset/test/x_test.txt")
features<-read.table("UCI HAR Dataset/features.txt")
Res<-c()
colnames(x_test)<-features$V2
colnames(subject_test)<-c("subject_id")
colnames(y_test)<-c("activity_id")
dataTest<-cbind(subject_test,y_test,x_test)

#load and rename train data 
subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt")
y_train<-read.table("UCI HAR Dataset/train/y_train.txt")
x_train<-read.table("UCI HAR Dataset/train/X_train.txt")
features<-read.table("UCI HAR Dataset/features.txt")

colnames(x_train)<-features$V2
colnames(subject_train)<-c("subject_id")
colnames(y_train)<-c("activity_id")
dataTrain<-cbind(subject_train,y_train,x_train)

#bind the data test and data train
data<-rbind(dataTest,dataTrain)

library(dplyr)

colnames(data)<-gsub("-","",names(data))
colnames(data)<-gsub("\\)","",names(data))
colnames(data)<-gsub("\\(","",names(data))
colnames(data)<-gsub(",","",names(data))


#extract data with mean and std
data<-data[grepl(".*mean.*|.*std.*|.*_id.*", names(data))]
library(reshape2)
#load activity_lab and associate activities to activity_id
activity_lab<-read.table("UCI HAR Dataset/activity_labels.txt")
activity_lab[,2] <- as.character(activity_lab[,2])

data$activity_id <- factor(data$activity_id, levels = activity_lab[,1], labels = activity_lab[,2])
data$subject_id <- as.factor(data$subject_id)
data<- melt(data, id = c("subject_id", "activity_id"))

#calculate the mean to all data

data_mean <- dcast(data, subject_id + activity_id ~ Res, mean)

write.table(data, "tidy.txt", row.names = FALSE, quote = FALSE)
