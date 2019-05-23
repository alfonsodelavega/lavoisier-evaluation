
# coding: utf-8

# In[1]:


import pandas as pd
from sqlalchemy import create_engine
import pymssql


# In[2]:


engine = create_engine('mssql+pymssql://sa:Ruut1234@localhost:1433/yelpSingleTable')
conn = engine.connect()


# In[3]:


reviews = pd.read_sql_table("review", conn)
users = pd.read_sql_table("user", conn)
businesses = pd.read_sql_table("business", conn)
businessCategories = pd.read_sql_table("businessCategory", conn)
businessFeatures = pd.read_sql_table("businessFeature", conn)

# (old): Tabla simple. Reviews
reviews
# In[6]:


# b1: Single-bounded reference
reviews.merge(users, left_on="userId", right_on="id",
              suffixes=("", "User"))


# In[19]:


# c1: Unbounded reference
cat_df = businessCategories
cat_df["dummy"] = 1
(cat_df.pivot(index="businessId", columns="category", values="dummy").fillna(0)
       .merge(businesses, left_on="businessId", right_on="id", how="right"))

# (old): Referencia unbounded. Business y features (solo available, sin herencia)
(businessFeatures.pivot(index="b_id", columns="f_name", values="available")
                 .merge(businesses, on="b_id", how="right"))
# In[20]:


# e2: Combination (multilevel)
cat_df = businessCategories
cat_df["dummy"] = 1
reviews.merge((cat_df.pivot(index="businessId", columns="category", values="dummy").fillna(0)
                     .merge(businesses, left_on="businessId", right_on="id", how="right")),
              left_on="businessId", right_on="id", suffixes=("Review", "Business"))


# In[21]:


conn.close()

