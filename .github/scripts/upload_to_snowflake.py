import os
import snowflake.connector
import pandas as pd
from datetime import datetime, timedelta
import requests

def upload_to_snowflake(file_path, stage_name, user, password, account, warehouse, database, schema, role):
    conn = snowflake.connector.connect(
        user=user,
        password=password,
        account=account,
        warehouse=warehouse,
        database=database,
        schema=schema,
        role=role
    )

    try:
        cursor = conn.cursor()

        cursor.execute(f'USE ROLE {role};')
        cursor.execute(f'USE DATABASE {database};')
        cursor.execute(f'USE SCHEMA {schema};')

        # Put the CSV file into the Snowflake stage
        cursor.execute(f'PUT file://{file_path} @{stage_name} AUTO_COMPRESS=FALSE;')

        print(f"Succesfully uploaded {file_path} file into stage: {database}.{schema}.{stage_name}")

    except snowflake.connector.errors.ProgrammingError as e:
        print(f"Snowflake ProgrammingError: {e}")
    finally:
        if cursor:
            cursor.close()
        conn.close()

def process_csv(file_path):
    # Load CSV as a Pandas DataFrame
    df = pd.read_csv(file_path)

    # Add a new column with the date in the format YYYY-MM-DD
    yesterday = datetime.now() - timedelta(days=1)
    df['updated_at'] = datetime.now()

    # Save the DataFrame back to the CSV file
    df.to_csv(file_path, index=False)

if __name__ == "__main__":
    # Snowflake credentials
    user=os.getenv("SNOWFLAKE_USER")
    password=os.getenv("SNOWFLAKE_PASSWORD")
    account=os.getenv("SNOWFLAKE_ACCOUNT")
    warehouse=os.getenv("SNOWFLAKE_WAREHOUSE")
    database=os.getenv("SNOWFLAKE_DATABASE")
    schema=os.getenv("SNOWFLAKE_SCHEMA")
    role=os.getenv("SNOWFLAKE_ROLE")
    stage_name=os.getenv("SNOWFLAKE_STAGE")

    # Define the file URL based on the day before the present day
    yesterday = datetime.now() - timedelta(days=1)
    file_url = f'https://raw.githubusercontent.com/beefsack/bgg-ranking-historicals/master/{yesterday.strftime("%Y-%m-%d")}.csv'

    # Download the CSV file
    response = requests.get(file_url)
    if response.status_code == 200:
        # Save the downloaded CSV file locally
        local_file_path = f"rankings_{yesterday.strftime('%Y-%m-%d')}.csv"
        with open(local_file_path, "wb") as f:
            f.write(response.content)

        # Process the CSV file
        process_csv(local_file_path)

        # Upload the processed CSV file to Snowflake
        upload_to_snowflake(local_file_path, stage_name, user, password, account, warehouse, database, schema, role)

        # Clean up: Remove the local file
        os.remove(local_file_path)

    else:
        print(f"Failed to download CSV file. Status code: {response.status_code}")
