# Exercise:

## Add Marts Models (Core)
This is the layer where everything comes together and we start to arrange all of our `atoms` (staging models) and `molecules` (intermediate models) into full-fledged cells that identity and purpose.

You can check [dbt docs](https://docs.getdbt.com/best-practices/how-we-structure/4-marts) for more details about marts.

## Task: Create dimension and fact tables
The goal is to implement the models that are represented on the Snowflake Schema below.

[Data Model - Snowflake Schema](https://miro.com/app/board/uXjVN-3i7mo=/?moveToWidget=3458764574588845913&cot=14)

The fact and dimension tables are described below.

### Fact table
- **fct_reviews:** a fact table that gets data from `stg_boardgames__reviews` model. Each record in the fact table (also known as the [grain](https://www.kimballgroup.com/data-warehouse-business-intelligence-resources/kimball-techniques/dimensional-modeling-techniques/grain/)) is a review with a rating for a boardgame.

### Dimension tables
- **dim_users:** a dimension table that gets data from `int_users_countries_joined` intermediate model that combines info from `users` and `countries`.
- **dim_boardgames:** a dimension table that gets data from `int_boardgames__boardgames_filtered`.
- **dim_artists:** a sub-dimension table associated to `dim_boardgames` that gets data from `stg_boardgames__artists` combined with `int_boardgames__boardgames_filtered`.
- **dim_categories:** a sub-dimension table associated to `dim_boardgames` that gets data from `stg_boardgames__categories` combined with `int_boardgames__boardgames_filtered`.
- **dim_designers:** a sub-dimension table associated to `dim_boardgames` that gets data from `stg_boardgames__designers` combined with `int_boardgames__boardgames_filtered`.
- **dim_mechanics:** a sub-dimension table associated to `dim_boardgames` that gets data from `stg_boardgames__mechanics` combined with `int_boardgames__boardgames_filtered`.
- **dim_publishers:** a sub-dimension table associated to `dim_boardgames` that gets data from `stg_boardgames__publishers` combined with `int_boardgames__boardgames_filtered`.
- **dim_rankings:** a sub-dimension table associated to `dim_boardgames` that gets data from `stg_boardgames__rankings` combined with `int_boardgames__boardgames_filtered`.

All these models should be materialized as tables.
**Hint:** You can use a `tag` to accomplish that. You can check the [previous challenge](../16_add_tags/16_add_tags.md) as a reminder. 

### Surrogate Keys
A surrogate key in a database is a unique identifier for each entity in the database. The surrogate key is not derived from application data, unlike a natural (or business) key.

To create the surrogate key for each table we're going to use the `dbt_utils` package.

To do that, we need to create a `packages.yml` file on the main folder (next to `dbt_project.yml` file), with the following:

```yaml
packages:
  - package: dbt-labs/dbt_utils
    version: 1.1.1
```

Check the latest version available [here](https://hub.getdbt.com/dbt-labs/dbt_utils/latest/).

Click [here](https://github.com/dbt-labs/dbt-utils) to check other macros that are available from `dbt_utils` package. It has a lot of useful features available.

Run `dbt deps` to install the package.

To generate the surrogate key, we use a dbt macro that is provided by the `dbt_utils` package called `generate_surrogate_key()`. The generate surrogate key macro uses the appropriate hashing function from your database to generate a surrogate key from a list of key columns (e.g. md5(), hash()). Read more about the [generate_surrogate_key](https://docs.getdbt.com/blog/sql-surrogate-keys) macro.

See the example below, on how to use it:

```sql
{{ dbt_utils.generate_surrogate_key(['field_a', 'field_b'[,...]]) }}
```

### Add Tests to Models
Define the following generic out-of-the-box tests whenever applies:
- unique
- relationships
  - Customize the data test name to something more *user friendly*. Check this [previous challenge](../13_customize_data_test_name/13_customize_data_test_name.md) to refresh your mind on how to do it.


### Change materialization of dim_rankings to incremental
Incremental models are built as tables in your data warehouse. The first time a model is run, the table is built by transforming all rows of source data. On subsequent runs, dbt transforms only the rows in your source data that you tell dbt to filter for, inserting them into the target table which is the table that has already been built.

#### Using incremental materializations
To use incremental models you need to:
- Define a config block with `materialized='incremental'`
- Tell dbt how to filter the rows on an incremental run
- The unique key of the model (if any)

To tell dbt which rows it should transform on an incremental run, wrap valid SQL that filters for these rows in the `is_incremental()` macro.

For example, a model that includes a computationally slow transformation on a column can be built incrementally, as follows:

```sql
{{
    config(
        materialized='incremental'
    )
}}

select
    *,
    my_slow_function(my_column)

from raw_app_data.events

{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  -- (uses > to include records whose timestamp occurred since the last run of this model)
  where event_time > (select max(event_time) from {{ this }})

{% endif %}
```

You can check [dbt docs](https://docs.getdbt.com/docs/build/incremental-models) for more details about incremental models.

---

### Solution

- [fct_reviews.sql](./core/fct_reviews.sql)
- [dim_users.sql](./core/dim_users.sql)
- [dim_artists.sql](./core/dim_artists.sql)
- [dim_boardgames.sql](./core/dim_boardgames.sql)
- [dim_categories.sql](./core/dim_categories.sql)
- [dim_designers.sql](./core/dim_designers.sql)
- [dim_mechanics.sql](./core/dim_mechanics.sql)
- [dim_publishers.sql](./core/dim_publishers.sql)
- [dim_rankings.sql - materialized='table'](./core/dim_rankings.sql)
- [dim_rankings.sql - materialized='incremental'](./core/dim_rankings_incremental.sql)
- [_core__models.yml](./core/_core__models.yml)
- [dbt_project.yml](dbt_project.yml)
- [packages.yml](./packages.yml)

---

[Return to Project Challenges](../../../README.md#9-project-challenges)