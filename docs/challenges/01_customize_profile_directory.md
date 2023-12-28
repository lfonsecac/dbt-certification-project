# Exercise:

## Customizing a profile directory

The parent directory for profiles.yml is determined using the following precedence:

1. --profiles-dir option
2. DBT_PROFILES_DIR environment variable
3. current working directory
4. ~/.dbt/ directory

To check the expected location of your profiles.yml file for your installation of dbt, you can run the following command:

 ``` bash
$ dbt debug --config-dir
To view your profiles.yml file, run:

open /Users/alice/.dbt
```

If you've already renamed the `sample-profiles.yml` to `profiles.yml` stored on the root directory of dbt project, the command above should return that path instead, following the precedence mentioned above.

Other way to achieve the same output is to use the `DBT_PROFILES_DIR` environment variable to change the default location by running this commmand: 

 ``` bash
export DBT_PROFILES_DIR=path/to/directory
```

Execute again this command to confirm the `profiles.yml` location:
 ``` bash
$ dbt debug --config-dir
```