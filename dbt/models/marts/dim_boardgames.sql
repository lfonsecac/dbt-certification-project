with

boardgames_filtered as (
    select * from {{ ref('int_boardgame__boardgames_filtered') }}
),

final as (
    select distinct
        {{ dbt_utils.generate_surrogate_key(['boardgames_filtered.boardgame_id']) }} as boardgame_key,
        boardgame_id,
        boardgame_name,
        boardgame_avg_rating,
        boardgame_avg_weight,
        boardgame_year_published,
        boardgame_min_players,
        boardgame_max_players,
        boardgame_min_play_time as boardgame_min_play_time_in_mins,
        boardgame_max_play_time as boardgame_max_play_time_in_mins,
        boardgame_min_age,
        boardgame_owned_by as boardgame_total_owners

    from boardgames_filtered
)

select * from final