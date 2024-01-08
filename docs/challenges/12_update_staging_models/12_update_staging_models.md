# Exercise:

## Update staging models
On this challenge we do the follow-up on the failed tests that ocurred in [challenge #10](../10_add_generic_test/10_add_generic_test.md) that we've used to apply configuration of test severity on the [previous challenge](../11_config_test_severity/11_config_test_severity.md).

Now we're going to update the following staging models to update values < 1 to be = 1, doing the recommended approach covered [here](../10_add_generic_test/10_add_generic_test.md#additional-notes):

- stg_boardgames__reviews
- stg_boardgames__rankings

**Note:** The same approach is not applied also to `stg_boardgames__boardgames` model because the column `boardgame_avg_rating` had some records with 'nan' or 0 values that were updated to -1 to be filtered out on the next layer.

## Remove test severity config
Now that the issue with `review_rating` and `boardgame_bayes_avg_rating` is solved, the test should be applied to fail when there is 1 or more records with review_rating < 1.

---

### Solution

- [stg_boardgames__reviews.sql](./staging/stg_boardgames__reviews.sql)
- [_boardgames__models.yml](./staging/_boardgames__models.yml)

---

[Return to Project Challenges](../../../README.md#9-project-challenges)