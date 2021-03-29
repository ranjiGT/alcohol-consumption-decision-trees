library(tidyverse)
library(forcats)
library(stringr)
library(purrr)
library(caret)

# Function that calculates the Gini Index of a partitioning of x w.r.t. y
myGini <- function(x,y) {
  ti <- tibble(x, y) # generates a table from one attribute x (e.g. sex), and alco_prob
  rat <- prop.table(table(ti$x)) # calculates the percentage amount of females and males
  ti <- ti %>%
    split(.$x) %>% # number of males and females w.r.t alco_prob (alc and no_alc)
    map(~prop.table(table(.$y))) %>% # applies function to calculate the percentage
    #amount of alc_prop and and n_alc_prop with females ind males
    map(~ 1 - sum(.^2)) %>%
    unlist()
  return(sum(ti*rat))
}
#-----------------------------------
student <- read_csv("student_alc.csv")
student <- student %>%
  map_if(is.character, as.factor) %>%
  bind_cols()
student <- student %>%
  mutate(alc_prob = ifelse(Dalc + Walc >= 6, "alc_p", "no_alc_p"))


str(student)
table(student$alc_prob)

gini_class <- 1 - sum(prop.table(table(student$alc_prob))^2)


li_gini <- vector("list", length = ncol(student))
for(var in 1:ncol(student)){
  if(is.factor(student[[var]])) {
    df_gini <- tibble(
      variable = names(student)[[var]],
      gini = NA
    )
    df_gini$gini[1] <- myGini(student[[var]], student$alc_prob)
    li_gini[[var]] <- df_gini
  }
  # For numeric variables calculate Gini index for all possible split points
  if(is.numeric(student[[var]])) {
    split_points <- sort(unique(student[[var]]))
    df_gini <- tibble(
      variable = str_c(names(student)[[var]], "<=", split_points),
      gini = NA
    )
    for(sp in 1:length(split_points)) {
      temp_var <- cut(student[[var]], breaks = c(-Inf, split_points[sp], Inf))
      df_gini$gini[sp] <- myGini(temp_var, student$alc_prob)
    }
    
    #Choose best split, i.e. split with lowest Gini Index
    li_gini[[var]] <- df_gini %>% filter(!is.nan(gini)) %>% arrange(gini) %>% slice(1)
  }
}
student_gini <- do.call("rbind", li_gini)
student_gini %>%
  filter(!variable == "alc_prob") %>%
  mutate(gini_gain = myGini(1, student$alc_prob) - gini) %>%
  mutate(variable = forcats::fct_reorder(variable, gini_gain)) %>%
  ggplot(aes(x = variable, y = gini_gain)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = "Gini Gain of all variables w.r.t. 'alc_prob'", y = "")

set.seed(123)
inTrain <- sample(c(FALSE, TRUE), size = nrow(student), replace = TRUE, prob = c(.3, .7))
student <- map_df(student, ~if(is.character(.)){factor(.)}else{.})
student_train <- student %>% select(-Walc, -Dalc) %>% filter(inTrain)  #Training set
student_test <- student %>% select(-Walc, -Dalc) %>% filter(!inTrain)  #Test set
str(student_test)


library(rpart)
library(rattle)
library(rpart.plot)

fit <- rpart(alc_prob ~ ., data = student_train, control = rpart.control(minsplit = 1, minbucket=3))
fancyRpartPlot(fit, sub = "")

p <- predict(fit, student_test %>% select(-alc_prob) , type = "class")
cm <- confusionMatrix(student_test$alc_prob, p, dnn = c("True Label", "Predicted Label"))
cm

fit <- rpart(alc_prob ~ ., data = student_train, control = rpart.control(minsplit = 20, minbucket=2))
fancyRpartPlot(fit, sub = "")

p <- predict(fit, student_test %>% select(-alc_prob) , type = "class")
cm <- confusionMatrix(student_test$alc_prob, p, dnn = c("True Label", "Predicted Label"))
cm

fit <- rpart(alc_prob ~ ., data = student_train, control = rpart.control(minsplit = 20, minbucket = 1))
fancyRpartPlot(fit, sub = "")

p <- predict(fit, student_test %>% select(-alc_prob) , type = "class")
cm <- confusionMatrix(student_test$alc_prob, p, dnn = c("True Label", "Predicted Label"))
cm
