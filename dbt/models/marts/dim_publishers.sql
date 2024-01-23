with

publishers as (
    select * from {{ ref('stg_boardgame__publishers') }}
),

boardgames_filtered as (
    select * from {{ ref('int_boardgame__boardgames_filtered') }}
),

final as (
    select distinct
        {{ dbt_utils.generate_surrogate_key(['publisher_name', 'publishers.publisher_game_id']) }} as publisher_key,
        {{ dbt_utils.generate_surrogate_key(['publishers.publisher_game_id']) }} as boardgame_key,
        publisher_name

    from publishers
    where publisher_game_id in (select boardgame_id from boardgames_filtered)
)

select * from final