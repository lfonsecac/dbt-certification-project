# Exercise:

## Add Variables
dbt provides a mechanism, [variables](https://docs.getdbt.com/reference/dbt-jinja-functions/var), to provide data to models for compilation. Variables can be used to configure timezones, avoid hardcoding table names or otherwise provide data to models to configure how they are compiled.

To use a variable in a model, hook, or macro, use the `{{ var('...') }}` function. More information on the var function can be found [here](https://docs.getdbt.com/reference/dbt-jinja-functions/var).

Variables can be defined in two ways:

1. In the `dbt_project.yml` file
2. On the command line

### Defining variables into the `dbt_project.yml` file

```yaml
name: my_dbt_project
version: 1.0.0

config-version: 2

vars:
  # The `start_date` variable will be accessible in all resources
  start_date: '2016-06-01'

  # The `platforms` variable is only accessible to resources in the my_dbt_project project
  my_dbt_project:
    platforms: ['web', 'mobile']

  # The `app_ids` variable is only accessible to resources in the snowplow package
  snowplow:
    app_ids: ['marketing', 'app', 'landing-page']

models:
    ...
```

### Defining variables on the command line
The dbt_project.yml file is a great place to define variables that rarely change. Other types of variables, like date ranges, will change frequently. To define (or override) variables for a run of dbt, use the `--vars` command line option. In practice, this looks like:

```bash
$ dbt run --vars '{"key": "value"}'
```

### Variable precedence

The order of precedence for variable declaration is as follows (highest priority first):

1. The variables defined on the command line with --vars.
1. The package-scoped variable declaration in the root dbt_project.yml file
1. The global variable declaration in the root dbt_project.yml file
1. If this node is defined in a package: variable declarations in that package's dbt_project.yml file
1. The variable's default argument (if one is provided)

If dbt is unable to find a definition for a variable after checking these four places, then a compilation error will be raised.

It's important to be aware of this for the exam.

You can check [dbt docs](https://docs.getdbt.com/docs/build/project-variables) for more details about project variables.

## Task: Add variables to your `dbt_project.yml`
We're going to add the following variables to `dbt_project.yml` in order to prevent repetition and minimize hardcoding throughout the project:

- Add an `unknown` variable with the value `Unknown` and update it on the respective models
- Add a `boardgame_type` variable with the value `boardgame` and update it on the respective models
- Add a `number_unknown` variable with value `-1` and update it on the respective models
- Add a `min_accepted_num` variable with value `1` and update it on the respective models

---

### Solution

- [dbt_project.yml](dbt_project.yml)
- [stg_boardgames__boardgames.sql](./staging/stg_boardgames__boardgames.sql)
- [stg_boardgames__rankings.sql](./staging/stg_boardgames__rankings.sql)
- [stg_boardgames__reviews.sql](./staging/stg_boardgames__reviews.sql)
- [int_boardgames__boardgames_filtered.sql](./intermediate/int_boardgames__boardgames_filtered.sql)

---

[Return to Project Challenges](../../../README.md#9-project-challenges)