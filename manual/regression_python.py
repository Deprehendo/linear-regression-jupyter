#!/usr/bin/env python
# coding: utf-8

# This notebook demonstrates a simple linear regression analysis using Python to model Salary based on Years of Experience.

# In[7]:


import pandas as pd
import matplotlib.pyplot as plt
import sys
from sklearn.linear_model import LinearRegression
from scipy.stats import linregress
from sklearn.metrics import mean_squared_error


filename = sys.argv[1]
x_col = sys.argv[2]
y_col = sys.argv[3]

data = pd.read_csv(filename)


# In[8]:


data


# In[9]:


x = data[[x_col]]
x


# In[10]:


y = data[[y_col]]
y


# In[12]:


plt.scatter(x,y)


# In[15]:



model = LinearRegression()
model.fit(data[[x_col]], data[[y_col]])

# linregress

slope, intercept, r_value, p_value, std_err = linregress(x, y)
print(slope)
y_pred = slope * x + intercept

#MSE

mse = mean_squared_error(y, y_pred)
print("MSE =")
print(mse)


# In[16]:
max_y = max(data[y_col])
print(max_y)

plt.plot(data[[x_col]], y_pred, label = "Fitted Line", color="red")
plt.text(1.2, max_y - 3500,
         f"y = {slope.item():.2f}x + {intercept.item():.2f}\n"
         f"r = {r_value.item():.2f}\n MSE = {mse:.2f}",
         fontsize=12)
plt.title(f'{y_col} vs {x_col}')
plt.xlabel(x_col)
plt.ylabel(y_col)
plt.savefig("linear_regression_python_output.png")
plt.show()


# In[18]:


print('R-squared value')
R2 = model.score(data[[x_col]], data[[y_col]])  # R-squared
print(R2)

# In[ ]:





