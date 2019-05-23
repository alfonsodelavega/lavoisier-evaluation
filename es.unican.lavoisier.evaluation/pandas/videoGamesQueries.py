
# coding: utf-8

# In[1]:


import pandas as pd
from sqlalchemy import create_engine
import pymssql


# In[2]:


engine = create_engine('mssql+pymssql://sa:Ruut1234@localhost:1433/videoGames')
conn = engine.connect()


# In[3]:


videoGames = pd.read_sql_table("videoGame", conn)
achievements = pd.read_sql_table("achievement", conn)
textLanguages = pd.read_sql_table("textLanguage", conn)
publishers = pd.read_sql_table("publisher", conn)
gameTags = pd.read_sql_table("gameTag", conn)


# In[4]:


# a: Single table/class
videoGames


# In[4]:


# b2: Single-bounded reference
achievements.merge(videoGames, left_on="videoGameId", right_on="id",
                   suffixes=("", "VideoGame"))


# In[6]:


# c2: Unbounded reference
langs_df = textLanguages
langs_df["dummy"] = 1
(langs_df.pivot(index="videoGameId", columns="language", values="dummy").fillna(0)
         .merge(videoGames, left_on="videoGameId", right_on="id"))


# In[7]:


# e1: Combination (multiple)
tags_df = gameTags
tags_df["dummy"] = 1
(tags_df.pivot(index="videoGameId", columns="tag", values="dummy").fillna(0)
        .merge(videoGames, left_on="videoGameId", right_on="id")
        .merge(publishers, left_on="publisherId", right_on="id",
               suffixes=("", "Publisher")))


# In[8]:


conn.close()

