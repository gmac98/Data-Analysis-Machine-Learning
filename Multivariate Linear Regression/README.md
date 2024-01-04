Multivariate Linear Regression
The first objective function is the sum of squared errors.
The second objective function is the sum of square Euclidean distances to the hyperplane.

Task 1:

Implement Gradient descent on Sum of Squared Errors and Gradient descent on Sum of Euclidean Distances algorithms and test them on 3 datasets. Compare the solutions to the closed-form (maximum likelihood) solution derived in class and the R^2 in all cases on the same dataset used to the parameters; i.e., do not implement cross-validation. Briefly describe the data you use and discuss your results.

Solution:

Data for the datasets was generated using sklearn:datasets:samplesgeneratorimportmakeregression
within the python notebook. X was initialized as a multivariate input data having multiple features.
Y is the target data in the dataset.
For Sum of Squared Errors-
Dataset 1 : size = 50 features = 2
Dataset 2 : size = 500 features = 9
Dataset 3 : size = 800 features = 12
It was observed that each time, the number of iterations needed until convergence di
ered for every
implementation.
r2 value for Sum of Squared Errors remained constant at 0.99 for every data set with changing data
set and X features size.
For Sum of Euclidean Distances-
Dataset 1 : size = 10 features = 2
Dataset 2 : size = 100 features = 6
Dataset 3 : size = 1400 features = 10
However, the r2 value for Sum of Euclidean Distances changed from 0.87, 0.92 to 0.999 for the three
data sets with changing data set and X features size.
Comparing with the closed form of maximum likelihood solution we observe that just like in case of
wML it tries to minimize the sum of square errors to converge quickly. With increasing dataset size
but high dimensionality of higher number of features, the algorithm converges more quickly.

Task 2:
Normalize every feature and target using a linear transform such that the minimum value for each feature and the target is 0 and the maximum value is 1. Calculate the new value for feature j of data
point i, xij^new, and the new value for the target i, yi^new. Measure the number of steps towards convergence and compare with the results from the previous part. Briefly discuss your results.

Solution:

For Sum of Squared Errors after Normalization-
Dataset 1 : size = 50 features = 2
Dataset 2 : size = 500 features = 9
Dataset 3 : size = 800 features = 12
It was observed that each time, the number of iterations needed until convergence di
ered for every
implementation.
r2 value for Sum of Squared Errors remained constant at 1 for every data set with changing data set
and X features size.
For Sum of Euclidean Distances after Normalization-
Dataset 1 : size = 10 features = 2
Dataset 2 : size = 100 features = 6
Dataset 3 : size = 1400 features = 10
However, the r2 value for Sum of Euclidean Distances changed from 0.97, 0.999 to 0.993 for the three
data sets with changing data sets and X features size.
Convergence for sum of squared errors without normalization converged at 10,25,75 iterations whereas
with normalization converged at 200,500,100 iterations.
Convergence for sum of euclidean distances without normalization converged at 150,6000,10 iterations
whereas with normalization converged at 1000,250,100 iterations.
It is to be noted that each time a di
erent learning rate of eta was assumed.
