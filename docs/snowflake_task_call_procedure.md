# Task to automate Stored Procedure to load data from stage

```sql
create or replace task RANKINGS_LOAD_TASK
	warehouse=DBT_CERTIFICATION_PROJECT_WH
	schedule='USING CRON 15 10 * * * UTC'
	as CALL load_data_from_stage('BOARDGAME', 'RAW', 'RANKINGS_BOARDGAMES');
```

## Resume Task
```sql
ALTER TASK RANKINGS_LOAD_TASK RESUME;
```