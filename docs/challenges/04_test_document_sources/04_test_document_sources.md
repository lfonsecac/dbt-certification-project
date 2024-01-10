# Exercise:

## Testing and documenting sources

Now that you've already created your `_boardgames__sources.yml` file, now it's time to define tests and add descriptions, like the example below.

``` yaml
version: 2

sources:
  - name: jaffle_shop
    description: This is a replica of the Postgres database used by our app
    tables:
      - name: orders
        description: >
          One record per order. Includes cancelled and deleted orders.
        columns:
          - name: id
            description: Primary key of the orders table
            tests:
              - unique
              - not_null
          - name: status
            description: Note that the status can change over time

      - name: ...

  - name: ...
```

- Use the [Data Dictionary](https://docs.google.com/spreadsheets/d/1W3oXg2I52cy2oLPJQz7Ah4a8TQGju9yByI57JWWFbEc/edit?usp=drive_link) to create the generic tests to validate the assumptions specified on the document (ex: unique, not_null, accepted_values)


### Run tests
To run tests on all sources, use the following command:
```bash
dbt test --select "source:*"
``` 
**Note:** You can also use the `-s` shorthand here instead of `--select`

To run tests on one source (and all of its tables):
```bash
dbt test --select source:boardgame
``` 

To run tests on one source (and all of its tables):
```bash
dbt test --select source:boardgame.reviews
``` 

To find out more information about `tests` clik [here](https://docs.getdbt.com/docs/build/data-tests) to access dbt documentation for more details.

To find out more information about `description` clik [here](https://docs.getdbt.com/reference/resource-properties/description) to access dbt documentation for more details.

#### Issues that may occur
**Note:** For some of the columns from the `Rankings` we have to activate a property called `quote` to enable quoting for those column names. That happens either because we are using reserved SQL expression names (like `rank`) or column names with spaces so it has to be quoted so Snowflake can interpret the expressions as a column name correctly.   
You can find more information here: [dbt docs.](https://docs.getdbt.com/reference/resource-properties/quote)

When you are running the tests if you get an error like the one below `invalid identifier 'NAME'`, is likely to be a problem on column name syntax that is being interpreted by Snowflake.

```bash
12:54:37    Database Error in test source_not_null_boardgame_rankings_Name (models/staging/_boardgames__sources.yml)
  000904 (42000): SQL compilation error: error line 12 at position 7
  invalid identifier 'NAME'
  compiled Code at target/run/dbt_capstone_project/models/staging/_boardgames__sources.yml/source_not_null_boardgame_rankings_Name.sql
12:54:37  
12:54:37  Done. PASS=10 WARN=0 ERROR=1 SKIP=0 TOTAL=11
```

It is a best practice to validate the compiled code mentioned on the error message above to dig deeper into the issue.
Here is the compile code below, and you can try to copy and paste that into Snowsight and check if you get the same error and figure out a way to solve the issue.

```sql
select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
select Name
from boardgame.raw.rankings
where Name is null

    ) dbt_internal_test
```

---

### Solution
- [_boardgames__sources.yml](./staging/_boardgames__sources.yml)

---

[Return to Project Challenges](../../../README.md#9-project-challenges)