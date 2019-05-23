
# coding: utf-8

# In[2]:


import pandas as pd
from sqlalchemy import create_engine
import pymssql


# In[3]:


engine = create_engine('mssql+pymssql://sa:Ruut1234@localhost:1433/yelpSingleTable')
conn = engine.connect()


# In[4]:


businesses = pd.read_sql_table("business", conn)
businessFeatures = pd.read_sql_table("businessFeature", conn)
features = pd.read_sql_table("feature", conn)
featureGroups = pd.read_sql_table("featureGroup", conn)


# In[62]:


# Caso d1: Herencia, En main class: Reduccion solo Features
(businessFeatures.merge(features, left_on="feature", right_on="name")
                 .merge(featureGroups, left_on="groupId", right_on="id", 
                        how="left", suffixes=("", "OfGroup"))
                 .drop(["id", "groupId", "name"], axis=1))


# In[9]:


# Caso d3: Business and Features
bfs = (businessFeatures.merge(features, left_on="feature", right_on="name")
                       .drop("name", axis=1))
gfs = (bfs[bfs["type"] == "GroupedFeature"]
      .merge(featureGroups, left_on="groupId", right_on="id")
      .drop(["id"], axis=1)
      .rename(columns={"name" : "group_name"})
      .pivot(index="businessId", columns="feature", values=["available", "group_name"]))
gfs.columns = ['_'.join(col[::-1]).strip() for col in gfs.columns.values]
(businesses.merge((bfs[bfs["type"] == "AvailableFeature"]
                  .pivot(index="businessId", columns="feature", values="available")),
                  left_on="id", right_on="businessId", how="left")
           .merge((bfs[bfs["type"] == "ValuedFeature"]
                  .pivot(index="businessId", columns="feature", values="value")),
                  left_on="id", right_on="businessId", how="left")
           .merge(gfs, left_on="id", right_on="businessId", how="left"))


# In[60]:


conn.close()

