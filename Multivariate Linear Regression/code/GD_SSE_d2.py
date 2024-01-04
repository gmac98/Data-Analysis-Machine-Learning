# -*- coding: utf-8 -*-
"""
@author: gmac9_syr4iep
"""


import numpy as np
import matplotlib.pyplot as plt
from sklearn.datasets.samples_generator import make_regression


X, y = make_regression(n_samples=500, n_features=9, n_informative=1, random_state=0, noise=0)
m = len(y)

print('Total no of training examples (m) = %s \n' %(m))

for i in range(5):
    print('x =', X[i, ], ', y =', y[i])

X = np.hstack((np.ones((m,1)), X))

def compute_cost(X, y, w):

  predictions = X.dot(w)
  errors = np.subtract(predictions, y)
  ei_2 = errors.T.dot(errors)

  return ei_2

def gradient_descent(X, y, w, eta, iterations):
  cost_record = np.zeros(iterations)

  for i in range(iterations):  
    predictions = X.dot(w)
    errors = np.subtract(predictions, y)
    gradient = (eta * 2) * X.transpose().dot(errors);
    w = w - gradient;
    cost_record[i] = compute_cost(X, y, w)

  return w, cost_record

w = np.zeros(10)
iterations = 500;
eta = 0.00015;

w1, cost_record = gradient_descent(X, y, w, eta, iterations)
print('Final w values =', w1)
print('Initial 5 values from cost =', cost_record[:5])
print('Last 5 values from cost =', cost_record[-5 :])

pred = X.dot(w1)
err = np.subtract(pred, y)
sqrErr = np.square(err)
sumErr = np.sum(sqrErr)

ymean = np.mean(y)
cost2 = 0
for i in range(len(y)):
    v = (ymean - y[i]) **(2)
    cost2 = cost2 + v
r2 = 1 - (sumErr/cost2)
print("r2 value:",r2)

plt.plot(range(1, iterations +1), cost_record, color ='blue')
plt.rcParams["figure.figsize"] = (10,6)
plt.grid()
plt.xlabel("Number of iterations")
plt.ylabel("Cost")
plt.title("Convergence of gradient descent")