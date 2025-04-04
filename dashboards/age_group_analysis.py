import streamlit as st
import plotly.express as px
from fetch_data import get_spending_data  # Only import what you need

def age_group_purchases():
    st.header("Spending Power by Age Group")
    df = get_spending_data()
    fig = px.histogram(df, x='age group', y='total_amount')
    st.plotly_chart(fig, key="graph_5")

col1, col2 = st.columns(2)
with col1:
    age_group_purchases()
with col2:
    pass

# import streamlit as st
# import pandas as pd
# import numpy as np
# import plotly.express as px
# import pyathena 
# from general_info import *

# def age_group_purchases():
    
#     st.header("Spending Power by age group".capitalize())
#     df: pd.DataFrame = query_data(
#         table_name=TABLE_NAME, database=DATABASE, s3_dir=S3_BUCKET_PATH, region=REGION
#     )
#     fig = px.histogram(data_frame= df, x='age group', y='total amount')
#     st.plotly_chart(fig)

# col1, col2 = st.columns(2)

# with col1:
#     age_group_purchases()


# with col2:
#     pass