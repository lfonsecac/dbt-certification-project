# Exercise:

## Hooks
Hooks are snippets of SQL that are executed at different times:

- **pre-hook**: executed before a model, seed or snapshot is built.
- **post-hook**: executed after a model, seed or snapshot is built.
- **on-run-start**: executed at the start of dbt build, dbt compile, dbt docs generate, dbt run, dbt seed, dbt snapshot, or dbt test.
- **on-run-end**: executed at the end of dbt build, dbt compile, dbt docs generate, dbt run, dbt seed, dbt snapshot, or dbt test.

Hooks are a more-advanced capability that enable you to run custom SQL, and leverage database-specific actions, beyond what dbt makes available out-of-the-box with standard materializations and configurations.

### Examples using hooks

```sql
-- <model_name>.sql
{{ config(
    post_hook=[
      "alter table {{ this }} ..."
    ]
) }}
```

You can check [dbt docs](https://docs.getdbt.com/docs/build/hooks-operations#about-hooks) for more details about `hooks` command.

## Task: Use hooks to create and insert records on `dbt_audit` table

We're going to apply this feature by creatind an updating a table on the target schema with audit logs of each time dbt executes.

To create and insert records on the `dbt_audit` table we´ll use these 2 macros on the [dbt_audits.sql](dbt_audits.sql) file:
 - **audit_prep:** macro responsible to create the table if doesn't exist
 - **audit_log:** macro responsible to insert records on the table

 We included both macros on the same `.sql` file to exemplify that you can do that to organize your macros. What matters is the name of the `macro` even if the `.sql` file has a different name.

 **Note:** The `invocation_id` property used on the `audit_log` macro outputs a UUID generated for this dbt command. This value is useful when auditing or analyzing dbt invocation metadata. Can check more details on [dbt docs](https://docs.getdbt.com/reference/dbt-jinja-functions/invocation_id).

To use this, we have to follow these steps:
1. Copy the [dbt_audits.sql](dbt_audits.sql) file to the macros folder
2. Add a `on-run-start: ` key inside the `dbt_project.yml` with 2 properties:
  - 2.1. call `audit_prep` macro to create the `dbt_audit` table
  - 2.2. call `audit_log` macro to insert a record on `dbt_audit` table with a run_activity = 'run_start'
3. Add a `on-run-end: ` key inside the `dbt_project.yml` with:
  - 3.1. call `audit_log` macro to insert a record on `dbt_audit` with a run_activity = 'run_end'
4. Add a `+pre-hook: ` key inside the `dbt_project.yml` under `models` with 2 properties:
  - 4.1. use the Jinja `log` function to write the message `'THIS IS A PRE-HOOK'` on `logs`. This will include the message on `dbt.log`.
  - 4.2. call `audit_log` macro to insert a record with a run_activity = 'model_start'
5. Add a `+post-hook: ` key inside the `dbt_project.yml` under `models` with 2 properties:
  - 5.1. use the Jinja `log` function to write the message `'THIS IS A POST-HOOK'` on `logs`. This will include the message on `dbt.log`.
  - 5.2. call `audit_log` macro to insert a record with a run_activity = 'model_end' on `dbt_audit` table
6. Run either a `dbt build` or `dbt run` to execute all models
7. Check the `dbt.log` file inside a folder named `logs` and search for the `pre-hook` log message that should have an output similar to this, where you can see the insert command being executed:

```bash
[0m16:11:30.465041 [debug] [Thread-4 (]: THIS IS A PRE-HOOK
[0m16:11:30.465885 [debug] [Thread-4 (]: Using snowflake connection "model.dbt_certification_project.dim_rankings"
[0m16:11:30.466116 [debug] [Thread-4 (]: On model.dbt_certification_project.dim_rankings: /* {"app": "dbt", "dbt_version": "1.7.4", "profile_name": "boardgame_project", "target_name": "dev", "node_id": "model.dbt_certification_project.dim_rankings"} */
insert into boardgame.dbt_fbalseiro.dbt_audit 
values ('6ee10edd-5478-4366-9ca8-eb1ba0303ddb', 'dim_rankings', 'model_start', current_timestamp());
```

8. Check the datawarehouse where you should have a new table `dbt_audit` on your target schema.

---

### Solution

- [dbt_audits.sql](dbt_audits.sql)
- [dbt_project.yml](dbt_project.yml)

---

[Return to Project Challenges](../../../README.md#9-project-challenges)