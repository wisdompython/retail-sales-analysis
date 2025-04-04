# Show data in Streamlit UI

import streamlit as st
import plotly.express as px
from fetch_data import get_age_group_data, get_spending_data, get_gender_data

st.title("Retail Sales Customer Behaviour Analysis")

# @st.cache_data
def plot_age_group():
    st.header("Age group distribution")
    age_data = get_age_group_data()
    fig = px.bar(x=age_data.index, y=age_data.values)
    st.plotly_chart(fig, graph=10)

def spending_power():
    st.header("Spending Power")
    df = get_spending_data()
    fig = px.histogram(df, x='gender', y='total amount')
    st.plotly_chart(fig, graph=15)

def purchase_by_gender(gender):
    st.header(f"{gender} purchases".capitalize())
    df = get_gender_data(gender)
    fig = px.histogram(df, x='product category', y='total amount')
    st.plotly_chart(fig, use_container_width=True, key=f"plot_{gender}")

col1, col2 = st.columns(2)

with col1:
    plot_age_group()
    purchase_by_gender("male")

with col2:
    spending_power()
    purchase_by_gender("female")



# @st.cache_data
# def plot_age_group():

#     df: pd.DataFrame = query_data(
#         table_name=TABLE_NAME, database=DATABASE, s3_dir=S3_BUCKET_PATH, region=REGION
#     )
#     st.header("Age group distribution")

#     #df = pd.read_csv("./dashboards/result.csv")

#     age_group = df['age group'].value_counts()
#     fig = px.bar(
#         data_frame=df, x=df['age group']
#     )
#     st.plotly_chart(fig)


# def spending_power():
#     st.header("Spending Power")
#     df: pd.DataFrame = query_data(
#         table_name=TABLE_NAME, database=DATABASE, s3_dir=S3_BUCKET_PATH, region=REGION
#     )
#     fig = px.histogram(data_frame= df, x='gender', y='total amount')
#     st.plotly_chart(fig)


# def purchase_by_gender(gender):
#     st.header(f"{gender} purchases".capitalize())
    
#     df: pd.DataFrame = query_data(
#         table_name=TABLE_NAME, database=DATABASE, s3_dir=S3_BUCKET_PATH, region=REGION
#     )
    
#     fig = px.histogram(data_frame= df[df['gender'] == gender], x='product category', y='total amount')
#     st.plotly_chart(fig, use_container_width=True, key=f"plot_{gender}")

# # # Ensures Streamlit UI only runs if this script is executed directly
# def main():
    
#     st.title("Retail Sales Customer Behaviour Analysis")

#     col1, col2 = st.columns(2)

#     with col1:
#         plot_age_group()
#         purchase_by_gender("male")

#     with col2:
#         spending_power()
#         purchase_by_gender("female")


# if __name__ == "__main__":
#     main()