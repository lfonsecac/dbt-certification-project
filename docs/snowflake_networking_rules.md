# Network Rules and External Access Integration

```sql
USE ROLE ACCOUNTADMIN;

--create seprate role for network admin as a part of best practices
CREATE ROLE network_admin;
GRANT CREATE NETWORK RULE ON SCHEMA BOARDGAME.RAW TO ROLE network_admin;
GRANT CREATE INTEGRATION ON ACCOUNT TO ROLE network_admin;
GRANT USAGE on DATABASE BOARDGAME to ROLE network_admin ;
GRANT USAGE on SCHEMA BOARDGAME.RAW  to ROLE network_admin ;
GRANT USAGE on WAREHOUSE DBT_CAPSTONE_PROJECT_WH to ROLE network_admin;

-- create role hirarchey
GRANT ROLE network_admin to ROLE SYSADMIN;

USE ROLE network_admin;
USE WAREHOUSE DBT_CAPSTONE_PROJECT_WH;

USE SCHEMA BOARDGAME.RAW;

-- crete networking rules so only those sites are allowed for compliance
CREATE OR REPLACE NETWORK RULE web_access_rule
  MODE = EGRESS
  TYPE = HOST_PORT
  VALUE_LIST = ('drive.google.com', 
                'raw.githubusercontent.com'); 

-- create exernal access integration with networking rule created above
CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION external_access_int
  ALLOWED_NETWORK_RULES = (web_access_rule)
  ENABLED = true;
```