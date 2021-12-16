setwd("/home/will-of-d/Desktop/MovieRecommendationSystem")
library(Matrix)
library(xgboost)
library(caret)

f_train_df = read.csv("datasets/final_model_train.csv")
head(f_train_df)
train_df = read.csv("datasets/train.csv")
f_train_df$userId <- NULL
f_train_df$movieId <- NULL

X_train  = as.matrix(f_train_df)
y_train = as.matrix(train_df$rating)

set.seed(12)
xgb <- xgboost(data = X_train, 
               label = y_train, 
               eta = 0.1,
               max_depth = 11, 
               nround=30, 
               subsample = 0.5,
               colsample_bytree = 0.5,
               eval_metric = "rmse",
               objective = "reg:linear",
               nthread =3,
               base_score = global_avg)

y_pred = predict(xgb,X_train)

M3_TRAIN_EVAL = evaluate_model(y_train,y_pred)

f_test_df = read.csv("datasets/final_model_test.csv")
test_df = read.csv("datasets/test.csv")
head(f_test_df)

f_test_df$userId <- NULL
f_test_df$movieId <- NULL

X_test = as.matrix(f_test_df)
y_test = as.matrix(test_df$rating)

y_pred = predict(xgb,X_test)
M3_TEST_EVAL = evaluate_model(y_test,y_pred)

