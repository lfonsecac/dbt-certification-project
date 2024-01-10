# Exercise:

## Macros

We've already defined a macro on the previous [challenge 07](../07_add_seeds/07_add_seeds_custom_schema.md): add seeds with custom schema name.

Macros can be a very useful feature to use on your dbt project, and I want to show additional `macros` to get a better understanding on how we can get value from it.  


You can check [dbt docs](https://docs.getdbt.com/docs/build/jinja-macros#macros) for more details about macros.

## Task: Use a macro to implement a SQL script with multiple CTEs

Credits to the macro creators. [(source)](https://gitlab.com/gitlab-data/analytics/-/blob/master/transform/snowflake-dbt/macros/utils/simple_cte.sql)

### Steps to reproduce it:

#### 1) Plese make sure that inside dbt_project.yml
the macro path points to "macros":
>> macro-paths: ["macros"]

#### 2) Copy/Move [simple_cte.sql](simple_cte.sql) to the macros 
folder in your dbt project folder 

#### 3) This macro emulates programming languages
Importing modules. Basically dbt wants to convert a sql code into a programming language code as closely as possible. So, this macro "imports" by `select * from <table>` all "dependencies"

#### 4) Create a example.sql file on intermediate folder to combine the models stg_boardgames__reviews and stg_boardgames__users
as the first block of code in your models/<...>/<your_model>.sql
call the macro:

```sql
{{ 
    simple_cte(
        [
            ('my_alias_for_model1', 'model1'),
            ('my_alias_for_model2', 'model2')
        ]
    )

}} 
select 
    *
from my_alias_for_model1
join my_alias_for_model2
    on my_alias_for_model1.key = my_alias_for_model2.key
```

#### 5) Finally, before running `dbt run/build --select <example.sql>`
run `dbt compile --select <example.sql>` and take a look at the output

The compile code should look something like this:

```bash
11:04:09  Compiled node 'example' is:


WITH reviews AS (

    SELECT * 
    FROM BOARDGAME.dbt_fbalseiro.stg_boardgames__reviews

), users AS (

    SELECT * 
    FROM BOARDGAME.dbt_fbalseiro.stg_boardgames__users

) 
select 
    *
from reviews
join users
    on reviews.review_username = users.user_username
```

**Note:** When you run or build the model it won't be materialized on the Snowflake datawarehouse because as you may remember we defined on `dbt_project.yml` that intermediate models are materialized as `ephemeral`.
If you want to change that, you can add a config block at the beginning of `example.sql` model.

---

### Solution

- [simple_cte.sql](simple_cte.sql)
- [example.sql](example.sql)
- [_int__models.yml](_int__models.yml)

---

[Return to Project Challenges](../../../README.md#9-project-challenges)