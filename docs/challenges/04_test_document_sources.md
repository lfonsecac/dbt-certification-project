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