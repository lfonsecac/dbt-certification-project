# Exercise:

## Add Tags

### Definition
Apply a tag (or list of tags) to a resource.

These tags can be used as part of the [resource selection syntax](https://docs.getdbt.com/reference/node-selection/syntax), when running the following commands:
```bash
dbt run --select tag:my_tag
dbt seed --select tag:my_tag
dbt snapshot --select tag:my_tag

# (indirectly runs all tests associated with the models that are tagged)
dbt test --select tag:my_tag
```

### Examples

Apply tags in your `dbt_project.yml` as a single value or a string:

```yaml
models:
  jaffle_shop:
    +tags: "contains_pii"

    staging:
      +tags:
        - "hourly"

    marts:
      +tags:
        - "hourly"
        - "published"

    metrics:
      +tags:
        - "daily"
        - "published"
```

You can also apply tags to individual resources using a config block:
```sql
{{ config(
    tags=["finance"]
) }}

select ...
```

Then, run part of your project like this:

```bash
# Run all models tagged "daily"
$ dbt run --select tag:daily

# Run all models tagged "daily", except those that are tagged hourly
$ dbt run --select tag:daily --exclude tag:hourly
```


### Usage Notes

**Important Note:** Tags are additive. They accumulate hierarchically.
The above example of `dbt_project.yml` would result in:

|               Model              |               Tags              |
|:--------------------------------:|:-------------------------------:|
| models/staging/stg_customers.sql | contains_pii, hourly            |
| models/staging/stg_payments.sql  | contains_pii, hourly, finance   |
| models/marts/dim_customers.sql   | contains_pii, hourly, published |
| models/metrics/daily_metrics.sql | contains_pii, daily, published  |

You can check [dbt docs](https://docs.getdbt.com/reference/resource-configs/tags) for more details about tags.


## Task: Add tags to your project
We're going to apply these tags to the following models:

- `staging`: to all staging models
- `seed`: to all seeds
- `daily`: to the model `stg_boardgames__rankings` and snapshot `rankings`, because these models are updated on a daily basis.
- `static`: to all staging models
- `intermediate`: to all intermediate models

Test them out by running the appropriate `dbt run -s tag:<name_of_tag>`.

Did you notice any problem on applying those tags?

As we've mentioned earlier, tags are additive, which means that model `stg_boardgames__rankings` gets both `static` and `daily` tags.
That was not our goal, and by using tags we have to use the `--exclude` flag to only run the `static` models and not the `daily` models.

To achieve our goal, we need to use another concept called `selectors` that support more complex selection criteria.

### YAML Selectors

Write resource selectors in YAML, save them with a human-friendly name, and reference them using the `--selector` flag. 

Selectors live in a top-level file named `selectors.yml`. Each must have a `name` and a `definition`, and can optionally define a `description` and `default` flag.

```yaml
selectors:
  - name: nodes_to_joy
    definition: ...
  - name: nodes_to_a_grecian_urn
    description: Attic shape with a fair attitude
    default: true
    definition: ...
```

#### Definitions
Each definition is comprised of one or more arguments, which can be one of the following:

- `CLI-style`: strings, representing CLI-style arguments
- `Key-value`: pairs in the form method: value
- `Full YAML`: fully specified dictionaries with items for method, value, operator-equivalent keywords, and support for `exclude`

Use the `union` and `intersection` operator-equivalent keywords to organize multiple arguments.

##### CLI-style
```yaml
definition:
  'tag:nightly'
```

**Note:** When using the `CLI-style` (strings) don't leave any whitespaces on the value between the quotes (`''`). 
❌ `'tag: nightly'` 
✅ `'tag:nightly'`

##### Key-value
```yaml
definition:
  tag: nightly
```

##### Full YAML
```yaml
definition:
  method: tag
  value: nightly

  # Optional keywords map to the `+` and `@` graph operators:

  children: true | false
  parents: true | false

  children_depth: 1    # if children: true, degrees to include
  parents_depth: 1     # if parents: true, degrees to include

  childrens_parents: true | false     # @ operator

  indirect_selection: eager | cautious | buildable | empty # include all tests selected indirectly? eager by default
```

##### Exclude

The `exclude` keyword is only supported by fully-qualified dictionaries. It may be passed as an argument to each dictionary, or as an item in a `union`. The following are equivalent:

```yaml
- method: tag
  value: nightly
  exclude:
    - "tag:daily"
```

```yaml
- union:
    - method: tag
      value: nightly
    - exclude:
       - method: tag
         value: daily
```


To run a job using the `selector`:

```bash
dbt run --selector <name_of_selector>
```

You can check [dbt docs](https://docs.getdbt.com/reference/node-selection/yaml-selectors) for more details about selectors.

## Task: Add `selectors.yml` to your project

To solve the issue on the previous task about `static` and `daily` tags you're going to create a `selectors.yml` file on the root folder of your dbt project with this selector:

- name: static_staging_models
- description: "Staging models with static data, not being updated."
- definition: select models with `tag:static` and exclude `tag:daily`

Try to use these 4 different approaches to achieve the desired result:
- Use `union` operator and `CLI-style` definition
- Use `union` operator and `Key-value` definition
- Use `union` operator and `Full YAML` definition
- Use `Full YAML` definition without `union`

Try it out by running `dbt run --selector static_staging_models`.

---

### Solution

- [dbt_project.yml](dbt_project.yml)
- [boardgames__rankings.sql](./snapshots/boardgames__rankings.sql)
- [stg_boardgames__rankings.sql](./staging/stg_boardgames__rankings.sql)
- `CLI-style` definition: [selectors.yml](./selectors_cli_style/selectors.yml)
- `Key-value` definition: [selectors.yml](./selectors_key_value/selectors.yml)
- `Full YAML` definition using `union`: [selectors.yml](./selectors_union_full_yaml/selectors.yml)
- `Full YAML` definition without `union`: [selectors.yml](./selectors_full_yaml/selectors.yml)

---

[Return to Project Challenges](../../../README.md#9-project-challenges)