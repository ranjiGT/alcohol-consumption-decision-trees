# `Why do student's consume excess C2H5OH?` :beer: ![](https://img.shields.io/badge/R-276DC3?style=for-the-badge&logo=r&logoColor=white)
Determining what factors explain alcohol consumption among students.

# Case description
What factors explain excessive alcohol consumption among students? The record for the task sheet
comes from a survey of students who attended mathematics and Portuguese courses and contains
many interesting details about their sociodemographics, life circumstances and learning success.
The ordinal scaled variables `Dalc` and `Walc` give information about the alcohol consumption of the
students on weekdays and weekends. 

# Task description
Create a binary target variable `alc_prob` as follows:
- Calculate the Gini index for the target variable `alc_prob` and the Gini index for each variable with respect to `alc_prob`. Determine the 5 variables with the highest Gini Gain.
- Learn 2 different decision trees with alc_prob as target variable. For the first tree, nodes should be further partitioned until the class distribution of all resulting leaf nodes is pure. For the second tree, nodes with a cardinality of less than 20 instances should not be further partitioned. Determine the quality of the trees by calculating sensitivity (True Positive Rate) and specificity (True Negative Rate) for a 70%:30% split in training and test sets. Display the decision trees graphically and discuss the differences in quality measures.
- Use `randomForest::randomForest()` to create a random forest with 200 trees. As candidates
for a split within a tree a random sample of 5 variables should be drawn. Calculate Accuracy,
Sensitivity and Specificity for the Out-of-the-Bag instances and show the most important
variables (**?importance**).

# Results
![](https://github.com/ranjiGT/alcohol-consumption-decision-trees/blob/main/GiniGain.png)
![](https://github.com/ranjiGT/alcohol-consumption-decision-trees/blob/main/DT.png)
![](https://github.com/ranjiGT/alcohol-consumption-decision-trees/blob/main/DT2.png)
![](https://github.com/ranjiGT/alcohol-consumption-decision-trees/blob/main/RF.png)

# Dataset: https://www.kaggle.com/uciml/student-alcohol-consumption
