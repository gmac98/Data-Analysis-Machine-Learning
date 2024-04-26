Unsupervised Analysis of Facebook Live Sellers in Thailand

In this project, I aim to understand how video content impacts engagement for Facebook Live sellers in Thailand. Our marketing firm traditionally emphasizes video content, 
but a data-driven approach can reveal if this holds true and provide more nuanced insights.

Here's how I'll approach the analysis:

Engagement by Content Type: I'll compare video performance against other content formats (text, images) 
based on reactions (likes, loves) and overall engagement. This will reveal if videos truly reign supreme.

Identifying Key Engagement Factors: Using Principal Component Analysis (PCA), I'll condense the available 
social media metrics into a smaller set of key factors representing the most significant variations in seller 
behavior and audience engagement. This will help us focus on the most impactful aspects of content.

Seller Segmentation: Based on the key factors identified by PCA, I'll use k-means clustering to group sellers 
with similar engagement patterns. This will reveal distinct seller segments, each potentially employing unique 
live selling strategies.

Predicting Video Usage: Finally, I'll build logistic regression models to predict the likelihood of a post being 
a video based on different sets of features: original metrics, key factors from PCA, and seller segments from k-means. 
This will pinpoint the most indicative engagement factors associated with video usage.

This comprehensive analysis, combining PCA, k-means clustering, and logistic regression, will provide a holistic 
understanding of Facebook Live seller behavior in Thailand. We'll move beyond general assumptions about video content 
and uncover the specific engagement strategies driving success for different seller segments. These insights will be 
invaluable for both sellers, who can optimize their content and engagement approaches, and our marketing firm, 
who can provide more data-backed recommendations to clients.

Analysis Overview -

Unveiling Facebook Live Seller Strategies This analysis delves into the world of Facebook Live sellers in Thailand, 
aiming to understand their content creation strategies and audience engagement patterns. I will leverage a combination 
of powerful techniques:

Principal Component Analysis (PCA): This technique condenses the data into a smaller set of features, capturing the 
most significant variations in seller behavior related to most relevant principal components - "Enthusiastic 
Interaction" and "Disappointed Engagement."

K-means Clustering: By grouping sellers based on these key features and monthly performance data, I identify 8 distinct 
seller segments with potentially unique approaches to live selling. These segments receive creative names like 
"Summer Sizzlers" and "Engaging Controversy" based on their characteristics.

Logistic Regression: I then use logistic regression to predict the likelihood of a post being a video based on various 
engagement approaches (original x-features, retained principal components, and retained clusters). This allows me to 
explore which engagement factors are most indicative of video content on Facebook Live.
The best logisic regression model with original selected x-features achieves a test AUC score of 0.72, which is 
significantly higher than both other models tested (0.703 and 0.553). AUC score measures the model's ability to 
distinguish between video posts (1) and non-video posts (0). A higher score indicates better performance in differentiating 
video content based on these features.

By combining these techniques, we gain a comprehensive view of Facebook Live seller behavior – from overarching trends 
captured by PCA to specific video usage patterns within different seller clusters identified through k-means. This analysis 
not only sheds light on seller strategies but also provides valuable insights for sellers to optimize their content and engagement approaches.