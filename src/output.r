train_eval_df <- rbind(M1_TRAIN_EVAL,M2_TRAIN_EVAL)
train_eval_df <- rbind(train_eval_df,M3_TRAIN_EVAL)
write.csv(train_eval_df,"output/train_eval.csv",row.names = FALSE)
test_eval_df <- rbind(M1_TEST_EVAL,M2_TEST_EVAL)
test_eval_df <- rbind(test_eval_df,M3_TEST_EVAL)

write.csv(test_eval_df,"output/test_eval.csv",row.names = FALSE)

train_eval_df = read.csv("output/train_eval.csv")
head(train_eval_df)
colors = c("red","green","blue")
models = c("Model-1","Model-2","Model-3")
barplot(as.matrix(train_eval_df),beside = TRUE,col = colors, ylim = c(0,1.2),ylab = "Loss",main = "Training Loss")
legend("topleft", models,cex = 0.5, fill = colors)


test_eval_df =read.csv("output/test_eval.csv")
head(test_eval_df)
colors = c("red","green","blue")
models = c("Model-1","Model-2","Model-3")
barplot(as.matrix(test_eval_df),beside = TRUE,col = colors, ylim = c(0,1.2),ylab = "Loss",main = "Testing Loss")
legend("topleft", models,cex = 0.4, fill = colors)
