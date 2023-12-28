# Introduction and Environment Setup

## Snowflake user creation
Copy these SQL statements into a Snowflake Worksheet, select all and execute them (i.e. pressing the play button).

```sql
-- Use an admin role
USE ROLE ACCOUNTADMIN;

-- Create the `transform` role
CREATE ROLE IF NOT EXISTS transform;
GRANT ROLE TRANSFORM TO ROLE DATA_ENGINEER;

-- Create the default warehouse if necessary
CREATE WAREHOUSE IF NOT EXISTS DBT_CAPSTONE_PROJECT_WH;
GRANT OPERATE ON WAREHOUSE DBT_CAPSTONE_PROJECT_WH TO ROLE TRANSFORM;

-- Create the `dbt` user and assign to role
CREATE USER IF NOT EXISTS dbt
  PASSWORD='dbtPassword123'
  LOGIN_NAME='dbt'
  MUST_CHANGE_PASSWORD=FALSE
  DEFAULT_WAREHOUSE='DBT_CAPSTONE_PROJECT_WH'
  DEFAULT_ROLE='transform'
  DEFAULT_NAMESPACE='BOARDGAME.RAW'
  COMMENT='DBT user used for data transformation';
GRANT ROLE transform to USER dbt;

-- Create our database and schemas
CREATE DATABASE IF NOT EXISTS BOARDGAME;
CREATE SCHEMA IF NOT EXISTS BOARDGAME.RAW;

-- Set up permissions to role `transform`
GRANT ALL ON WAREHOUSE DBT_CAPSTONE_PROJECT_WH TO ROLE transform; 
GRANT ALL ON DATABASE BOARDGAME to ROLE transform;
GRANT ALL ON ALL SCHEMAS IN DATABASE BOARDGAME to ROLE transform;
GRANT ALL ON FUTURE SCHEMAS IN DATABASE BOARDGAME to ROLE transform;
GRANT ALL ON ALL TABLES IN SCHEMA BOARDGAME.RAW to ROLE transform;
GRANT ALL ON FUTURE TABLES IN SCHEMA BOARDGAME.RAW to ROLE transform;

```

## Snowflake data import

Copy these SQL statements into a Snowflake Worksheet, select all and execute them (i.e. pressing the play button).

```sql
-- Set up the defaults
USE WAREHOUSE DBT_CAPSTONE_PROJECT_WH;
USE DATABASE BOARDGAME;
USE SCHEMA RAW;

-- Create our three tables and import the data from S3
CREATE OR REPLACE TABLE raw_listings
                    (id integer,
                     listing_url string,
                     name string,
                     room_type string,
                     minimum_nights integer,
                     host_id integer,
                     price string,
                     created_at datetime,
                     updated_at datetime);
                    
COPY INTO raw_listings (id,
                        listing_url,
                        name,
                        room_type,
                        minimum_nights,
                        host_id,
                        price,
                        created_at,
                        updated_at)
                   from 's3://dbtlearn/listings.csv'
                    FILE_FORMAT = (type = 'CSV' skip_header = 1
                    FIELD_OPTIONALLY_ENCLOSED_BY = '"');
                    

CREATE OR REPLACE TABLE raw_reviews
                    (listing_id integer,
                     date datetime,
                     reviewer_name string,
                     comments string,
                     sentiment string);
                    
COPY INTO raw_reviews (listing_id, date, reviewer_name, comments, sentiment)
                   from 's3://dbtlearn/reviews.csv'
                    FILE_FORMAT = (type = 'CSV' skip_header = 1
                    FIELD_OPTIONALLY_ENCLOSED_BY = '"');
                    

CREATE OR REPLACE TABLE raw_hosts
                    (id integer,
                     name string,
                     is_superhost string,
                     created_at datetime,
                     updated_at datetime);
                    
COPY INTO raw_hosts (id, name, is_superhost, created_at, updated_at)
                   from 's3://dbtlearn/hosts.csv'
                    FILE_FORMAT = (type = 'CSV' skip_header = 1
                    FIELD_OPTIONALLY_ENCLOSED_BY = '"');

```
