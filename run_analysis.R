library("dplyr")
merge.with.order <- function(x,y, ..., sort = T, keep_order)
{
  # this function works just like merge, only that it adds the option to return the merged data.frame ordered by x (1) or by y (2)
  add.id.column.to.data <- function(DATA)
  {
    data.frame(DATA, id... = seq_len(nrow(DATA)))
  }
  # add.id.column.to.data(data.frame(x = rnorm(5), x2 = rnorm(5)))
  order.by.id...and.remove.it <- function(DATA)
  {
    # gets in a data.frame with the "id..." column.  Orders by it and returns it
    if(!any(colnames(DATA)=="id...")) stop("The function order.by.id...and.remove.it only works with data.frame objects which includes the 'id...' order column")
    
    ss_r <- order(DATA$id...)
    ss_c <- colnames(DATA) != "id..."
    DATA[ss_r, ss_c]
  }
  
  # tmp <- function(x) x==1; 1	# why we must check what to do if it is missing or not...
  # tmp()
  
  if(!missing(keep_order))
  {
    if(keep_order == 1) return(order.by.id...and.remove.it(merge(x=add.id.column.to.data(x),y=y,..., sort = FALSE)))
    if(keep_order == 2) return(order.by.id...and.remove.it(merge(x=x,y=add.id.column.to.data(y),..., sort = FALSE)))
    # if you didn't get "return" by now - issue a warning.
    warning("The function merge.with.order only accepts NULL/1/2 values for the keep_order variable")
  } else {return(merge(x=x,y=y,..., sort = sort))}
}

#read the activity lables
activity_labels<-read.table("activity_labels.txt")

#read the activity code
y_test<-read.table("y_test.txt")
y_train<-read.table("y_train.txt")
activity_code<-rbind(y_train,y_test)

activities<-merge.with.order(activity_code, activity_labels,by="V1", sort=F, all.y=T, keep_order =1)
colnames(activities) <- c("1", "Activity")

#measurements
x_test<-read.table("x_test.txt")
x_train<-read.table("x_train.txt")
measurements<-rbind(x_train,x_test)

#features
features<-read.table("features.txt")
colnames(measurements) <- features[,2]

newColNames <- c()
filteredMeasurements <- data.frame(measurements[,1])
# selecting only the columns with mean() and std() in the name
for(label in colnames(measurements)) {
  if(grepl("mean()", label) || grepl("std()", label)) {
    filteredMeasurements <- cbind(filteredMeasurements, measurements[[label]])
    label <- gsub("-", " ", label, fixed=TRUE)
    label <- gsub("(", "", label, fixed=TRUE)
    label <- gsub(")", "", label, fixed=TRUE)
    newColNames <- c(newColNames, label)
  }
}

filteredMeasurements <- filteredMeasurements[,-1]
newColNames <- make.names(newColNames)
colnames(filteredMeasurements) <- newColNames
filteredMeasurements <- cbind(activities[,2], filteredMeasurements)
colnames(filteredMeasurements)[1] <- "Activity"

#subjects
subject_test <-read.table("subject_test.txt")
subject_train <-read.table("subject_train.txt")
subjects <- rbind(subject_train, subject_test)
filteredMeasurements <- cbind(subjects[,1], filteredMeasurements)
colnames(filteredMeasurements)[1] <- "Subjects"

finalResult <- filteredMeasurements %>% group_by(Subjects,Activity) %>% summarise_each(funs(mean))
write.table(finalResult, "mean_result.txt", row.names = FALSE)
