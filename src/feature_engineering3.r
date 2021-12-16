setwd("/home/will-of-d/Desktop/MovieRecommendationSystem")
library(Matrix)

# Model 1 : (user_avg,movie_avg,global_avg), rating - 3 features
# Model 2 : Collaborative filtering SVD - mathematical model
# Model 3 : (user_avg,movie_avg,global_avg,top5_users, top5_movies, 
            # model1_output,model2_output,),rating - 16 features

                  ##### CREATING FOR TRAIN DATASET ######

m1_train_df = read.csv("datasets/models/model1_train.csv")
head(m1_train_df)
y_train = m1_train_df$rating
m1_train_df$rating <- NULL
head(m1_train_df)

create_dataset_model3 <- function(df,is_test = FALSE){
  sim_users_vec = c()
  sim_movies_vec = c()
  for(i in 1:nrow(df)){
    user_id = df[i,1]
    movie_id = df[i,2]
    top5_sim_users = get_rating_sim_users(user_id,movie_id)
    sim_users_vec <- append(sim_users_vec,top5_sim_users)
    top5_sim_movies = get_rating_sim_movies(user_id,movie_id)
    sim_movies_vec <- append(sim_movies_vec,top5_sim_movies)
  }
  sim_users_mat = Matrix(data = sim_users_vec,nrow = nrow(df),ncol = 5,
                         byrow = TRUE)
  print(c(nrow(sim_users_mat),ncol(sim_users_mat)))
  colnames(sim_users_mat) = c("sim_usr1","sim_usr2","sim_usr3","sim_usr4","sim_usr5")
  sim_users_df = as.data.frame(as.matrix(sim_users_mat))
  sim_movies_mat = Matrix(data=sim_movies_vec,nrow = nrow(df),ncol=5,
                          byrow = TRUE)
  print(c(nrow(sim_movies_mat),ncol(sim_movies_mat)))
  colnames(sim_movies_mat)=c("sim_mov_1","sim_mov2","sim_mov3","sim_mov4","sim_mov5")
  sim_movies_df = as.data.frame(as.matrix(sim_movies_mat))
  df <- cbind(df,sim_users_df)
  df <- cbind(df,sim_movies_df)
  print(head(df))
  
  if(!is_test){
    m1_train_df = read.csv("datasets/models/model1_train_ratings.csv")
    m2_train_df = read.csv("datasets/models/model2_ratings.csv")
    
    df$m1_ratings <- m1_train_df$m1_ratings
    df$m2_ratings <- m2_train_df$model2_ratings
    
    if(!file.exists("datasets/final_model_train.csv")){
      write.csv(df,"datasets/final_model_train.csv",row.names =FALSE)
    }
  }else{
    m1_test_df = read.csv("datasets/models/model1_test_ratings.csv")
    m2_test_df = read.csv("datasets/models/model2_test_ratings.csv")
    
    df$m1_ratings <- m1_test_df$m1_ratings
    df$m2_ratings <- m2_test_df$model2_ratings
    if(!file.exists("datasets/final_model_test.csv")){
      write.csv(df,"datasets/final_model_test.csv",row.names =FALSE)
    }
    
  }
  
}

create_dataset_model3(m1_train_df)

f_train_df = read.csv("datasets/final_model_train.csv")
head(f_train_df)



                    ##### CREATING FOR TEST DATASET ######
test_df = read.csv("datasets/test.csv")
m1_test_df = create_dataset_model1(test_df,is_test = TRUE)

head(m1_test_df)

y_test = m1_test_df$ratings
m1_test_df$rating <- NULL
head(m1_test_df)

create_dataset_model3(m1_test_df,is_test = TRUE)

