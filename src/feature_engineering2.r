setwd("/home/will-of-d/Desktop/MovieRecommendationSystem")
library(Matrix)
library(recommenderlab)

# Model 1 : (user_avg,movie_avg,global_avg), rating - 3 features
# Model 2 : Collaborative filtering SVD - mathematical model
# Model 3 : (top5_users, top5_movies, model1_output,model2_output), rating - 12 features

# Creating dataset for model 2

sparse_mat = readMM("res/train_sparse_matrix.txt")
ratings_matrix = as(sparse_mat,"realRatingMatrix")
                  #### CREATING FOR TRAIN DATASET #####
svdf20_model <- recommenderlab::Recommender(data=ratings_matrix,
                                            method = "SVDF",
                                            parameter=list(k=20))

                  

result = recommenderlab::predict(svdf20_model,ratings_matrix,type="ratingMatrix")

svdf20_eval = recommenderlab::calcPredictionAccuracy(result,
                                       ratings_matrix,
                                       byUser=FALSE,
                                       given=NULL,
                                       goodRating = 5)
svdf20_eval

M2_TRAIN_EVAL =  c(svdf20_eval["RMSE"],
                   svdf20_eval["MSE"],
                    svdf20_eval["MAE"])

result_matrix = as(result,"dgCMatrix")

if(!file.exists("datasets/models/model2_train_matrix.txt")){
  writeMM(result_matrix,"datasets/models/model2_train_matrix.txt")
}

train_result_matrix = readMM("datasets/models/model2_train_matrix.txt")
print(nrow(train_result_matrix))
ncol(train_result_matrix)
print(train_result_matrix[1:5,1:5])

train_df <- read.csv("datasets/train.csv")


create_dataset_model2 <- function(df,isTest = FALSE){
  svdf_user_rat_vec = c()
  print(nrow(df))
  for(i in 1:nrow(df)){
    user_id = df[i,1]
    movie_id = df[i,2]
    user_idx = get_user_idx(user_id)
    movie_idx = get_movie_idx(movie_id)
    if(!isTest){
      pred_rat = train_result_matrix[user_idx,movie_idx]
      svdf_user_rat_vec <- append(svdf_user_rat_vec,pred_rat)
    }
    else{
      pred_rat = test_result_matrix[user_idx,movie_idx]
      svdf_user_rat_vec <- append(svdf_user_rat_vec,pred_rat)
    }
  }
  
  df$model2_ratings <- svdf_user_rat_vec
  rating <- df$rating
  df$rating <- NULL
  df$rating <- rating
  if(!isTest){
    if(!file.exists("datasets/models/model2_train_ratings.csv")){
      write.csv(df,"datasets/models/model2_train_ratings.csv",row.names = FALSE)
    }
  }else{
    if(!file.exists("datasets/models/model2_test_ratings.csv")){
      write.csv(df,"datasets/models/model2_test_ratings.csv",row.names = FALSE)
    }
  }
}

create_dataset_model2(train_df)

                      #### CREATING FOR TEST DATASET #####

test_sparse_mat = readMM("res/test_sparse_matrix.txt")
test_rm = as(test_sparse_mat,"realRatingMatrix")

svdf20_model <- recommenderlab::Recommender(data=test_rm,
                                            method = "SVDF",
                                            parameter=list(k=20))

test_pred_mat = recommenderlab::predict(svdf20_model,test_rm,type="ratingMatrix")

test_eval = recommenderlab::calcPredictionAccuracy(test_pred_mat,
                                                     test_rm,
                                                     byUser=FALSE,
                                                     given=NULL,
                                                     goodRating = 5)
test_eval

M2_TEST_EVAL =  c(test_eval["RMSE"],
                   test_eval["MSE"],
                   test_eval["MAE"])

test_result_matrix = as(test_pred_mat,"dgCMatrix")

if(!file.exists("datasets/models/model2_test_matrix.txt")){
  writeMM(test_result_matrix,"datasets/models/model2_test_matrix.txt")
}



svdf_user_rat_vec = c()
test_df <- read.csv("datasets/test.csv")

create_dataset_model2(test_df,TRUE)
m2_test_df = read.csv("datasets/models/model2_test_ratings.csv")
