## Binary Classification with a Bank Churn Dataset

# Set working directory
setwd("D:\\hult coursework\\MBAN\\Spring 2024_1\\Visualizing & Analyzing Data with R\\A3 Binary Classification")
getwd()

# Load training and testing datasets
df.train <- read.csv('BankChurnDataset.csv')
df.test <- read.csv('NewCustomerDataset.csv')

# Exploratory data analysis
# Check the structure of data
head(df.train)
head(df.test)

str(df.train)
str(df.test)

# summary statistics of training data
summary(df.train)

# visualize missing values map
#install.packages("Amelia")
library(Amelia)            # data exploration package
missmap(df.train, main="Bank Churn Training Data - Missings Map", col=c("yellow", "black"), legend=TRUE)

# visualize relationships using GGPlot
library(ggplot2)
# Distribution of Exited count
ggplot(df.train,aes(x = Exited, fill = factor(Exited))) + geom_bar() + 
  labs(title = 'Distribution of Exited', x = 'Exited', y = 'Count') +
  scale_fill_manual(values = c("maroon", "lawngreen"))
# Age as histogram with bin value = 20
ggplot(df.train,aes(Age)) + geom_histogram(fill='maroon',bins=20,alpha=0.5,colour="Blue") +
  labs(title = 'Distribution of Age')
# CreditScore as histogram with bin value = 25
ggplot(df.train,aes(CreditScore)) + geom_histogram(fill='orchid2',bins=25,colour="Black") +
  labs(title = 'Distribution of Credit Score', x = 'Credit Score', y = 'Count')
# Balance as histogram with bin value = 10
ggplot(df.train,aes(Balance)) + geom_histogram(fill='olivedrab2',bins=10,colour="Black") +
  labs(title = 'Distribution of Balance value', x = 'Balance', y = 'Count')
# EstimatedSalary as histogram with bin value = 18
ggplot(df.train,aes(EstimatedSalary)) + geom_histogram(fill='palevioletred2',bins=18,colour="Black") +
  labs(title = 'Distribution of Estimated Salary', x = 'EstimatedSalary', y = 'Count')
# NumOfProducts count
ggplot(df.train,aes(NumOfProducts, fill = factor(NumOfProducts))) + geom_bar() +
  labs(title = "Distribution of NumOfProducts", x = "NumOfProducts", y = "Count") + theme(legend.position="none")
# HasCrCard count
ggplot(df.train,aes(HasCrCard, fill = factor(HasCrCard))) + geom_bar() +
  labs(title = "Distribution of HasCrCard", x = "HasCrCard", y = "Count") + theme(legend.position="none")
# IsActiveMember count
ggplot(df.train,aes(IsActiveMember, fill = factor(IsActiveMember))) + geom_bar() +
  labs(title = "Distribution of IsActiveMember", x = "IsActiveMember", y = "Count") + theme(legend.position="none")
# Geography as bar plot
ggplot(df.train, aes(x = Geography, fill = as.factor(Geography))) + geom_bar() + scale_fill_hue(c = 40) +
  labs(title = "Distribution of Geography", x = "Geography", y = "Count") + theme(legend.position="none")
# Gender as bar plot
ggplot(df.train, aes(x = Gender, fill = as.factor(Gender))) + geom_bar() + scale_fill_hue(c = 40) +
  labs(title = "Distribution of Gender", x = "Gender", y = "Count") + theme(legend.position="none")
# Boxplot for Exited vs Age
pl <- ggplot(df.train,aes(Exited,Age)) + geom_boxplot(aes(group=Exited,fill=factor(Exited),alpha=0.4)) + 
      labs(title = 'Boxplot of Exited vs Age')
pl + scale_y_continuous(breaks = seq(min(0), max(80), by = 2)) + theme(legend.position="none")

# Check for missing values
colSums(is.na(df.train))
df.train[is.na(df.train$Age),]
df.train[is.na(df.train$EstimatedSalary),]
nrow(df.train)

# Age Imputation, handling missing values in age using median values from Exited vs Age boxplot
impute_age <- function(age,exit){
  out <- age
  for (i in 1:length(age)){
    
    if (is.na(age[i])){
      
      if (exit[i] == 0){
        out[i] <- 36       # median age value for Exited = 0
        
      }else{
        out[i] <- 44       # median age value for Exited = 1
      }
    }else{
      out[i]<-age[i]
    }
  }
  return(out)
}
new.ages <- impute_age(df.train$Age,df.train$Exited)
df.train$Age <- new.ages

