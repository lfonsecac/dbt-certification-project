# Exercise:

## Add Cron Job in GitHub
Like we've seen on the [previous challenge](../24_add_ci_workflow/24_add_ci_workflow.md), we can use GitHub Actions to automate workflows.

In this challenge, we're using a cron job to schedule a daily run of our dbt project.

### Add a `scheduled_daily_run_<fbalseiro>.yml` to workflows folder
Create a new file named `scheduled_daily_run_<fbalseiro>.yml` on the workflows folder (inside `.github` folder) and copy the content below:

```yaml
name: Scheduled daily run

on:
  schedule:
    - cron: '0 11 * * *'  # This schedule runs the workflow every day at 11:00AM UTC

  workflow_dispatch:

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    env:
      DBT_USER: ${{ secrets.DBT_USER }}
      DBT_PASSWORD: ${{ secrets.DBT_PASSWORD }}
      SNOWFLAKE_ACCOUNT: ${{ secrets.SNOWFLAKE_ACCOUNT }}
      SNOWFLAKE_WAREHOUSE: ${{ secrets.SNOWFLAKE_WAREHOUSE }}
      SNOWFLAKE_DATABASE: ${{ secrets.SNOWFLAKE_DATABASE }}
      SNOWFLAKE_ROLE: ${{ secrets.SNOWFLAKE_ROLE }}

    steps:
      - name: Checkout repository
        uses: actions/checkout@v2
        with:
          ref: feature_fbalseiro

      - name: Set up Python
        uses: actions/setup-python@v3
        with:
          python-version: 3.9

      - name: Install dbt
        run: pip3 install dbt-snowflake

      - name: Deploy & Test Models and Source freshness
        working-directory: ./dbt_finished_project
        run: |
          dbt deps
          dbt source freshness --profiles-dir .
          dbt build -s +tag:daily+ --profiles-dir .
          dbt run-operation drop_old_relations
```

We're using the schedule with cron as an event to trigger the workflow on a daily basis.
I've also added the `workflow_dispatch:` key that let's you trigger the workflow manually to test it by yourself.

I've also added the `ref` property under the `Checkout repository` step so you can specify your github development branch to schedule this workflow to run on that branch.

Let's a do a deep dive on each dbt command used on the above workflow:

- `dbt deps`: Install the required packages listed in your `packages.yml` file
- `dbt source freshness --profiles-dir .`:  Tests freshness from sources listed on `_boardgames__sources.yml` using the `profiles.yml` file on the current working-directory
- `dbt build -s +tag:daily+ --profiles-dir .`: Builds all the models with the `daily` tag, and all of its parents and children using the `profiles.yml` file on the current working-directory. 
- `dbt run-operation drop_old_relations`: Invokes the macro `drop_old_relations` to drop materializations on Snowflake that don't have a dbt model associated to it. 

### Trigger the workflow
First, you should update the remote development branch by running `git push`.

Checkout this [video tutorial](https://www.loom.com/share/3862212f88584756906b59aa573517e1?sid=0aeababd-7e35-4d13-9fca-159b4ac4cae4) on how to add GitHub Secrets to your repository.

If you want to learn more about GitHub Actions workflows, follow [this](https://docs.github.com/en/actions/security-guides/using-secrets-in-github-actions#using-secrets-in-a-workflow).

---

### Solution

- [scheduled_daily_run_fbalseiro.yml](scheduled_daily_run_fbalseiro.yml)

---

[Return to Project Challenges](../../../README.md#9-project-challenges)