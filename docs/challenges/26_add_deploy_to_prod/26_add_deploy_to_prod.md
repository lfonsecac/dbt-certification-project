# Exercise:

## Add Deploy to Production Workflow (Post-Merge)

In this challenge, we're using a workflow to build the dbt project on production environment as a post-merge automatic workflow.

### Add a `deploy_to_prod_<fbalseiro>.yml` to workflows folder
Create a new file named `deploy_to_prod_<fbalseiro>.yml` (adjust that to your dbt development schema name) on the workflows folder (inside `.github` folder) and copy the content below:

```yaml
name: Deploy to Prod (Post Merge)

on:
  pull_request:
    types:
      - closed

  workflow_dispatch:

jobs:
  build-and-deploy:
    if: github.event.pull_request.merged == true
    runs-on: ubuntu-latest
    env:
      DBT_USER: ${{ secrets.DBT_USER }}
      DBT_PASSWORD: ${{ secrets.DBT_PASSWORD }}

    steps:
      - name: Checkout branch
        uses: actions/checkout@v3

      - name: Setup Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.10'
          
      - name: Install dbt
        run: pip3 install dbt-snowflake

      - name: Deploy & Test Models and Source freshness (PROD)
        working-directory: ./dbt
        run: |
          dbt deps
          dbt source freshness --profiles-dir . --target prod
          dbt build --profiles-dir . --target prod
          dbt run-operation drop_old_relations
```
I've added the `workflow_dispatch:` key that let's you trigger the workflow manually to test it by yourself.

Let's a do a deep dive on each dbt command used on the above workflow:

- `dbt deps`: Install the required packages listed in your `packages.yml` file
- `dbt source freshness --profiles-dir . --target prod`:  Tests freshness from sources listed on `_boardgames__sources.yml` using the `profiles.yml` file on the current working-directory and using the `production` environment as the target.
- `dbt build --profiles-dir . --target prod`: Builds all the models using the `profiles.yml` file on the current working-directory and using the `production` environment as the target. 
- `dbt run-operation drop_old_relations`: Invokes the macro `drop_old_relations` to drop materializations on Snowflake that don't have a dbt model associated to it. 

### Add a prod environment to your `profiles.yml`
To make sure that dbt can build the project to `--target prod` you have to add that environment properties into your `profiles.yml`.
Your file should look similar to this:

```yaml
# profiles.yml
boardgame_project:
  outputs:
    dev:
      account: jsa18243
      database: BOARDGAME
      password: "{{ env_var('DBT_PASSWORD') }}"
      role: transform
      schema: dbt_fbalseiro
      threads: 4
      type: snowflake
      user: "{{ env_var('DBT_USER') }}"
      warehouse: DBT_CERTIFICATION_PROJECT_WH
    ci:
      account: "{{ env_var('SNOWFLAKE_ACCOUNT') }}"
      database: "{{ env_var('SNOWFLAKE_DATABASE') }}"
      password: "{{ env_var('DBT_PASSWORD') }}"
      role: "{{ env_var('SNOWFLAKE_ROLE') }}"
      schema: dbt_ci
      threads: 4
      type: snowflake
      user: "{{ env_var('DBT_USER') }}"
      warehouse: "{{ env_var('SNOWFLAKE_WAREHOUSE') }}"
    prod:
      account: "{{ env_var('SNOWFLAKE_ACCOUNT') }}"
      database: "{{ env_var('SNOWFLAKE_DATABASE') }}"
      password: "{{ env_var('DBT_PASSWORD') }}"
      role: "{{ env_var('SNOWFLAKE_ROLE') }}"
      schema: dbt_prod
      threads: 4
      type: snowflake
      user: "{{ env_var('DBT_USER') }}"
      warehouse: "{{ env_var('SNOWFLAKE_WAREHOUSE') }}"
  target: dev

```

### Trigger the workflow
First, you should update the remote development branch by running `git push`.

Checkout this [video tutorial](https://www.loom.com/share/3ab7adf0ef964d679abce78abcac1f34?sid=54d61414-58eb-41b4-8f68-e24729426e5a) on how to trigger the workflow manually.

---

### Solution

- [deploy_to_prod_fbalseiro.yml](deploy_to_prod_fbalseiro.yml)

---

[Return to Project Challenges](../../../README.md#9-project-challenges)