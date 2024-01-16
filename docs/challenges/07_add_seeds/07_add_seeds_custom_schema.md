# Exercise:

## Custom Schemas
By default, all dbt models are built in the schema specified in your target. In dbt projects with lots of models, it may be useful to instead build some models in schemas other than your target schema – this can help logically group models together.

For example, you may wish to:

- Group models based on the business unit using the model, creating schemas such as `core`, `marketing` or `finance`
- Hide intermediate models in a staging schema, and only present models that should be queried by an end user in an analytics schema.

You can use custom schemas in dbt to build models in a schema other than your target schema. It's important to note that by default, dbt will generate the schema name for a model by concatenating the custom schema to the target schema, as in: `<target_schema>_<custom_schema>`

Below are a couple of examples:

|  Target schema  |  Custom schema  |         Resulting schema        |
|:---------------:|:---------------:|:-------------------------------:|
| <target_schema> | None            | <target_schema>                 |
| analytics       | None            | analytics                       |
| dbt_alice       | None            | dbt_alice                       |
| <target_schema> | <custom_schema> | <target_schema>_<custom_schema> |
| analytics       | marketing       | analytics_marketing             |
| dbt_alice       | marketing       | dbt_alice_marketing             |

### How do I use custom schemas?

Use the `schema` configuration key to specify a custom schema for a model. As with any configuration, you can use one of the following options:

1. Apply this configuration to a specific model by using a config block within a model

```sql
-- orders.sql
{{ config(schema='marketing') }}

select ...
```

2. Apply it to a subdirectory of models by specifying it in your `dbt_project.yml` file
```yaml
# dbt_project.yml
# models in `models/marketing/ will be rendered to the "*_marketing" schema
models:
  my_project:
    marketing:
      +schema: marketing
```

### Understanding custom schemas
When first using custom schemas, it's common to assume that a model will be built in a schema that matches the `schema` configuration exactly, for example, a model that has the configuration `schema: marketing`, would be built in the marketing schema. However, dbt instead creates it in a schema like `<target_schema>_marketing` by default – there's a good reason for this!

In a typical setup of dbt, each dbt user will use a separate target schema. If dbt created models in a schema that matches a model's custom schema exactly, every dbt user would create models in the same schema.

Further, the schema that your development models are built in would be the same schema that your production models are built in! Instead, concatenating the custom schema to the target schema helps create distinct schema names, reducing naming conflicts.

### How dbt generate a model's schema name?
For that dbt uses a feature called `Macros` that use `Jinja` (templating language) to define pieces of code that can be reused multiple times - it is the equivalent to "functions" in other programming languages.

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

You can check [dbt docs](https://docs.getdbt.com/docs/build/custom-schemas) for more details about custom schemas.

## Task: Use a custom schema for seeds

The goal is to define a custom schema for `seeds` tables.

Like explained above, we want to define a custom schema for `seeds` because we want to store the data on a specific schema that is available for every developer to use, instead of creating `seeds` models on each developer schema.  

To customize schema name generation, we can define our own macro named `generate_schema_name` in our project and in that case dbt will always use the macro in our dbt project instead of the default macro.

You can use the code above as a baseline to achieve our goal.

**Hint:** To achieve this you can adjust the `if / else` statement for `custom_schema_name` to accomplish the schema name that we want. You can also add a `Jinja` property called `upper` to force the schema name to uppercase.

An alternative way of doing this is using the `node.resource_type` property and checking if is a `seed`.

Don't forget that we also have to add to `dbt_project.yml` the `schema` config property with the custom schema name that we want, like the following:
``` yaml
# dbt_project.yml

seeds:
  dbt_capstone_project:
      +schema: seeds
```

You can test this by running `dbt seed`.

**Note:** When you reach this challenge you'll probably realize there is already a schema named `SEEDS` on Snowflake environment. Feel free to overwrite the tables from this schema because it is static data that have the same output, so there is no impact on the course.

---

### Solution
- [generate_schema_name_1.sql](./macros/generate_schema_name_1.sql)
- [generate_schema_name_2.sql](./macros/generate_schema_name_2.sql)
- [dbt_project.yml](./dbt_project_custom_schema.yml)


---

[Return to Project Challenges](../../../README.md#9-project-challenges)