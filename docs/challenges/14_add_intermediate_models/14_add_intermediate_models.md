# Exercise:

## Add Intermediate Models
Let’s take a look at the intermediate layer of our project to understand the purpose of this stage more concretely.

```yaml
models/intermediate
└── finance
    ├── _int_finance__models.yml
    └── int_payments_pivoted_to_orders.sql
```

These are the main properties and best practices about intermediate models:
- Folders
  - Subdirectories based on business groupings.
- File Names
  - `int_[entity]_[verb]s.sql`. Examples of *verbs*: `pivoted`, `aggregated_to_user`, `joined`, `summed`, `filtered`, etc
- Not exposed to end users
- Materialized ephemerally. This means that the output is encapsulated under a CTE statement, not physically materialized on the data warehouse
- Materialized as views in a custom schema with special permissions. This is a more robust alternative to the previous approach that can be very useful specially when the complexity of your models grows.

You can check [dbt docs](https://docs.getdbt.com/best-practices/how-we-structure/3-intermediate) for more details about intermediate models.

### Task: Create Intermediate Models
On this layer we are going to address some issues with our models and prepare them for the next layer (data marts):
- Datasets extracted at different times that we need to adjust to assure relationships between them:
  - 2019: `users` and `reviews`
  - 2023: `artists`, `boardgames`, `categories`, `designers`, `mechanics`, `publishers`, `reviews`
  - up-to-date: `rankings`
- Filter out records based on the following (model.column):
  - `stg_boardgames__boardgames.boardgame_type`: remove records with value `not boardgame`
  - `stg_boardgames__boardgames.boardgame_avg_rating`: remove records with value `-1`
  - `stg_boardgames__boardgames.boardgame_avg_weight`: remove records with value `-1`

You're going to define the following intermediate models:
- int_users_countries_joined
- int_boardgames__boardgames_filtered
- int_boardgames__artists_filtered
- int_boardgames__boardgames_filtered
- int_boardgames__categories_filtered
- int_boardgames__designers_filtered
- int_boardgames__mechanics_filtered
- int_boardgames__publishers_filtered
- int_boardgames__rankings_filtered

**Note:** Don't forget that you should also create a `_int__models.yml` to specify the properties of these models.

---

### Solution

[TBD]

---

[Return to Project Challenges](../../../README.md#9-project-challenges)