# Stored Procedure on Snowflake to load data from internal stage to table Rankings

```sql
CREATE OR REPLACE PROCEDURE load_data_from_stage(
    database_dest STRING, 
    schema_dest STRING,
    stage_name STRING
)
RETURNS STRING
LANGUAGE PYTHON
RUNTIME_VERSION = '3.10'
PACKAGES = ('snowflake-snowpark-python', 'pandas')
HANDLER = 'load_data'
EXECUTE AS CALLER
AS
$$


import snowflake.snowpark as snowpark
# from snowflake.snowpark.dataframe import *
from datetime import timedelta, date, datetime
import pandas as pd


def load_data(session: snowpark.Session, database_dest, schema_dest, stage_name):

    # Set the destination database and schema
    session.sql(f"USE DATABASE {database_dest};").collect()
    session.sql(f"USE SCHEMA {schema_dest};").collect()
    
    # Check for files in the stage
    files_on_stage = session.sql(f"""
        SELECT distinct(METADATA$FILENAME) FILE
        FROM @{database_dest}.{schema_dest}.{stage_name};
    """).collect()

    # Create a DataFrame to store file and the table name 
    df_files_information = pd.DataFrame(columns=['FILE_NAME', 'TABLE_NAME'])
    
    # Split the information to get file name and table name 
    for file in files_on_stage:
        file_name, table_name = file['FILE'], file['FILE'].split('_')[0]

        new_df = pd.DataFrame({
            'FILE_NAME': [file_name], 
            'TABLE_NAME': [table_name]
        })

        df_files_information = pd.concat([df_files_information, new_df], ignore_index=True)
        
    session.sql(f""" 
        CREATE OR REPLACE FILE FORMAT copy_into_rankings
          TYPE = 'CSV'
          FIELD_DELIMITER = ',' 
          FIELD_OPTIONALLY_ENCLOSED_BY = '"'
          PARSE_HEADER = TRUE
          ;
    """).collect()

    session.sql(f"""
        CREATE OR REPLACE TABLE {table_name}
            USING TEMPLATE (
                SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*))
                FROM TABLE(
                    INFER_SCHEMA(
                        LOCATION=>'@{stage_name}/{file_name}',
                        FILE_FORMAT=>'copy_into_rankings'
                    )
                )
            );
    """).collect()

    # Execute COPY INTO command for each table
    session.sql(f"""
        COPY INTO {table_name}
        FROM '@{stage_name}/{file_name}'
        FILE_FORMAT = (FORMAT_NAME = 'copy_into_rankings')
        ON_ERROR = SKIP_FILE
        PURGE = TRUE
        MATCH_BY_COLUMN_NAME = CASE_SENSITIVE;
    """).collect()
    
    return f"Data loaded to '{database_dest}.{schema_dest}.{table_name}'"

$$
```