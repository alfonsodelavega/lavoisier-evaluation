
# coding: utf-8

# In[2]:


import pandas as pd
from sqlalchemy import create_engine
import pymssql


# In[3]:


engine = create_engine('mssql+pymssql://sa:Ruut1234@localhost:1433/yelpConcreteTable')
conn = engine.connect()


# In[4]:


businesses = pd.read_sql_table("business", conn)
availableFeatures = pd.read_sql_table("availableFeature", conn)
valuedFeatures = pd.read_sql_table("valuedFeature", conn)
groupedFeatures = pd.read_sql_table("groupedFeature", conn)
features = pd.read_sql_table("feature", conn)
featureGroups = pd.read_sql_table("featureGroup", conn)


# In[19]:


# Caso d2: Inheritance
(availableFeatures.append(valuedFeatures, sort=False)
                  .append(groupedFeatures.merge(featureGroups,
                                                left_on="groupId", right_on="id")
                                         .drop(["groupId", "id"], axis=1)
                                         .rename(columns={"name" : "group_name"}),
                          sort=False))


# In[5]:


# Caso d5: Unbounded Inheritance
gfs = (groupedFeatures.merge(featureGroups,
                             left_on="groupId", right_on="id")
                      .drop("groupId", axis=1)
                      .rename(columns={"name" : "group_name"})
                      .pivot(index="businessId", columns="feature", values=["available", "group_name"]))
gfs.columns = ['_'.join(col[::-1]).strip() for col in gfs.columns.values]

(businesses.merge(availableFeatures.pivot(index="businessId", columns="feature", values="available"),
                  left_on="id", right_on="businessId", how="left")
           .merge(valuedFeatures.pivot(index="businessId", columns="feature", values="value"),
                  left_on="id", right_on="businessId", how="left")
           .merge(gfs, left_on="id", right_on="businessId", how="left"))


# In[21]:


conn.close()

