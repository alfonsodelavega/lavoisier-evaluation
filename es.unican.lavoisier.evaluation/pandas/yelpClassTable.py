
# coding: utf-8

# In[1]:


import pandas as pd
from sqlalchemy import create_engine
import pymssql


# In[2]:


engine = create_engine('mssql+pymssql://sa:Ruut1234@localhost:1433/yelpConcreteTable')
conn = engine.connect()


# In[3]:


businesses = pd.read_sql_table("business", conn)
availableFeatures = pd.read_sql_table("availableFeature", conn)
valuedFeatures = pd.read_sql_table("valuedFeature", conn)
groupedFeatures = pd.read_sql_table("groupedFeature", conn)
features = pd.read_sql_table("feature", conn)
featureGroups = pd.read_sql_table("featureGroup", conn)


# In[4]:


# d3: Inheritance
(availableFeatures.append(valuedFeatures, sort=False)
                  .append(groupedFeatures.merge(featureGroups, left_on="groupId", right_on="id")
                                         .drop(["groupId", "id"], axis=1)
                                         .rename(columns={"name" : "group_name"}),
                          sort=False)
                  .merge(features, left_on="feature", right_on="name")
                  .drop(["feature"], axis=1))


# In[9]:


# d6: Unbounded Inheritance
gfs = (groupedFeatures.merge(featureGroups,
                             left_on="groupId", right_on="id")
                      .drop("groupId", axis=1)
                      .rename(columns={"name" : "group_name"})
                      .merge(features, left_on="feature", right_on="name")
                      .pivot(index="businessId", columns="name", values=["available", "group_name"]))
gfs.columns = ['_'.join(col[::-1]).strip() for col in gfs.columns.values]

(businesses.merge(availableFeatures.merge(features, left_on="feature", right_on="name")
                                   .pivot(index="businessId", columns="name", values="available"),
                  left_on="id", right_on="businessId", how="left")
           .merge(valuedFeatures.merge(features, left_on="feature", right_on="name")
                                .pivot(index="businessId", columns="name", values="value"),
                  left_on="id", right_on="businessId", how="left")
           .merge(gfs, left_on="id", right_on="businessId", how="left"))


# In[21]:


conn.close()

