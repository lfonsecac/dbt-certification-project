# Exercise:

## Add seeds table

### Overview 
Seeds are CSV files in your dbt project (typically in your seeds directory), that dbt can load into your data warehouse using the `dbt seed` command.

Seeds can be referenced in downstream models the same way as referencing models — by using the `ref` function.

Because these CSV files are located in your dbt repository, they are version controlled and code reviewable. Seeds are best suited to static data which changes infrequently.

**Good use-cases for seeds:**

- A list of mappings of country codes to country names
- A list of test emails to exclude from analysis
- A list of employee account IDs

**Poor use-cases of dbt seeds:**

- Loading raw data that has been exported to CSVs
- Any kind of production data containing sensitive information. For example personal identifiable information (PII) and passwords.

### Task: Create a country codes table and a reference table to translate country names from users to country codes table

In this scenario, we're going to use a list of mappings of country codes to country names using this [file](country_codes.csv).

You should copy this file to the `seed-paths` folder specified on your `dbt_project.yml` like shown below:

``` yaml
# dbt_project.yml

seed-paths: ["seeds"]
```

Like `sources` and `models`, `seeds` should also have a properties `.yml` file to test and document seeds nesting the properties under a `seeds: ` key.

dbt will infer the datatype for each column based on the data in your CSV.
We can define explicitly a datatype using the `column_types` configuration like this: 

``` yaml
# dbt_project.yml

seeds:
  dbt_capstone_project:
      +column_types:
        country_name: varchar(100)
        country_code: varchar(3)
```

To create the table on Snowflake, you have to run on of the commands below:

```bash
# Runs all the seeds on the seeds folder 
dbt seed

# Runs the seed country_codes on the seeds folder 
dbt seed --select country_codes

# Runs all models downstream of a seed named country_codes
dbt seed --select country_codes+
```

You can check [dbt docs](https://docs.getdbt.com/docs/build/seeds) for more details.

Create also a `seed` for the reference table to translate the country names on the users table to country_codes table: [csv file](./country_codes_users_ref.csv)

#### Create new staging models for seeds
To apply the same logic to the seeds tables, we should create staging models that use the `ref` function to define the lineage to the respective `seeds`. 

**Note:** dbt doesn't provide documentation regarding the best practices on naming convention and downstream lineage associated to `seeds`.
Considering that we don't have a source database with these tables, I've defined the models names following this naming structure:
`stg_<seed_table_name>.sql`.

---

### Solution
- [country_codes.csv](./country_codes.csv)
- [country_codes_users_ref](./country_codes_users_ref.csv)
- [_country_codes__properties.yml](./_country_codes__properties.yml)
- [dbt_project.yml](./dbt_project.yml)
- [_boardgames__models.yml](./staging/_boardgames__models.yml)
- [stg_country_codes.sql](./staging/stg_country_codes.sql)
- [stg_country_codes_users_ref.sql](./staging/stg_country_codes_users_ref.sql)

---

[Return to Project Challenges](../../../README.md#9-project-challenges)