# Since we have 165,034 observations, and only 3 records with missing values for EstimatedSalary, we will remove records with NA.
df.train <- df.train[complete.cases(df.train), ]
nrow(df.train)

# Analyzing numeric variables
# Check for correlations in numeric variables using correlation matrix
# install.packages("corrplot")
library(corrplot)
corr.matrix <- cor(df.train[, c('CreditScore', 'Age', 'Tenure', 'Balance', 'NumOfProducts', 'HasCrCard', 
                                'IsActiveMember', 'EstimatedSalary', 'Exited')])
corr.matrix

# Heat map for correlation
corrplot.mixed(corr.matrix, upper = "color", lower = "number", lower.col = "black",
               tl.cex = 0.7, order = "hclust",tl.pos = "lt", title = "Correlation Heatmap & Matrix")

# Analyzing categorical variables - Geography & Gender
table(df.train$Geography, df.train$Exited)
table(df.train$Gender, df.train$Exited)

# Converting categorical variables into factor datatype and removing unwanted columns
library(dplyr)
df.train.transformed <- transform(subset(df.train, select = -c(id, CustomerId, Surname)),
                              Geography = as.factor(Geography), Gender = as.factor(Gender))
head(df.train.transformed)

# Split the dataset into training and testing sets
# install.packages("caret")
library(caret)
set.seed(123)
split_index <- createDataPartition(df.train.transformed$Exited, p = 0.7, list = FALSE)
train_data <- df.train.transformed[split_index, ]
validation_data <- df.train.transformed[-split_index, ]

head(train_data)
head(validation_data)

# Logistic Regression Model, Accuracy : 0.8348
# training the LR model
lr_model <- glm(Exited ~ ., data = train_data, family = "binomial")
summary(lr_model)

# Confusion Matrix and Precision Statistics on validating dataset
my_prediction <- predict(lr_model, validation_data, type="response")
confusionMatrix(data= as.factor(as.numeric(my_prediction>0.5)),
                reference= as.factor(as.numeric(validation_data$Exited)))

# Predicting on the testing dataset i.e. new customer dataset
# Converting categorical variables in testing data into factor datatype
df.test$Geography <- as.factor(df.test$Geography)
df.test$Gender <- as.factor(df.test$Gender)

# Using LR model for prediction
test.preds <- predict(lr_model, newdata = df.test, type = "response")
# converting into binary predictions for classification
test.binary.preds <- ifelse(test.preds > 0.5, 1, 0)
df.test$ExitedPrediction <- test.binary.preds

# Evaluating the LR model using ROC curve
# install.packages("pROC")
library(pROC)               # ROC-curve using pROC library
roc_curve <- roc(df.test$ExitedPrediction, test.preds)
summary(roc_curve)
auc(roc_curve)    # AUC value is 1, which is outstanding i.e. it is a perfect model

# Analysing predictions on testing data
head(df.test)
ggplot(df.test,aes(x = ExitedPrediction, fill = factor(ExitedPrediction))) + geom_bar() + 
  labs(title = 'Distribution of Exited predictions', x = 'ExitedPrediction', y = 'Count') +
  scale_fill_manual(values = c("maroon", "lawngreen"))

# DATA INSIGHTS ON MODEL ACCURACY AND STATISTICS
# Accuracy: With an accuracy of 0.8348, the model correctly classifies 83.48% of the instances. 
#           This is considered good accuracy, especially considering the 95% confidence interval 
#           suggests it's unlikely to be much lower or higher in the general data.
# Sensitivity: The sensitivity of 0.9568 indicates that the model correctly identifies 95.68% 
#           of true positives. This is very high, meaning it rarely misses actual positive cases.
# Specificity: The specificity of 0.3785 is low, which means the model frequently misclassifies 
#           negative cases as positive.
# Balanced Accuracy: The balanced accuracy of 0.6676 provides a balanced view of performance, 
#           considering both positives and negatives.
# The model achieves good overall accuracy but has a trade-off between high sensitivity 
# and low specificity.
# However, it's important to consider the no information rate, which is 78.9%. This means that 
# even without any model, simply classifying everything as the majority class (class 0 in this case) 
# would achieve 78.9% accuracy. While the model performs better than random guessing, the difference 
# is not substantial.

# Overall, the model offers limited improvement over simply guessing the majority class 
# and shows poor performance in differentiating negative instances. Further analysis is 
# needed to understand the reasons behind the high AUC and explore if alternative models 
# or data preprocessing techniques can improve the model's performance, particularly in 
# terms of specificity and NPV.
