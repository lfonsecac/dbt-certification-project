import os
import snowflake.connector
from datetime import datetime, timedelta
import requests

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
        cursor = conn.cursor()

        cursor.execute(f'USE DATABASE {conn.database};')

        cursor.execute(f'USE SCHEMA {conn.schema};')

        # Put the CSV file into the Snowflake stage
        cursor.execute(f'PUT file://{file_path} @{stage_name}')

    except snowflake.connector.errors.ProgrammingError as e:
        print(f"Snowflake ProgrammingError: {e}")
    finally:
        if cursor:
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
        stage_name = "rankings_boardgames"  # Update with your Snowflake stage name
        upload_to_snowflake(local_file_path, stage_name)

        # Clean up: Remove the local file
        os.remove(local_file_path)
    else:
        print(f"Failed to download CSV file. Status code: {response.status_code}")
