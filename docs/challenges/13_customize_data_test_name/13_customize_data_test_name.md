# Exercise:

## Customize data test name
By default, dbt will synthesize a name for your generic test by concatenating:

- test name (`not_null`, `unique`, etc)
- model name (or source/seed/snapshot)
- column name (if relevant)
- arguments (if relevant, e.g. `values` for `accepted_values`)

It does not include any configurations for the test. If the concatenated name is too long, dbt will use a truncated and hashed version instead. The goal is to preserve unique identifiers for all resources in your project, including tests.

You may also define your own name for a specific test, via the name property.

**When might you want this?** dbt's default approach can result in some wonky (and ugly) test names. By defining a custom name, you get full control over how the test will appear in log messages and metadata artifacts. You'll also be able to select the test by that name.

Here is an example of how it works:
```yaml
version: 2

models:
  - name: orders
    columns:
      - name: status
        tests:
          - accepted_values:
              name: unexpected_order_status_today
              values: ['placed', 'shipped', 'completed', 'returned']
              config:
                where: "order_date = current_date"
```

```bash
$ dbt test --select unexpected_order_status_today
12:43:41  Running with dbt=1.1.0
12:43:41  Found 1 model, 1 test, 0 snapshots, 0 analyses, 167 macros, 0 operations, 1 seed file, 0 sources, 0 exposures, 0 metrics
12:43:41
12:43:41  Concurrency: 5 threads (target='dev')
12:43:41
12:43:41  1 of 1 START test unexpected_order_status_today ................................ [RUN]
12:43:41  1 of 1 PASS unexpected_order_status_today ...................................... [PASS in 0.03s]
12:43:41
12:43:41  Finished running 1 test in 0.13s.
12:43:41
12:43:41  Completed successfully
12:43:41
12:43:41  Done. PASS=1 WARN=0 ERROR=0 SKIP=0 TOTAL=1
```

As you may have noticed before, when we run the test for the `accepted_values` on `boardgames_type` we get this very long test name that is hard to understand. 

```bash
❯ dbt test -s "source:boardgame.boardgames" 
15:19:40  Running with dbt=1.7.4
15:19:40  Registered adapter: snowflake=1.7.1
15:19:40  Found 11 models, 1 snapshot, 51 tests, 2 seeds, 9 sources, 0 exposures, 0 metrics, 432 macros, 0 groups, 0 semantic models
15:19:40  
15:19:46  Concurrency: 1 threads (target='dev')
15:19:46  
15:19:46  1 of 11 START test source_accepted_values_boardgame_boardgames_type__bgsleeve__boardgame__boardgameaccessory__boardgameexpansion__boardgameissue__puzzle__rpgissue__rpgitem__videogame__videogamecompilation__videogameexpansion__videogamehardware  [RUN]
15:19:48  1 of 11 PASS source_accepted_values_boardgame_boardgames_type__bgsleeve__boardgame__boardgameaccessory__boardgameexpansion__boardgameissue__puzzle__rpgissue__rpgitem__videogame__videogamecompilation__videogameexpansion__videogamehardware  [PASS in 1.99s]
```

You can check [dbt docs](https://docs.getdbt.com/reference/resource-properties/data-tests#custom-data-test-name) for more details about custom data test name.

### Task: Create custom data test name for boardgames type
Apply the custom data test name configuration above to column `type` from `boardgames` source table.

**Note:** You can also apply the same logic to other tests, feel free to do that. The important thing is to be aware of this feature and learning on how to use when it can be useful.

---

### Solution

- [_boardgames__sources.yml](./staging/_boardgames__sources.yml)

---

[Return to Project Challenges](../../../README.md#9-project-challenges)