Bank Customer Churn Prediction Project

This assignment is based on Kaggle’s competition on Binary Classification with a Bank Churn Dataset. 
https://www.kaggle.com/c/playground-series-s4e1

Introduction:

In this project, I will be tackling the task of predicting bank customer churn. Customer churn refers to a customer leaving a service or, in this case, closing their bank account. 
By leveraging machine learning techniques, we can identify customers at risk of churning, allowing banks to take proactive measures and improve customer retention rates.

Data Acquisition:

For this project, I will be utilizing two pre-provided datasets:
BankChurnDataset: This dataset contains historical information about bank customers, including features that might influence their decision to churn.
NewCustomerDataset: This dataset consists of data for new customers, and the goal is to predict whether they are likely to churn based on the trained model.

Methodology:

Data Preprocessing:

I will begin by meticulously examining both datasets to identify and address any missing values. This might involve techniques like imputation or removal depending on the nature of the missing data.

Model Training and Evaluation:

The BankChurnDataset will be split into training and testing sets.
I will then train a machine learning model on the training data. This model will learn the patterns that distinguish churning customers from loyal ones.
To assess the model's effectiveness, I will evaluate its accuracy, specificity, and sensitivity on the testing set. Accuracy measures the overall correct predictions, 
while specificity and sensitivity focus on the model's ability to correctly identify non-churning and churning customers, respectively.

Customer Churn Prediction:

Once the model is trained and evaluated, I will employ it to predict churn for the customers on the NewCustomerDataset.
This will provide valuable insights into which new customers might be at risk of leaving the bank.

Project Files:

R code used for data preprocessing, model training, evaluation, and prediction.
Visualizations to effectively communicate the findings, such as confusion matrices or ROC curves.

 DATA INSIGHTS ON MODEL ACCURACY AND STATISTICS

 Accuracy: With an accuracy of 0.8348, the model correctly classifies 83.48% of the instances. 
           This is considered good accuracy, especially considering the 95% confidence interval 
           suggests it's unlikely to be much lower or higher in the general data.

 Sensitivity: The sensitivity of 0.9568 indicates that the model correctly identifies 95.68% 
           of true positives. This is very high, meaning it rarely misses actual positive cases.

 Specificity: The specificity of 0.3785 is low, which means the model frequently misclassifies 
           negative cases as positive.

 Balanced Accuracy: The balanced accuracy of 0.6676 provides a balanced view of performance, 
           considering both positives and negatives.

 The model achieves good overall accuracy but has a trade-off between high sensitivity 
 and low specificity.
 However, it's important to consider the no information rate, which is 78.9%. This means that 
 even without any model, simply classifying everything as the majority class (class 0 in this case) 
 would achieve 78.9% accuracy. While the model performs better than random guessing, the difference 
 is not substantial.

 Overall, the model offers limited improvement over simply guessing the majority class 
 and shows poor performance in differentiating negative instances. Further analysis is 
 needed to understand the reasons behind the high AUC and explore if alternative models 
 or data preprocessing techniques can improve the model's performance, particularly in 
 terms of specificity and NPV.