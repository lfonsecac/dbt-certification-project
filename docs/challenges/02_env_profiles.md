# Exercise:

## Update credentials from profiles.yml to environment variables

To complete this exercise you should perform the following steps:

- Open the profiles.yml file on the root folder of your dbt project
- Change the properties `password` and `user` to this:

 ``` yaml
password: "{{ env_var('DBT_PASSWORD') }}"
user: "{{ env_var('DBT_USER') }}"
```

- Execute the following commands on your terminal to update the environment variables on your operating system:
 ``` bash
export DBT_PASSWORD=<password>
export DBT_USER=<user>
```

- Execute the command `dbt debug` to check if dbt can commmunicate properly with the data platform (Snowflake)

### Alternative approach: use `.env`
Other approach that is used on projects on USFoods is to define the environment variables inside a `.env` file on the root folder of your dbt project.

- Rename the `sample-env` file to `.env`
- Execute the command on your terminal
 ``` bash
source .env
```
- Execute the command `dbt debug` to check if dbt can commmunicate properly with the data platform (Snowflake)

---
**Note:** In both scenarios you will have to execute the respective command every time you login again on your development environment.