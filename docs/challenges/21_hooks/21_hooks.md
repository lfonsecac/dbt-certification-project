# Exercise:

## Hooks
Hooks are snippets of SQL that are executed at different times:

- **pre-hook**: executed before a model, seed or snapshot is built.
- **post-hook**: executed after a model, seed or snapshot is built.
- **on-run-start**: executed at the start of dbt build, dbt compile, dbt docs generate, dbt run, dbt seed, dbt snapshot, or dbt test.
- **on-run-end**: executed at the end of dbt build, dbt compile, dbt docs generate, dbt run, dbt seed, dbt snapshot, or dbt test.

Hooks are a more-advanced capability that enable you to run custom SQL, and leverage database-specific actions, beyond what dbt makes available out-of-the-box with standard materializations and configurations.

### Examples using hooks

#### Config block
```sql
-- <model_name>.sql
{{ config(
    post_hook=[
      "alter table {{ this }} ..."
    ]
) }}
```

#### Project file
```yaml
# dbt_project.yml
...

models:
  dbt_certification_project:
    +post-hook: 
      - "alter table {{ this }} ..."
```

You can check [dbt docs](https://docs.getdbt.com/docs/build/hooks-operations#about-hooks) for more details about `hooks` command.

## Task 1: Use hooks to create and insert records on `dbt_audit` table

The goal is to create a `dbt_audit` table with records of each time dbt executes, having details about how much time it took to run each model individually and the execution as a whole.

We're going to apply `hooks` by performing the following actions:

- **on-run-start**: create the table `dbt_audit` if doesn't exist on dbt target schema. To take care of that, we'll define a macro called `audit_prep`. 
Inside that macro, we'll use a *dbt Jinja function* called `target` to reference the `target.database` and `target.schema` avoiding to hardcode these parameters. To find more about `target` function follow this [dbt docs](https://docs.getdbt.com/reference/dbt-jinja-functions/target).
Then, we call the macro `audit_log` to insert a record on the table `dbt_audit` receiving as an argument `run_activity = 'run_start'` to record the timestamp when dbt starts to execute
- **pre-hook**: We'll use a *dbt Jinja function* called `log` to write a message to `dbt.log` file that is located inside `logs` folder on your dbt project. The message is `'THIS IS A PRE-HOOK'`. To find more about `log` function follow this [dbt docs](https://docs.getdbt.com/reference/dbt-jinja-functions/log).
Then, we call the macro `audit_log` to insert a record on the table `dbt_audit` receiving as an argument `run_activity = 'model_start'` to record the timestamp before each model starts to run
- **post-hook**: We'll use a *dbt Jinja function* called `log` to write a message to `dbt.log` file that is located inside `logs` folder on your dbt project. The message is `'THIS IS A POST-HOOK'`.
Then, we call the macro `audit_log` to insert a record on the table `dbt_audit` receiving as an argument `run_activity = 'model_end'` to record the timestamp after each model runs
- **on-run-end**: Call the macro `audit_log` to insert a record on the table `dbt_audit` receiving as an argument `run_activity = 'run_end'` to record the timestamp when dbt finishes the execution



To create and insert records on the `dbt_audit` table we´ll use these 2 macros on the [dbt_audits.sql](dbt_audits.sql) file:
 - **audit_prep:** macro responsible to create the table if doesn't exist
 - **audit_log:** macro responsible to insert records on the table

 We included both macros on the same `.sql` file to exemplify that you can do that to organize your macros. What matters is the name of the `macro` even if the `.sql` file has a different name.

 **Note:** The `invocation_id` property used on the `audit_log` macro outputs a UUID generated for this dbt command. This value is useful when auditing or analyzing dbt invocation metadata. Can check more details on [dbt docs](https://docs.getdbt.com/reference/dbt-jinja-functions/invocation_id).

To use this, we have to follow these steps:
1. Copy the [dbt_audits.sql](dbt_audits.sql) file to the macros folder
2. Add a `on-run-start: ` key inside the `dbt_project.yml` with 2 properties:
  - 2.1. call `audit_prep` macro to create the `dbt_audit` table
  - 2.2. call `audit_log` macro to insert a record on `dbt_audit` table with a `run_activity = 'run_start'`
3. Add a `on-run-end: ` key inside the `dbt_project.yml` with:
  - 3.1. call `audit_log` macro to insert a record on `dbt_audit` with a `run_activity = 'run_end'`
4. Add a `+pre-hook: ` key inside the `dbt_project.yml` under `models` with 2 properties:
  - 4.1. use the Jinja `log` function to write the message `'THIS IS A PRE-HOOK'` on `logs`. This will write the message on `dbt.log`.
  - 4.2. call `audit_log` macro to insert a record with a `run_activity = 'model_start'`
5. Add a `+post-hook: ` key inside the `dbt_project.yml` under `models` with 2 properties:
  - 5.1. use the Jinja `log` function to write the message `'THIS IS A POST-HOOK'` on `logs`. This will write the message on `dbt.log`.
  - 5.2. call `audit_log` macro to insert a record with a `run_activity = 'model_end'` on `dbt_audit` table
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

## Task 2: Use a pre-hook config block on a new model `dim_rankings_current_day`
We're going to create a new model `dim_rankings_current_day` that basically uses a `{{ ref('dim_rankings') }}` but holding only records from the current day.

To do that we're going to use a `pre-hook` on a config block for this model, to delete all the records from this model materialization where date is not equal to current day:

```sql
'{% if is_incremental() %} DELETE FROM {{this}} WHERE date(updated_at) <> current_date()  {% endif %}'
```

Run the model: `dbt run -s dim_rankings_current_day`

### Lessons Learned
Now that we've applied two different `hooks` to the same model `dim_rankings_current_day` what happens?
What is the precedence that dbt considers when running `hooks`? 

It is important to remember that `hooks` are like `tags`: they are cumulative.

So, in this scenario for `dim_rankings_current_day` all the `hooks` are applied: either from `dbt_project.yml` on adding records to `dbt_audit` table and the `pre-hook` on the config block of the model to delete all the records that date is not current date.

Be aware of the execution order that dbt considers for `hooks`.

#### Execution ordering
If multiple instances of any hooks are defined, dbt will run each hook using the following ordering:

1. Hooks from dependent packages will be run before hooks in the active package.
2. Hooks defined within the model itself will be run after hooks defined in `dbt_project.yml`.
3. Hooks within a given context will be run in the order in which they are defined.

---

### Solution

- [dbt_audits.sql](dbt_audits.sql)
- [dbt_project.yml](dbt_project.yml)
- [dim_rankings_current_day.sql](dim_rankings_current_day.sql)
---

[Return to Project Challenges](../../../README.md#9-project-challenges)