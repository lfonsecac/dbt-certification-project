with

categories as (
    select * from {{ ref('stg_boardgame__categories') }}
),

boardgames_filtered as (
    select * from {{ ref('int_boardgame__boardgames_filtered') }}
),

final as (
    select distinct
        {{ dbt_utils.generate_surrogate_key(['category_name', 'categories.category_game_id']) }} as category_key,
        {{ dbt_utils.generate_surrogate_key(['categories.category_game_id']) }} as boardgame_key,
        category_name

    from categories
    where category_game_id in (select boardgame_id from boardgames_filtered)
)

select * from final