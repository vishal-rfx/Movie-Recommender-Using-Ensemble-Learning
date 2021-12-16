setwd("/home/will-of-d/Desktop/MovieRecommendationSystem")
library(Matrix)
library(qlcMatrix)

sparse_mat <- readMM("res/train_sparse_matrix.txt")
MS_matrix <- qlcMatrix::cosSparse(sparse_mat)
n_nonzero = nnzero(MS_matrix,na.counted = FALSE)
sprintf("Sparsity in movies similarity matrix is %f %%",
        100-(n_nonzero*100/(nrow(MS_matrix)*ncol(MS_matrix)*2)))

if(!file.exists("res/MS_matrix.txt")){
  writeMM(MS_matrix,"res/MS_matrix.txt")
}

nrow(MS_matrix)
ncol(MS_matrix)

US_matrix <- qlcMatrix::cosSparse(t(sparse_mat))
nrow(US_matrix)
ncol(US_matrix)
n_nonzero = nnzero(US_matrix,na.counted = FALSE)
sprintf("Sparsity in movies similarity matrix is %f %%",
        100-(n_nonzero*100/(nrow(US_matrix)*ncol(US_matrix)*2)))

if(!file.exists("res/US_matrix.txt")){
  writeMM(US_matrix,"res/US_matrix.txt")
}
