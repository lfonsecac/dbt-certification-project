# Exercise:

## Add singular test

### Test Definition 
Data tests are assertions you make about your models and other resources in your dbt project (e.g. sources, seeds and snapshots). When you run dbt test, dbt will tell you if each test in your project passes or fails.

There are two ways of defining data tests in dbt:

- A **singular data test** is testing in its simplest form: If you can write a SQL query that returns failing rows, you can save that query in a .sql file within your test directory. It's now a data test, and it will be executed by the dbt test command.
- A **generic data test** is a parameterized query that accepts arguments. The test query is defined in a special test block (like a macro). Once defined, you can reference the generic test by name throughout your .yml files—define it on models, columns, sources, snapshots, and seeds. dbt ships with four generic data tests built in, and we think you should use them!

### Singular data tests
The simplest way to define a data test is by writing the exact SQL that will return failing records. We call these "singular" data tests, because they're one-off assertions usable for a single purpose.

Here is an example below

``` sql
-- assert_total_payment_amount_is_positive.sql
-- Refunds have a negative amount, so the total amount should always be >= 0.
-- Therefore return records where this isn't true to make the test fail
select
    order_id,
    sum(amount) as total_amount
from {{ ref('fct_payments' )}}
group by 1
having not(total_amount >= 0)
```

To check the test, we have to run the following command:

```bash
dbt test
```

You can check [dbt docs](https://docs.getdbt.com/docs/build/data-tests) for more details about data tests.

### Task: Add singular test to check if country_code has a length of 3

The `country_code` column from the `country_codes.csv` table should have a code with 3 letters. 
We want to define a test to check that assumption.

---

### Solution
- [assert_country_code_has_length_3.sql](./tests/assert_country_code_has_length_3.sql)

---

[Return to Project Challenges](../../../README.md#9-project-challenges)