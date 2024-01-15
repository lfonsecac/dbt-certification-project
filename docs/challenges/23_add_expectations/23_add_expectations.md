# Exercise:

## Advanced testing with dbt-expectations

dbt-expectations is a dbt package inspired by the Great Expectations project, so let’s cover Great Expectations first.

**Note:** This is not a topic covered on dbt Analytics Engineering Certification Exam, although it is important to be aware how you can leverage your tests using this package.

### Great Expectations
Great Expectations is among the most popular open-source projects for data-pipeline testing available today. It supports up to 300 expectation definitions (a.k.a. tests). If you want to look for outliers, regulate the number of values of a categorical variable, or test geocoordinates, Great Expectations probably has a test for it you can use. Now, many of its tests are available in dbt, too!

### How to install dbt-expectations
1. Check [this](https://hub.getdbt.com/calogica/dbt_expectations/latest/) url and add the recommended lines to the `packages.yml` file on your dbt project folder.

2. Once you've done that, install the package using the following command `dbt deps` and dbt will install the package under the `dbt_packages` folder on your dbt project folder.

**Note:** Everytime you execute the command `dbt clean` you must the run `dbt deps` to install your packages again. That happens because by default dbt have defined `target` and `dbt_packages` as the `clean-targets`. You can update the `clean-targets` list and remove `dbt_packages` if you don't want to repeat this process.

### Task: Use dbt-expectations to run tests on your project

#### expect_table_row_count_to_equal_other_table
**Definition:** Makes sure that a transformation (like a data cleansing step) doesn’t change the shape of the source table. ([link](https://github.com/calogica/dbt-expectations/tree/0.10.1/?tab=readme-ov-file#expect_table_row_count_to_equal_other_table))

We're going to apply this test to the following models:
- dim_users (compare with source table)
- dim_boardgames (compare with `int_boardgames__boardgames_filtered` model)

To run the tests you can use the selection by `test_name`:

```bash
dbt test -s test_name:expect_table_row_count_to_equal_other_table
```

#### expect_column_distinct_count_to_equal_other_table
**Definition:** Expect the number of distinct column values to be equal to number of distinct values in another model. ([link](https://github.com/calogica/dbt-expectations/tree/0.10.1/?tab=readme-ov-file#expect_column_distinct_count_to_equal_other_table))

We're going to apply this test to the following models:
- dim_artists
- dim_categories
- dim_designers
- dim_mechanics
- dim_publishers

All the above tests should be compared to dim_boardgames using `boardgame_key`.

To run the tests you can use the selection by `test_name`:

```bash
dbt test -s test_name:expect_column_distinct_count_to_equal_other_table
```

#### expect_column_values_to_be_of_type
**Definition:** Expect a column to be of a specified data type. ([link](https://github.com/calogica/dbt-expectations/tree/0.10.1/?tab=readme-ov-file#expect_column_values_to_be_of_type))

Apply this test to the following columns from the sources:

**Artists:**
- game_id: number

**Boardgames:**
- game_id: number
- max_players: number
- max_play_time: number
- min_players: number
- min_play_time: number
- min_age: number
- year_published: number

**Rankings:**
- Rank: number

To run the tests you can use the selection by `test_name`:

```bash
dbt test -s test_name:expect_column_values_to_be_of_type
```


#### expect_column_values_to_match_regex
**Definition:** Validates a value against a regular expression.

Apply this test to the following columns from the sources:

**Boardgames and Rankings:**
- <u>year_published / year</u>: Check with a regular expression if it has only numbers if a max length of 4 digits, taking into consideration that you can have negative numbers, corresponding to a year B.C


**Note:** This can get messy because we're dealing with 2 platforms (dbt and Snowflake) that need to escape special characters, so in this scenario we'll have to apply 4 backslashes (`\`) before `d` to escpace this special character.
To test more about regular expressions you can use the following [website](https://regex101.com/).

To run the tests you can use the selection by `test_name`:

```bash
dbt test -s test_name:expect_column_values_to_match_regex
```

---

### Solution

- [_boardgames__sources.yml](_boardgames__sources.yml)
- [_core__models.yml](_core__models.yml)
- [packges.yml](packages.yml) 

---

[Return to Project Challenges](../../../README.md#9-project-challenges)