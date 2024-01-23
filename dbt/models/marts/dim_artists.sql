with

artists as (
    select * from {{ ref('stg_boardgame__artists') }}
),

boardgames_filtered as (
    select * from {{ ref('int_boardgame__boardgames_filtered') }}
),

final as (
    select distinct

        {{ dbt_utils.generate_surrogate_key(['artist_name', 'artists.artist_game_id']) }} as artist_key,
        {{ dbt_utils.generate_surrogate_key(['artists.artist_game_id']) }} as boardgame_key,
        artist_name

    from artists
    where artist_game_id in (select boardgame_id from boardgames_filtered)
)

select * from final