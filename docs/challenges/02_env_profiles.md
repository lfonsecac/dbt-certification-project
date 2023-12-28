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