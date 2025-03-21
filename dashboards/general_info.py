import streamlit as st
import pandas as pd
import numpy as np
import plotly.express as px
import pyathena 


st.title("Retail Sales Customer Behaviour Analysis")

TABLE_NAME = ""
DATABASE = ""
S3_BUCKET = ""
REGION = ""

@st.cache_data
def query_data(
        table_name: str, database: str, s3_dir: str, region: str
):
    query = f" SELECT * FROM {database}.{table_name}"
    connection = pyathena.connect(s3_staging_dir=s3_dir, region=region)
    df = pd.read_sql(
        query, con=connection
    )
    return df

@st.cache_data
def plot_age_group():

    df: pd.DataFrame = query_data(
        table_name=TABLE_NAME, database=DATABASE, s3_dir=S3_BUCKET, region=REGION
    )
    st.header("Age group distribution")

    #df = pd.read_csv("./dashboards/result.csv")

    age_group = df['age group'].value_counts()
    fig = px.bar(
        data_frame=df, x=df['age group']
    )
    st.plotly_chart(fig)


def spending_power():
    st.header("Spending Power")
    df: pd.DataFrame = query_data(
        table_name=TABLE_NAME, database=DATABASE, s3_dir=S3_BUCKET
    )
    fig = px.histogram(data_frame= df, x='gender', y='total amount')
    st.plotly_chart(fig)


def purchase_by_gender(gender):
    st.header(f"{gender} purchases".capitalize())
    
    df: pd.DataFrame = query_data(
        table_name=TABLE_NAME, database=DATABASE, s3_dir=S3_BUCKET
    )
    
    fig = px.histogram(data_frame= df[df['gender'] == gender], x='product category', y='total amount')
    st.plotly_chart(fig)

col1, col2 = st.columns(2)

with col1:
    plot_age_group()
    purchase_by_gender("male")
    

with col2:
    spending_power()
    purchase_by_gender("female")
