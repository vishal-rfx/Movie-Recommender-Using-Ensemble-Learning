setwd("/home/will-of-d/Desktop/MovieRecommendationSystem")
library(Matrix)
library(caret)

sparse_mat <- readMM("res/train_sparse_matrix.txt")
MS_matrix <- readMM("res/MS_matrix.txt")
US_matrix <- readMM("res/US_matrix.txt")

users_idx_df = read.csv("datasets/users_idx.csv")
print(nrow(users_idx_df))
movies_idx_df =read.csv("datasets/movies_idx.csv")
test_df = read.csv("datasets/test.csv")

get_user_idx <- function(user_id){
  return(which(users_idx_df$userId == user_id))      
}

get_movie_idx <- function(movie_id){
  return(which(movies_idx_df$movieId == movie_id))
}

get_avg_user_rating <- function(user_id){
  user_idx = get_user_idx(user_id)
  #print(user_idx)
  if(user_idx>nrow(sparse_mat)){ # He is from test data (Cold Start Problem)
    ratings = test_df$rating[which(test_df$userId == user_id)]
    return(sum(ratings)/length(ratings))
  }
  user_ratings = sparse_mat[user_idx,]
  sum = sum(user_ratings,na.rm = TRUE)
  n_nonzero = nnzero(user_ratings,na.counted = FALSE)
  return(sum/n_nonzero)
}

get_avg_movie_rating <- function(movie_id){
  movie_idx = get_movie_idx(movie_id)
  if(movie_idx > ncol(sparse_mat)){
    ratings = test_df$rating[which(test_df$movieId==movie_id)]
    return(sum(ratings)/length(ratings))
  }
  movie_ratings = sparse_mat[,movie_idx]
  sum = sum(movie_ratings,na.rm = TRUE)
  n_nonzero = nnzero(movie_ratings,na.counted = FALSE)
  return(sum/n_nonzero)
}

get_rating_sim_users <- function(user_id,movie_id){ # rating of 5 top similar
  user_idx <- get_user_idx(user_id)                 # for the movie_id
  movie_idx = get_movie_idx(movie_id)
  avg_movie_rating = get_avg_movie_rating(movie_id)
  #print(user_idx)
  avg_user_rating = get_avg_user_rating(user_id)
  if(user_idx>nrow(US_matrix) || movie_idx>nrow(MS_matrix)){
    return(rep((avg_user_rating+avg_movie_rating)/2,5))
  }
  sim_users <- as.vector(US_matrix[user_idx,])
  sim_users_idx <- order(sim_users,decreasing = TRUE)
  sim_user_ratings = c()
  for(i in 2:length(sim_users_idx)){
    if(length(sim_user_ratings)>=5){
      return(sim_user_ratings)
    }
    
    if(!(sparse_mat[sim_users_idx[i],movie_idx]==0)){
      sim_user_ratings <- append(sim_user_ratings,
                                 sparse_mat[sim_users_idx[i],movie_idx])
    }
  }
  while(length(sim_user_ratings)<5){
    sim_user_ratings <- append(sim_user_ratings,avg_user_rating)
  }
  
  return(sim_user_ratings)
}

get_rating_sim_users(429,1)

get_rating_sim_movies <- function(user_id,movie_id){
  movie_idx <- get_movie_idx(movie_id)
  avg_movie_rating = get_avg_movie_rating(movie_id)
  user_idx = get_user_idx(user_id)
  avg_user_rating = get_avg_user_rating(user_id)
  if(movie_idx>nrow(MS_matrix) || user_idx>nrow(US_matrix)){
    return(rep((avg_user_rating+avg_movie_rating)/2,5))
  }
  sim_movies <- as.vector(MS_matrix[movie_idx,])
  sim_movies_idx= order(sim_movies,decreasing = TRUE)
  sim_movies_rating = c()
  for(i in 2:length(sim_movies_idx)){
    if(length(sim_movies_rating)>=5){
      return(sim_movies_rating)
    }
    if(!(sparse_mat[user_idx,sim_movies_idx[i]]==0)){
      sim_movies_rating <- append(sim_movies_rating,
                                  sparse_mat[user_idx,sim_movies_idx[i]])
    }
  }
  while(length(sim_movies_rating)<5){
    sim_movies_rating <- append(sim_movies_rating,avg_movie_rating)
  }
  return(sim_movies_rating)
}


evaluate_model <- function(true,predicted){
  rmse_train = caret::RMSE(true,predicted)
  mae_train = caret::MAE(true,predicted)
  mse_train = mean((true-predicted)^2)
  return(c("RMSE"=rmse_train,"MSE"=mse_train,"MAE"=mae_train))
}


