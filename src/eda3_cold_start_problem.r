total_users = nrow(unique(df[c("userId")]))
train_users = nrow(unique(train_df[c("userId")]))
unique_test_user = total_users-train_users
sprintf("Total number of users is %d",total_users)
sprintf("Total number of train users is %d",train_users)
sprintf("Total number of unique test users is %d",unique_test_user)
sprintf("Total percent of unique test users is %f %%",unique_test_user/total_users*100)

total_movies = nrow(unique(df[c("movieId")]))
train_movies = nrow(unique(train_df[c("movieId")]))
unique_test_movies = total_movies-train_movies
sprintf("Total number of movies is %d",total_movies)
sprintf("Total number of train movies is %d",train_movies)
sprintf("Total number of unique test movies is %d",unique_test_movies)
sprintf("Total percent of unique test movies is %f %%",unique_test_movies/total_movies*100)

