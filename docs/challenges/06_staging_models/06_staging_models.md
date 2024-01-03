# Exercise:

## Create staging models
- Staging models are 1:1 with each source table and named with the following convention: `stg_<source>__<table_name>.sql` (ex: `stg_boardgames__reviews.sql`)
  - [Additional context on Staging models](https://docs.getdbt.com/guides/best-practices/how-we-structure/2-staging)

  - Use the [`source`](https://docs.getdbt.com/reference/dbt-jinja-functions/source) function to create the relationship between the source tables and staging models

- Use the [Data Dictionary](https://docs.google.com/spreadsheets/d/1W3oXg2I52cy2oLPJQz7Ah4a8TQGju9yByI57JWWFbEc/edit?usp=drive_link) as a baseline to perform the following validations and adjustments that are recommended on this stage:

✅ **Renaming:** e.g. Translating French column name to English, adding prefix datetime_ to TIMESTAMP columns, etc.
✅ **Type casting:** e.g. casting id_product (STRING) to id_product (INTEGER)
✅ **Basic computations:** e.g. cents to dollars, gram to kilogram
✅ **Categorizing:** using conditional logic to group values into buckets or booleans, such as in `CASE WHEN` statement.

Here are a few examples of adjustments that we can make to our specific project:
**Global:**
- Rename column names to follow the structure `<object>_<attribute>` like `boargame_id`

**Boardgames:**
- Categorize types of games into `boardgame` and `not boardgame`
- Cast rating and weight columns to float data type
- Adjust the records values for rating, weight, min_players, max_players, min_play_time, max_play_time, min_age to easily identify outliers (ex: rating = 'nan' or min_players = 0) 


### Materialization
Update your `dbt_project.yml` adding a configuration for the entire staging directory to be materialized as view.

``` yaml
# dbt_project.yml

models:
  dbt_capstone_project:
    staging:
      +materialized: view
```

In order to define the staging model to consume the `snapshot` defined for the `Rankings` table we can use the `ref()` function to build a model on top of that.
For more information you can check this [blog post](https://discourse.getdbt.com/t/building-models-on-top-of-snapshots/517).

I've followed the approach that uses a variable on the dbt project `the_distant_future`, to make the future date consistent across models, like this example below:

```sql 
select
  ...,
  dbt_valid_from as valid_from,
  coalesce(
      dbt_valid_to,
      {{ var('the_distant_future') }}
  ) as valid_to

from {{ ref('snapshot_orders') }}
```

To create the models you can use the command:
```bash
# Runs all the models defined on dbt_project.yml model-paths
dbt run
```

```bash
# Runs all the models on the staging folder
dbt run -s staging.*
```

### Troubleshooting Issues
If you get any error running the models, you could get a similar error message like this one:

```bash
16:30:49  Concurrency: 1 threads (target='dev')
16:30:49  
16:30:49  1 of 9 START sql view model dbt_fbalseiro.stg_boardgames__artists .............. [RUN]
16:30:50  1 of 9 OK created sql view model dbt_fbalseiro.stg_boardgames__artists ......... [SUCCESS 1 in 0.70s]
16:30:50  2 of 9 START sql view model dbt_fbalseiro.stg_boardgames__boardgames ........... [RUN]
16:30:51  2 of 9 OK created sql view model dbt_fbalseiro.stg_boardgames__boardgames ...... [SUCCESS 1 in 0.70s]
16:30:51  3 of 9 START sql view model dbt_fbalseiro.stg_boardgames__categories ........... [RUN]
16:30:51  3 of 9 OK created sql view model dbt_fbalseiro.stg_boardgames__categories ...... [SUCCESS 1 in 0.67s]
16:30:51  4 of 9 START sql view model dbt_fbalseiro.stg_boardgames__designers ............ [RUN]
16:30:52  4 of 9 OK created sql view model dbt_fbalseiro.stg_boardgames__designers ....... [SUCCESS 1 in 0.73s]
16:30:52  5 of 9 START sql view model dbt_fbalseiro.stg_boardgames__mechanics ............ [RUN]
16:30:53  5 of 9 OK created sql view model dbt_fbalseiro.stg_boardgames__mechanics ....... [SUCCESS 1 in 0.69s]
16:30:53  6 of 9 START sql view model dbt_fbalseiro.stg_boardgames__publishers ........... [RUN]
16:30:53  6 of 9 OK created sql view model dbt_fbalseiro.stg_boardgames__publishers ...... [SUCCESS 1 in 0.74s]
16:30:53  7 of 9 START sql view model dbt_fbalseiro.stg_boardgames__rankings ............. [RUN]
16:30:54  7 of 9 ERROR creating sql view model dbt_fbalseiro.stg_boardgames__rankings .... [ERROR in 0.64s]
16:30:54  8 of 9 START sql view model dbt_fbalseiro.stg_boardgames__reviews .............. [RUN]
16:30:55  8 of 9 OK created sql view model dbt_fbalseiro.stg_boardgames__reviews ......... [SUCCESS 1 in 0.68s]
16:30:55  9 of 9 START sql view model dbt_fbalseiro.stg_boardgames__users ................ [RUN]
16:30:55  9 of 9 OK created sql view model dbt_fbalseiro.stg_boardgames__users ........... [SUCCESS 1 in 0.69s]
16:30:55  
16:30:55  Finished running 9 view models in 0 hours 0 minutes and 8.43 seconds (8.43s).
16:30:55  
16:30:55  Completed with 1 error and 0 warnings:
16:30:55  
16:30:55    Database Error in model stg_boardgames__rankings (models/staging/stg_boardgames__rankings.sql)
  000904 (42000): SQL compilation error: error line 22 at position 15
  invalid identifier '"https://boardgamegeek.com"'
  compiled Code at target/run/dbt_capstone_project/models/staging/stg_boardgames__rankings.sql
16:30:55  
16:30:55  Done. PASS=8 WARN=0 ERROR=1 SKIP=0 TOTAL=9
```

Like mentioned earlier, you should always check the compiled code on the target path to debug the error.

After that, you can ask dbt to run only the model with an error on the last attempt, by using this command:

```bash
# Runs all the models on the staging folder
dbt run -s result:error --state ./target
```

You can check [dbt docs](https://docs.getdbt.com/reference/node-selection/syntax#the-result-status) for more details.

---

### Solution
- [_boardgames__models.yml](./staging/_boardgames__models.yml)
- [stg_boardgames__artists.sql](./staging/stg_boardgames__artists.sql)
- [stg_boardgames__boardgames.sql](./staging/stg_boardgames__boardgames.sql)
- [stg_boardgames__categories.sql](./staging/stg_boardgames__categories.sql)
- [stg_boardgames__designers.sql](./staging/stg_boardgames__designers.sql)
- [stg_boardgames__mechanics.sql](./staging/stg_boardgames__mechanics.sql)
- [stg_boardgames__publishers.sql](./staging/stg_boardgames__publishers.sql)
- [stg_boardgames__rankings.sql](./staging/stg_boardgames__rankings.sql)
- [stg_boardgames__reviews.sql](./staging/stg_boardgames__reviews.sql)
- [stg_boardgames__users.sql](./staging/stg_boardgames__users.sql)
- [dbt_project.yml](./dbt_project.yml)


---

[Return to Project Challenges](../../../README.md#9-project-challenges)