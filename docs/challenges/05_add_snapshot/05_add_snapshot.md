# Exercise:

## Create snapshot table
Snapshots implement [type-2 Slowly Changing Dimensions](https://en.wikipedia.org/wiki/Slowly_changing_dimension#Type_2:_add_new_row) over mutable source tables. These Slowly Changing Dimensions (or SCDs) identify how a row in a table changes over time. In our use case we have a `rankings` table where the `rank` field is overwritten daily with the updated rank value.

In dbt, snapshots are `select` statements, defined within a `snapshot` block in a .sql file (typically in your snapshots directory). You'll also need to configure your snapshot to tell dbt how to detect record changes.

``` yaml
{% snapshot orders_snapshot %}

{{
    config(
      target_database='analytics',
      target_schema='snapshots',
      unique_key='id',

      strategy='timestamp',
      updated_at='updated_at',
    )
}}

select * from {{ source('jaffle_shop', 'orders') }}

{% endsnapshot %}
```

To find out more information about `snapshots` clik [here].(https://docs.getdbt.com/docs/build/snapshots)

---

### Solution
- [boardgames__rankings.sql](./snapshots/boardgames__rankings.sql)

**Notes:** 
- There is already a `snapshot` table under `snapshots` schema that I've been maintaining to test if things are working properly.
Feel free to change the `target_schema` and add a `target_database` parameter to test by yourself.
- In the `.sql` file I had to specifically use doble quotes `""` to again select the columns from `Rankings` table for the same issue that was already mentioned on the [previous challenge](../04_test_document_sources/04_test_document_sources.md#issues-that-may-occur).


---

[Return to Project Challenges](../../../README.md#9-project-challenges)