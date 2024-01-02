# Exercise:

## Task: Use a custom schema for seeds

The goal is to define a custom schema for `seeds` tables.
For that we're going to use a feature of dbt called `Macros` that use `Jinja` (templating language) to define pieces of code that can be reused multiple times - it is the equivalent to "functions" in other programming languages.

Macros are defined in `.sql` files, tipycally in your `macros` directory.

dbt uses a default macro called `generate_schema_name` to determine the name of the schema that a model should be built in.

Here is the default macro's code:

```sql
{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set default_schema = target.schema -%}
    {%- if custom_schema_name is none -%}

        {{ default_schema }}

    {%- else -%}

        {{ default_schema }}_{{ custom_schema_name | trim }}

    {%- endif -%}

{%- endmacro %}
```

To customize schema name generation, we can define our own macro named `generate_schema_name` in our project and in that case dbt will always use the macro in our dbt project instead of the default macro.

You can use the code above as a baseline to achieve our goal.

Don't forget that we also have to add to `dbt_project.yml` the `schema` config property with the custom schema name that we want, like the following:
``` yaml
# dbt_project.yml

seeds:
  dbt_capstone_project:
      +schema: seeds
```

You can check [dbt docs](https://docs.getdbt.com/docs/build/custom-schemas) for more details about custom schemas.

---

### Solution
[generate_schema_name.sql](./macros/generate_schema_name.sql)
[dbt_project.yml](./dbt_project_custom_schema.yml)


---

[Return to Project Challenges](../../../README.md#9-project-challenges)