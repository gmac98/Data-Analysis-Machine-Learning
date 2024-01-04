# -*- coding: utf-8 -*-
"""

@author: gmac9_syr4iep
"""


import numpy as np
import matplotlib.pyplot as plt
from sklearn.datasets.samples_generator import make_regression


X, y = make_regression(n_samples=100, n_features=6, n_informative=1, random_state=0, noise=0)
m = len(y)
n_features = 6

print('Total no of training examples (m) = %s \n' %(m))

for i in range(5):
    print('x =', X[i, ], ', y =', y[i])
    
def feature_normalizeX(X):
  mink = np.amin(X, axis=0) 
  maxk = np.amax(X, axis=0) 
  X_norm = np.zeros((m,n_features))
  for i in range(m):
      for j in range(n_features):
          X_norm[i][j] = (X[i][j] - mink[j])/(maxk[j] - mink[j])

  return X_norm

def feature_normalizeY(y):
  mink = np.amin(y, axis=0) 
  maxk = np.amax(y, axis=0) 
  y_norm = np.zeros(m)
  for i in range(m):
      y_norm[i] = (y[i] - mink)/(maxk - mink)

  return y_norm


X = feature_normalizeX(X)
print('X_norm= ', X[:5])

y = feature_normalizeY(y)
print('y_norm= ', y[:5])

X = np.hstack((np.ones((m,1)), X))


def compute_cost(X, y, w):

  predictions = X.dot(w)
  errors = np.subtract(predictions, y)
  sqrW = np.square(w[1:])
  n = errors.T.dot(errors) 
  d = np.sum(sqrW) + 1
  ri_2 = n / d

  return ri_2

def gradient_descent(X, y, w, eta, iterations):
  cost_record = np.zeros(iterations)

  for i in range(iterations):
      
    predictions = X.dot(w)
    errors = np.subtract(predictions, y)
    sqrW = np.square(w[1:3])
    d = np.sum(sqrW) + 1
    t1 = d * X
    n1 = t1.transpose().dot(errors)
    
    x1 = np.tile(w,(100,1))
    t2 = np.square(errors)
    n2 = x1.transpose().dot(t2)
    n = n1 - n2
    sum_delta = ((eta * 2) * n) / np.square(d);
    w = w - sum_delta;

    cost_record[i] = compute_cost(X, y, w)  

  return w, cost_record

w = np.zeros(7)
iterations = 6000;
eta = 0.0015;

w1, cost_record = gradient_descent(X, y, w, eta, iterations)
print('Final w values=', w1)
print('Initial 5 values from cost =', cost_record[:5])
print('Last 5 values from cost =', cost_record[-5 :])

ymean = np.mean(y)
cost2 = 0
predictions1 = X.dot(w1)
errors1 = np.subtract(predictions1, y)
sqrErrors1 = np.square(errors1)
sumErrors1 = np.sum(sqrErrors1)
sqrT = np.square(w1[1:])
d1 = np.sum(sqrT)
d1 = d1 + 1
for i in range(len(y)):
    v = (ymean - y[i]) **(2)
    cost2 = cost2 + v
r2 = 1 - ((sumErrors1/d1) /cost2)
print("r2 value:",r2)

plt.plot(range(1, iterations +1), cost_record, color ='blue')
plt.rcParams["figure.figsize"] = (10,6)
plt.grid()
plt.xlabel("Number of iterations")
plt.ylabel("cost (J)")
plt.title("Convergence of gradient descent")