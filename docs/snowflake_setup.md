# Introduction and Environment Setup

## Snowflake user creation
Copy these SQL statements into a Snowflake Worksheet, select all and execute them (i.e. pressing the play button).

```sql
-- Use a sysadmin role
USE ROLE SYSADMIN;

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