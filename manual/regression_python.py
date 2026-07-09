#!/usr/bin/env python
# coding: utf-8

# This notebook demonstrates a simple linear regression analysis using Python to model Salary based on Years of Experience.

# In[7]:


import pandas as pd
import matplotlib.pyplot as plt
import sys
from sklearn.linear_model import LinearRegression 

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


# In[16]:


plt.plot(data[[x_col]], model.predict(data[[x_col]]), color="red")
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




