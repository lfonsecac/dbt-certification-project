# Exercise:

## Configure test severity

### Overview
Tests return a number of failures—most often, this is the count of rows returned by the test query, but it could be a custom calculation. Generally, if the number of failures is nonzero, the test returns an error. This makes sense, as test queries are designed to return all the rows you don't want: duplicate records, null values, etc.

It's possible to configure tests to return warnings instead of errors, or to make the test status conditional on the number of failures returned. Maybe 1 duplicate record can count as a warning, but 10 duplicate records should count as an error.

The relevant configs are:

`severity`: error or warn (default: error)
`error_if`: conditional expression (default: !=0)
`warn_if`: conditional expression (default: !=0)

Conditional expressions can be any comparison logic that is supported by your SQL syntax with an integer number of failures: > 5, = 0, between 5 and 10, and so on.

Here is an example below applied to a out-of-the-box generic test:

```yaml
version: 2

models:
  - name: large_table
    columns:
      - name: slightly_unreliable_column
        tests:
          - unique:
              config:
                severity: error
                error_if: ">1000"
                warn_if: ">10"
```

You'll notice that there are two arguments, model and column_name, which are then templated into the query. This is what makes the test "generic": it can be defined on as many columns as you like, across as many models as you like, and dbt will pass the values of model and column_name accordingly. Once that generic test has been defined, it can be added as a property on any existing model (or source, seed, or snapshot). These properties are added in .yml files in the same directory as your resource.

You can check [dbt docs](https://docs.getdbt.com/reference/resource-configs/severity) for more details about configuring test `severity`.

### Task: Configure test severity

On the last challenge we had the following tests failing:
- accepted_values_between_1_10_stg_boardgames__boardgames_boardgame_avg_rating
- accepted_values_between_1_10_stg_boardgames__reviews_review_rating

You should apply the following `severity` as following:
- accepted_values_between_1_10_stg_boardgames__boardgames_boardgame_avg_rating
  - severity: warn
    - warn_if: ">1000"
- accepted_values_between_1_10_stg_boardgames__reviews_review_rating
  - severity: error 
    - error_if: ">100"
    - warn_if: ">10"

To test you can run the following commands:
```bash
# Run all generic tests (be aware that this will run also the out-of-the-box generic tests - unique, not_null, accepted_values, relationship)
dbt test -s "test_type:generic"

# Run tests on all models with a particular materialization (staging models)
dbt test -s "config.materialized:view"

# Run only the specific mdodels
dbt test -s stg_boardgames__reviews stg_boardgames__boardgames
```

You should get the following 2 warnings:

```bash
11:55:59  Completed with 2 warnings:
11:55:59  
11:55:59  Warning in test accepted_values_between_1_10_stg_boardgames__boardgames_boardgame_avg_rating (models/staging/_boardgames__models.yml)
11:55:59  Got 192183 results, configured to warn if >1000
11:55:59  
11:55:59    compiled Code at target/compiled/dbt_capstone_project/models/staging/_boardgames__models.yml/accepted_values_between_1_10_s_2282009463fe1d036ce83e31b719344b.sql
11:55:59  
11:55:59  Warning in test accepted_values_between_1_10_stg_boardgames__reviews_review_rating (models/staging/_boardgames__models.yml)
11:55:59  Got 15 results, configured to warn if >10
11:55:59  
11:55:59    compiled Code at target/compiled/dbt_capstone_project/models/staging/_boardgames__models.yml/accepted_values_between_1_10_s_48826f9196962245728d8371e7b50e24.sql
```
---

### Solution
- [_boardgames__models.yml](./_boardgames__models.yml)

---

[Return to Project Challenges](../../../README.md#9-project-challenges)
