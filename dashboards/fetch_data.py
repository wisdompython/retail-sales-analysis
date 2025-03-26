import pandas as pd
import pyathena
import os
import streamlit as st #only needed for caching
from dotenv import load_dotenv

load_dotenv()

TABLE_NAME = os.getenv("TABLE_NAME")
DATABASE = os.getenv("DATABASE_NAME")
S3_BUCKET_PATH = os.getenv("S3_BUCKET_PATH")
REGION = os.getenv("REGION")

@st.cache_data
def query_data(table_name: str, database: str, s3_dir: str, region: str):
    query = f'SELECT * FROM "{database}"."{table_name}"'
    connection = pyathena.connect(s3_staging_dir=s3_dir, region=region)
    df = pd.read_sql(
        query, con=connection
    )
    return df

def get_age_group_data():
    df = query_data(table_name=TABLE_NAME, database=DATABASE, s3_dir=S3_BUCKET_PATH, region=REGION)
    return df['age group'].value_counts()

def get_spending_data():
    return query_data(table_name=TABLE_NAME, database=DATABASE, s3_dir=S3_BUCKET_PATH, region=REGION)

def get_gender_data(gender):
    df = query_data(table_name=TABLE_NAME, database=DATABASE, s3_dir=S3_BUCKET_PATH, region=REGION)
    return df[df['gender'] == gender]