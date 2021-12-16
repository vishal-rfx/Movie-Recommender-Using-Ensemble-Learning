setwd("/home/will-of-d/Desktop/MovieRecommendationSystem")
library(Matrix)
train_df <- read.csv("datasets/train.csv")
test_df <- read.csv("datasets/test.csv")

users_idx_df = read.csv("datasets/users_idx.csv")
head(users_idx_df)
movies_idx_df = read.csv("datasets/movies_idx.csv")
head(movies_idx_df)

train_df$rowIdx <- match(train_df$userId,users_idx_df$userId)
head(train_df)
train_df$colIdx <- match(train_df$movieId,movies_idx_df$movieId)
head(train_df)

test_df$rowIdx <- match(test_df$userId,users_idx_df$userId)
head(test_df)
test_df$colIdx <- match(test_df$movieId,movies_idx_df$movieId)
head(test_df)

sparse_mat = sparseMatrix(i=train_df$rowIdx,
                          j=train_df$colIdx,
                          x=train_df$rating,
                          dims = c(max(train_df$rowIdx),max(train_df$colIdx)),
                          )

test_sparse_mat = sparseMatrix(i=test_df$rowIdx,
                               j=test_df$colIdx,
                               x=test_df$rating,
                               dims = c(max(test_df$rowIdx),max(test_df$colIdx)))

if(!file.exists("res/train_sparse_matrix.txt")){
  writeMM(sparse_mat,file = "res/train_sparse_matrix.txt")
}
nrow(sparse_mat)
ncol(sparse_mat)

if(!file.exists("res/test_sparse_matrix.txt")){
  writeMM(test_sparse_mat,file = "res/test_sparse_matrix.txt")
}
nrow(test_sparse_mat)
ncol(test_sparse_mat)
