# Exercise:

## Add generic test

### Generic data tests
Certain data tests are generic: they can be reused over and over again. A generic data test is defined in a `test` block, which contains a parametrized query and accepts arguments. It might look like:

```sql
{% test not_null(model, column_name) %}

    select *
    from {{ model }}
    where {{ column_name }} is null

{% endtest %}
```

You'll notice that there are two arguments, model and column_name, which are then templated into the query. This is what makes the test "generic": it can be defined on as many columns as you like, across as many models as you like, and dbt will pass the values of model and column_name accordingly. Once that generic test has been defined, it can be added as a property on any existing model (or source, seed, or snapshot). These properties are added in .yml files in the same directory as your resource.

Out of the box, dbt ships with four generic data tests already defined: `unique`, `not_null`, `accepted_values` and `relationships`. Here's a full example using those tests on an orders model:

``` yaml
version: 2

models:
  - name: orders
    columns:
      - name: order_id
        tests:
          - unique
          - not_null
      - name: status
        tests:
          - accepted_values:
              values: ['placed', 'shipped', 'completed', 'returned']
      - name: customer_id
        tests:
          - relationships:
              to: ref('customers')
              field: id
```

To check the test, we have to run the following command:

```bash
# Run tests on all models
dbt test

# Run tests on a specific model
dbt test -s stg_boardgames__reviews

# Run all generic tests (be aware that this will run also the out-of-the-box generic tests - unique, not_null, accepted_values, relationships)
dbt test -s "test_type:generic"

# Run tests on all models with a particular materialization (staging models)
dbt test -s "config.materialized:view"
```

You can check [dbt docs](https://docs.getdbt.com/docs/build/data-tests#generic-data-tests) for more details about generic data tests.

### Task: Add generic test to check for values between 1 and 10

**Reminder:** The test should only return values if the assumption made is not valid. Therefore, the test must  check the opposite (in this scenario for values that are **not** between 1 and 10.)

This test can be applied to the following models and respective columns:
- stg_boardgames__reviews
  - review_rating
- stg_boardgames__rankings
  - boardgame_avg_rating
  - boardgame_bayes_avg_rating
- stg_boardgames__boardgames
  - boardgame_avg_rating

#### Additional Notes

When you run the test you should get an error similar to the one below:

```
bash
❯ dbt test -s stg_boardgames__reviews
09:42:19  Running with dbt=1.7.4
09:42:20  Registered adapter: snowflake=1.7.1
09:42:20  Found 11 models, 1 snapshot, 48 tests, 2 seeds, 9 sources, 0 exposures, 0 metrics, 432 macros, 0 groups, 0 semantic models
09:42:20  
09:42:26  Concurrency: 1 threads (target='dev')
09:42:26  
09:42:26  1 of 1 START test accepted_values_between_1_10_stg_boardgames__reviews_review_rating  [RUN]
09:42:29  1 of 1 FAIL 15 accepted_values_between_1_10_stg_boardgames__reviews_review_rating  [FAIL 15 in 2.90s]
09:42:29  
09:42:29  Finished running 1 test in 0 hours 0 minutes and 9.08 seconds (9.08s).
09:42:29  
09:42:29  Completed with 1 error and 0 warnings:
09:42:29  
09:42:29  Failure in test accepted_values_between_1_10_stg_boardgames__reviews_review_rating (models/staging/_boardgames__models.yml)
09:42:29    Got 15 results, configured to fail if != 0
09:42:29  
09:42:29    compiled Code at target/compiled/dbt_capstone_project/models/staging/_boardgames__models.yml/accepted_values_between_1_10_s_48826f9196962245728d8371e7b50e24.sql
09:42:29  
09:42:29  Done. PASS=0 WARN=0 ERROR=1 SKIP=0 TOTAL=1
```

That means that we've 15 records that don't meet our criteria.
To further analyze that, we should look for the compile code mentioned on the error message above and run the sql on Snowflake to check the results.

Here is a snippet of the compiled code:

```sql
with validation as (
    select
        review_rating as accepted_values_between_1_10
    from BOARDGAME.dbt_fbalseiro.stg_boardgames__reviews
),

validation_errors as (
    select
        accepted_values_between_1_10
    from validation
    where accepted_values_between_1_10 not between 1 and 10
)

select *
from validation_errors
```

We have 15 records with values below 1.
That is not supposed to happen, because ratings should be between 1 and 10.

So, we can have 2 possible approaches:
1. ignore these records, filtering them out as part of our transformations
2. consider these values as a rating = 1

I suggest that we proceed with the 2nd approach so the solutions follow that,  but feel free to choose whatever option you feel is the more adequate. 
Remember, this is your project!

We'll cover that on the 2nd part of this challenge, because before I want to introduce another concept of configuring test `severity`, and we're going to use this situation for that.

---

### Solution
- [accepted_values_between_1_10.sql](./macros/accepted_values_between_1_10.sql)
- [_boardgames__models.yml](./_boardgames__models.yml)

---

[Return to Project Challenges](../../../README.md#9-project-challenges)