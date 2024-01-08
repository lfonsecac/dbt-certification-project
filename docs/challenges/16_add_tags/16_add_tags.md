# Exercise:

## Add Tags

### Definition
Apply a tag (or list of tags) to a resource.

These tags can be used as part of the [resource selection syntax](https://docs.getdbt.com/reference/node-selection/syntax), when running the following commands:
```bash
dbt run --select tag:my_tag
dbt seed --select tag:my_tag
dbt snapshot --select tag:my_tag

# (indirectly runs all tests associated with the models that are tagged)
dbt test --select tag:my_tag
```

### Examples

Apply tags in your `dbt_project.yml` as a single value or a string:

```yaml
models:
  jaffle_shop:
    +tags: "contains_pii"

    staging:
      +tags:
        - "hourly"

    marts:
      +tags:
        - "hourly"
        - "published"

    metrics:
      +tags:
        - "daily"
        - "published"
```

You can also apply tags to individual resources using a config block:
```sql
{{ config(
    tags=["finance"]
) }}

select ...
```

Then, run part of your project like this:

```bash
# Run all models tagged "daily"
$ dbt run --select tag:daily

# Run all models tagged "daily", except those that are tagged hourly
$ dbt run --select tag:daily --exclude tag:hourly
```


### Usage Notes

**Important Note:** Tags are additive. They accumulate hierarchically.
The above example of `dbt_project.yml` would result in:

|               Model              |               Tags              |
|:--------------------------------:|:-------------------------------:|
| models/staging/stg_customers.sql | contains_pii, hourly            |
| models/staging/stg_payments.sql  | contains_pii, hourly, finance   |
| models/marts/dim_customers.sql   | contains_pii, hourly, published |
| models/metrics/daily_metrics.sql | contains_pii, daily, published  |

You can check [dbt docs](https://docs.getdbt.com/reference/resource-configs/tags) for more details about tags.


## Task: Add tags to your project
We're going to apply these tags to the following models:

- `staging`: to all staging models
- `seed`: to all seeds
- `daily`: to the model `stg_boardgames__rankings` and snapshot `rankings`
- `static`: to all the other staging models
- `intermediate`: to all intermediate models

---

### Solution

- [dbt_project.yml](dbt_project.yml)
- [boardgames__rankings.sql](./snapshots/boardgames__rankings.sql)
- [stg_boardgames__rankings.sql](./staging/stg_boardgames__rankings.sql)

---

[Return to Project Challenges](../../../README.md#9-project-challenges)