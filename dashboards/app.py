import streamlit as st

general_data = st.Page("general_info.py", title="home")
gender_analysis = st.Page("age_group_analysis.py", title="age_group_analysis")

pg = st.navigation([general_data, gender_analysis])
pg.run()