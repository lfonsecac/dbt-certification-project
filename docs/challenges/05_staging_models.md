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

### Materialization
Update your `dbt_project.yml` adding a configuration for the entire staging directory to be materialized as view.

``` yaml
# dbt_project.yml

models:
  dbt_capstone_project:
    staging:
      +materialized: view
```