setwd("/home/will-of-d/Desktop/MovieRecommendationSystem")
library(Matrix)
library(xgboost)
library(caret)



train_df <- read.csv("datasets/train.csv")
user_avg_dict = c()
movie_avg_dict = c()

# Model 1 : (user_avg,movie_avg,global_avg), rating - 3 features
# Model 2 : Collaborative filtering SVD - mathematical model
# Model 3 : (top5_users, top5_movies, model1_output,model2_output), rating - 12 features

# Creating dataset for model 1

create_dataset_model1 <- function(df,is_test = FALSE){
  user_avg_vec = c()
  for(user_id in df$userId){
    if(length(user_avg_dict)==0 || is.na(user_avg_dict[as.character(user_id)])){
      avg <- get_avg_user_rating(user_id)
      user_avg_vec <- append(user_avg_vec,avg)
      user_avg_dict[as.character(user_id)] = avg
    }else{
      user_avg_vec <- append(user_avg_vec,user_avg_dict[as.character(user_id)])
    }
  }
  df$user_avg = user_avg_vec
  movie_avg_vec = c()
  for(movie_id in df$movieId){
    if(length(movie_avg_dict)==0 || is.na(movie_avg_dict[as.character(movie_id)])){
      avg <- get_avg_movie_rating(movie_id)
      movie_avg_vec <- append(movie_avg_vec,avg)
      movie_avg_dict[as.character(movie_id)] = avg
    }else{
      movie_avg_vec <- append(movie_avg_vec,movie_avg_dict[as.character(movie_id)])
    }
  }
  df$movie_avg = movie_avg_vec
  df$global_avg = rep(global_avg,nrow(df))
  rating <- df$rating
  df$rating <- NULL
  df$rating <- rating
  if(is_test){
    return(df)
  }
  if(!file.exists("datasets/models/model1_train.csv")){
    write.csv(df,"datasets/models/model1_train.csv",row.names = FALSE)
  }
}

create_dataset_model1(train_df)

m1_train_df = read.csv("datasets/models/model1_train.csv")
head(m1_train_df)

data = m1_train_df[,3:5]
y = m1_train_df[,6]

train_model <- function(X,y){
  set.seed(12)
  xgb_m1 <- xgboost(data = data.matrix(X), 
                 label = data.matrix(y), 
                 eta = 0.1,
                 max_depth = 17, 
                 nround=200, 
                 subsample = 0.5,
                 colsample_bytree = 0.5,
                 eval_metric = "rmse",
                 objective = "reg:linear",
                 nthread =3,
                 base_score = global_avg
  )
  return(xgb_m1)
}
                        #### CREATING FOR TRAIN DATASET #####
head(data)
m1_xgb = train_model(data,y)
predict_ratings = predict(m1_xgb,data.matrix(data)) 

M1_TRAIN_EVAL = evaluate_model(y,predict_ratings)

train_df = read.csv("datasets/train.csv")

train_df$m1_ratings = predict_ratings
train_df$rating <- NULL
if(!file.exists("datasets/models/model1_train_ratings.csv")){
  write.csv(train_df,"datasets/models/model1_train_ratings.csv",row.names = FALSE)
}
m1_df = read.csv("datasets/models/model1_train_ratings.csv")

                          #### CREATING FOR TEST DATASET #####

test_df = read.csv("datasets/test.csv")
head(test_df)

test_df = create_dataset_model1(test_df,is_test = TRUE)
head(test_df)

X_test = test_df[,3:5]
y_test = test_df[,6]
y_pred = predict(m1_xgb,data.matrix(X_test))
M1_TEST_EVAL = evaluate_model(y_test,y_pred)
test_df = read.csv("datasets/test.csv")
test_df$m1_ratings = y_pred
test_df$rating <- NULL
if(!file.exists("datasets/models/model1_test_ratings.csv")){
  write.csv(test_df,"datasets/models/model1_test_ratings.csv",row.names = FALSE)
}

m1_test_df = read.csv("datasets/models/model1_test_ratings.csv")
nrow(m1_test_df)
