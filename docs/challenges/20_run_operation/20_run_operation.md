# Exercise:

## dbt run-operation command
The `dbt run-operation` command is used to invoke a macro.
This can be useful for macros that are not directly attached to a model, like for example a macro that gives `grant select` access to a role.

### Usage

```bash
$ dbt run-operation {macro} --args '{args}'
  {macro}        Specify the macro to invoke. dbt will call this macro
                        with the supplied arguments and then exit
  --args ARGS           Supply arguments to the macro. This dictionary will be
                        mapped to the keyword arguments defined in the
                        selected macro. This argument should be a YAML string,
                        eg. '{my_variable: my_value}'
```


You can check [dbt docs](https://docs.getdbt.com/reference/commands/run-operation) for more details about `dbt run-operation` command.

## Task: Use a macro to drop all the tables and views in your target scheama that don't exist in your project

We're going to use the model defined on the previous challenge ([example.sql](../19_add_macros/example.sql)) to test this feature.

1. Remove the `example.sql` file from the intermediate folder and the properties definition inside `_int__models.yml` file

2. Add the macro [drop_old_relations](drop_old_relations.sql) file inside the macros folder

3. Run the command `dbt run-operation drop_old_relations --args '{dry_run: True}'` to check the `DROP` commands before actually applying it.

You should get an output like this: 

```bash
❯ dbt run-operation drop_old_relations --args '{dry_run: True}'
12:26:37  Running with dbt=1.7.4
12:26:38  Registered adapter: snowflake=1.7.1
12:26:38  Found 22 models, 1 snapshot, 68 tests, 2 seeds, 9 sources, 0 exposures, 0 metrics, 548 macros, 0 groups, 0 semantic models
12:26:38  
      with models_to_drop as (
        select
          case 
            when table_type = 'BASE TABLE' then 'TABLE'
            when table_type = 'VIEW' then 'VIEW'
          end as relation_type,
          concat_ws('.', table_catalog, table_schema, table_name) as relation_name
        from 
          BOARDGAME.information_schema.tables
        where table_schema ilike 'dbt_fbalseiro%'
          and table_name not in
            ('STG_BOARDGAMES__RANKINGS',
                'STG_BOARDGAMES__ARTISTS',
                'STG_COUNTRY_CODES_USERS_REF',
                'STG_BOARDGAMES__PUBLISHERS',
                'STG_BOARDGAMES__BOARDGAMES',
                'STG_COUNTRY_CODES',
                'STG_BOARDGAMES__CATEGORIES',
                'STG_BOARDGAMES__MECHANICS',
                'STG_BOARDGAMES__DESIGNERS',
                'STG_BOARDGAMES__REVIEWS',
                'STG_BOARDGAMES__USERS',
                'DIM_PUBLISHERS',
                'DIM_MECHANICS',
                'DIM_DESIGNERS',
                'DIM_USERS',
                'DIM_BOARDGAMES',
                'DIM_ARTISTS',
                'DIM_CATEGORIES',
                'INT_BOARDGAMES__BOARDGAMES_FILTERED',
                'INT_USERS_COUNTRIES_JOINED',
                'RANKINGS',
                'COUNTRY_CODES_USERS_REF',
                'COUNTRY_CODES',
                'DIM_RANKINGS',
                'FCT_REVIEWS'))
      select 
        'drop ' || relation_type || ' ' || relation_name || ';' as drop_commands
      from 
        models_to_drop
      
      -- intentionally exclude unhandled table_types, including 'external table`
      where drop_commands is not null
  
12:26:41  drop VIEW BOARDGAME.DBT_FBALSEIRO.EXAMPLE;
```

As you can check above, the `example` view has been identified to be included on the `drop` command.

4. Run the command `dbt run-operation drop_old_relations` to execute the operation.

5. Check if the view has been removed from Snowflake.

---

### Solution

- [drop_old_relations.sql](drop_old_relations.sql)

---

[Return to Project Challenges](../../../README.md#9-project-challenges)