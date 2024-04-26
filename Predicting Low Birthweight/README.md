Predicting Low Birthweight in Newborns

This project tackles a critical issue: predicting low birthweight in newborns. Low birthweight is a major concern as it can indicate potential 
health problems for babies.

The Challenge:

Using machine learning, I aimed to build a model that could accurately predict low birthweight (defined as birthweight below 3430 grams). 
The initial data presented a challenge - there were far more cases of normal birthweight compared to low birthweight. To address this 
imbalance, I adjusted the weight threshold to create a more balanced dataset for training the model.

Key Findings:
The analysis revealed some interesting insights. The model identified two factors with the strongest influence on birthweight: mother's age 
and father's age. This suggests these factors could be valuable for early assessment of potential risks.

Balancing Accuracy and Early Intervention:
While evaluating the model's performance, I encountered a trade-off. High accuracy wasn't the sole priority. It's crucial to correctly identify 
low birthweight cases so interventions can be implemented early on. Therefore, the model prioritizes minimizing "False Negatives" - situations 
where a low birthweight case is wrongly predicted as normal. This might lead to some "False Positives" where normal weight is flagged as low, 
but early intervention is still possible.

Next Steps:
The current model presents a solid foundation. Further optimization efforts can aim to improve overall performance by potentially reducing 
these classification errors. This will lead to an even more accurate and valuable tool for predicting low birthweight and ensuring the health of newborns.
