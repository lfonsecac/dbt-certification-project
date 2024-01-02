# Exercise:

## Add source freshness

### Definition 
A freshness block is used to define the acceptable amount of time between the most recent record, and now, for a table to be considered "fresh".

In the `freshness` block, one or both of `warn_after` and `error_after` can be provided. If neither is provided, then dbt will not calculate freshness snapshots for the tables in this source.

Additionally, the `loaded_at_field` is required to calculate freshness for a table. If a loaded_at_field is not provided, then dbt will not calculate freshness for the table.

There is a complete example below

``` yaml

version: 2

sources:
  - name: jaffle_shop
    database: raw

    freshness: # default freshness
      warn_after: {count: 12, period: hour}
      error_after: {count: 24, period: hour}

    loaded_at_field: _etl_loaded_at

    tables:
      - name: customers # this will use the freshness defined above

      - name: orders
        freshness: # make this a little more strict
          warn_after: {count: 6, period: hour}
          error_after: {count: 12, period: hour}
          # Apply a where clause in the freshness query
          filter: datediff('day', _etl_loaded_at, current_timestamp) < 2


      - name: product_skus
        freshness: # do not check freshness for this table
```

To check freshness, have to run the following command:

```bash
dbt source freshness
```

You can check [dbt docs](https://docs.getdbt.com/reference/resource-properties/freshness) for more details.

### Task: Add source freshness config to sources.yml file

From the raw dataset on Snowflake, the only table that is updated daily is the `rankings` table. We want to make sure that we check for freshness for that table only, with the following properties:
- **warn_after:** 24 hours
- **error_after:** 48 hours

#### Troubleshooting
The `loaded_at_field` property from freshness config accepts a column name (or expressiohn) that returns a timestamp indicating freshness.
We have the same issue with `quoting` as happened before on adding tests and documentation to sources with some columns, like `updated_at` field from `rankings` table.

In this situation, the `quote` property is not available so we have to use the `" "` directly on the `loaded_at_field` value.

---

### Solution
[_boardgames__sources.yml](./_boardgames__sources.yml)

---

[Return to Project Challenges](../../../README.md#9-project-challenges)