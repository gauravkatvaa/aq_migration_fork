from config import *
from sqlalchemy import create_engine
import pandas as pd

engine = create_engine('mysql+mysqlconnector://', connect_args=meta_db_config)


def fetch_username_email(query):
    # Execute the query and fetch the result into a DataFrame
    df = pd.read_sql_query(query, engine)

    # Close the database connection
    engine.dispose()

    return df

