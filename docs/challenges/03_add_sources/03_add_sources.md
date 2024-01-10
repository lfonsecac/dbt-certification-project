# Exercise:

## Add sources to your DAG

### Declaring a source
Sources are defined in `.yml` files nested under a `sources: ` key.

``` yaml
version: 2

sources:
  - name: jaffle_shop
    database: raw  
    schema: jaffle_shop  
    tables:
      - name: orders
      - name: customers

  - name: stripe
    tables:
      - name: payments
```

- By default, schema will be the same as name. Add schema only if you want to use a source name that differs from the existing schema.

If you're not already familiar with these files, be sure to check out the [documentation on schema.yml files](https://docs.getdbt.com/reference/configs-and-properties) before proceeding.


Using the example above you should create the sources file following the [style guide](/docs/style_guide.md).

To find out more information about `sources` clik [here](https://docs.getdbt.com/docs/build/sources) to access dbt documentation for more details.

---

### Solution
- [_boardgames__sources.yml](./staging/_boardgames__sources.yml)

---

[Return to Project Challenges](../../../README.md#9-project-challenges)

