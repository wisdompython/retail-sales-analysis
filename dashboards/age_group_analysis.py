import streamlit as st
import pandas as pd
import numpy as np
import plotly.express as px
import pyathena 
from general_info import *

def age_group_purchases():
    
    st.header("Spending Power by age group".capitalize())
    df: pd.DataFrame = query_data(
        table_name=TABLE_NAME, database=DATABASE, s3_dir=S3_BUCKET
    )
    fig = px.histogram(data_frame= df, x='age group', y='total amount')
    st.plotly_chart(fig)

col1, col2 = st.columns(2)

with col1:
    age_group_purchases()


with col2:
    pass