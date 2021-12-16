setwd("/home/will-of-d/Desktop/MovieRecommendationSystem")
library(Matrix)
sparse_mat =readMM("res/train_sparse_matrix.txt")
sum_of_rating = sum(sparse_mat)
n_nonzero = nnzero(sparse_mat,na.counted = FALSE)
sprintf("Sparsity of the sparse matrix is %f %%",
        100-n_nonzero*100/(nrow(sparse_mat)*ncol(sparse_mat)))
global_avg = (sum_of_rating/n_nonzero)
global_avg
