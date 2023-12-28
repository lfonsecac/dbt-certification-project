import os
import snowflake.connector
from datetime import datetime, timedelta
import requests

def create_or_replace_stage(conn, stage_name, database, schema):

    print("Database: ", database)
    print("Schema: ", schema)
    try:
        cursor = conn.cursor()

        cursor.execute(f'USE DATABASE {database};')

        cursor.execute(f'USE SCHEMA {schema};')

        cursor.execute(f'''CREATE OR REPLACE FILE FORMAT csv_file_format
          TYPE = "CSV"
          FIELD_DELIMITER = "," 
          PARSE_HEADER = TRUE''')

        cursor.execute(f"CREATE OR REPLACE STAGE {stage_name} "
                       "FILE_FORMAT = (FORMAT_NAME = 'csv_file_format') "
                       )

    finally:
        cursor.close()

def upload_to_snowflake(file_path, stage_name):
    conn = snowflake.connector.connect(
        user=os.getenv("SNOWFLAKE_USER"),
        password=os.getenv("SNOWFLAKE_PASSWORD"),
        account=os.getenv("SNOWFLAKE_ACCOUNT"),
        warehouse="DBT_CAPSTONE_PROJECT_WH",
        database="BOARDGAME",
        schema="RAW"
    )

    try:
        # Create or replace the Snowflake stage
        create_or_replace_stage(conn, stage_name, conn.database, conn.schema)

        cursor = conn.cursor()

        # Put the CSV file into the Snowflake stage
        cursor.execute(f'PUT file://{file_path} @{stage_name}')

    finally:
        cursor.close()
        conn.close()

if __name__ == "__main__":
    # Define the file URL based on the day before the present day
    yesterday = datetime.now() - timedelta(days=1)
    file_url = f'https://raw.githubusercontent.com/beefsack/bgg-ranking-historicals/master/{yesterday.strftime("%Y-%m-%d")}.csv'

    # Download the CSV file
    response = requests.get(file_url)
    if response.status_code == 200:
        # Save the downloaded CSV file locally
        local_file_path = f"{yesterday.strftime('%Y-%m-%d')}.csv"
        with open(local_file_path, "wb") as f:
            f.write(response.content)

        # Upload the CSV file to Snowflake
        stage_name = "stage_csv"  # Update with your Snowflake stage name
        upload_to_snowflake(local_file_path, stage_name)

        # Clean up: Remove the local file
        os.remove(local_file_path)
    else:
        print(f"Failed to download CSV file. Status code: {response.status_code}")