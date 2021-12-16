setwd("/home/will-of-d/Desktop/MovieRecommendationSystem")
df <- read.csv("datasets/ratings.csv") 
df$timestamp <- as.POSIXct(as.numeric(df$timestamp), origin = '1970-01-01', tz = 'GMT')
df <- df[order(df$timestamp),]
sprintf("No of Nan values in the dataset is %d",sum(is.na(df)))
total_rows <- nrow(df)
sprintf("No of rows in dataset is %d",total_rows)
df <- subset(df,select = -c(timestamp))

df <- df[1:10000,]
sprintf("No of rows in dataset is %d",nrow(df))
users <- unique(df[c("userId")])
if(!file.exists("datasets/users_idx.csv")){
  write.csv(users,"datasets/users_idx.csv",row.names = FALSE)
}else{
  print("Already exists")
}
movies <- unique(df[c("movieId")])
if(!file.exists("datasets/movies_idx.csv")){
  write.csv(movies,"datasets/movies_idx.csv",row.names = FALSE)
}

train_df <- df[1:(0.8*nrow(df)),]
test_df <- df[(0.8*nrow(df)+1):nrow(df),]
sprintf("No of rows in train_df is %d",nrow(train_df))
sprintf("No of rows in test_df is %d",nrow(test_df))
if(!file.exists("datasets/train.csv")){
  write.csv(train_df,"datasets/train.csv",row.names = FALSE)
}
if(!file.exists("datasets/test.csv")){
  write.csv(test_df,"datasets/test.csv",row.names = FALSE)
}

