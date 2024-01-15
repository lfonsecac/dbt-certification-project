# Exercise:

## Create automated workflows

### GitHub Actions
GitHub Actions enables to create automated workflows directly through GitHub.

If you want to learn more about GitHub Actions workflows, follow [this](https://docs.github.com/en/actions/using-workflows/about-workflows).

#### Add ci environment to profiles.yml
Update your `profiles.yml` file to add a `ci` environment specifically for the Continuous Integration workflow.

```yaml
boardgame_project: # name of the profile described on dbt_project.yml
  outputs:
    dev:
      account: jsa18243
      database: BOARDGAME
      password: dbtPassword123
      role: transform
      schema: [your-schema] # dbt_[first-initial-last-name] (ex: dbt_fbalseiro)
      threads: 4
      type: snowflake
      user: dbt
      warehouse: DBT_CERTIFICATION_PROJECT_WH
    ci:
     account: jsa18243
      database: BOARDGAME
      password: "{{ env_var('DBT_PASSWORD') }}"
      role: transform
      schema: [your-schema] # dbt_[first-initial-last-name] (ex: dbt_fbalseiro)
      threads: 4
      type: snowflake
      user: "{{ env_var('DBT_USER') }}"
      warehouse: DBT_CERTIFICATION_PROJECT_WH
  target: dev
```

#### Add GitHub Secrets
Secrets are variables created in a repository environment that are available to use in GitHub Actions workflows. 
This is the way to share credentials to use in GitHub Actions workflows without being available in plain text.

Checkout this [video tutorial](https://www.loom.com/share/3862212f88584756906b59aa573517e1?sid=0aeababd-7e35-4d13-9fca-159b4ac4cae4) on how to add GitHub Secrets to your repository.

If you want to learn more about GitHub Actions workflows, follow [this](https://docs.github.com/en/actions/security-guides/using-secrets-in-github-actions#using-secrets-in-a-workflow).

#### Use Secrets & Create CI Workflow
1. Create a folder `.github` under the repository main folder `dbt-certification-project`.
2. Create a folder `workflows` under the `.github` folder.
3. Create a `ci.yml` file inside `workflows` using [this template](ci.yml).
4. Adjust the last step of the job to the name of the directory where you dbt project is

#### Trigger the Workflow

The workflow is triggered automatically when there is a `pull request` action to the main branch.

Check this [video](https://www.loom.com/share/8187c09713514f7bb8ec402a0dff4ec3?sid=6af4f3b1-1dc6-46fb-adfa-7a4533d53a77) to see how it works.


---

### Solution

- [ci.yml](ci.yml)

---

[Return to Project Challenges](../../../README.md#9-project-challenges)