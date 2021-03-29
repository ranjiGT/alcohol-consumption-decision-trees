#--------------------------------------
library(randomForest)
#--------------------------------------
set.seed(123)
rf <- randomForest(alc_prob ~ ., data = student %>% select(-Dalc, -Walc), ntree = 200, mtry = 5)
cm <- rf$confusion[1:2,1:2]
acc <- sum(diag(cm))/sum(sum(cm))
acc

sens <- cm[1,1]/sum(cm[1,])
sens
spec <- cm[2,2]/sum(cm[2,])
spec
#...from ?importance
# Here are the definitions of the variable importance measures. 
#The first measure is computed from 
#The second measure is the total decrease in node impurities from splitting on the variable, averaged
varImpPlot(rf, type = 2)