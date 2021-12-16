setwd("/home/will-of-d/Desktop/MovieRecommendationSystem")
library(Matrix)

MS_matrix = readMM("res/MS_matrix.txt") # similarity matrix
movies_df = read.csv("datasets/movies.csv",stringsAsFactors = FALSE)
get_similar_movies <- function(movie_id,n_movies = 10){
  n_movies = n_movies+1
  movies_idx_df = read.csv("datasets/movies_idx.csv")
  row_id = which(movies_idx_df$movieId==movie_id)
  movie_vec = as.vector(MS_matrix[row_id,])
  movie_idx_vec = order(movie_vec,decreasing = TRUE)
  s_movies_idx_vec = movie_idx_vec[2:n_movies]
  given_movie_row = which(movies_df$movieId==movie_id)
  given_movie_title = movies_df$title[given_movie_row]
  given_movie_genre = movies_df$genres[given_movie_row]
  print(sprintf("Given movie is %s genre: %s",given_movie_title,given_movie_genre))
  print(sprintf("Suggested movies are "))
  for(idx in s_movies_idx_vec){
    movie_id = movies_idx_df$movieId[idx]
    movie_row = which(movies_df$movieId==movie_id)
    movie_title = movies_df$title[movie_row]
    movie_genre = movies_df$genres[movie_row]
    print(sprintf("%s genre: %s",movie_title,movie_genre))
  }
}
get_similar_movies(1)
