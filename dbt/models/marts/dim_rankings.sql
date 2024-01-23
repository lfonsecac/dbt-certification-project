with

rankings as (
    select * from {{ ref('stg_boardgame__rankings') }}
),

boardgames_filtered as (
    select * from {{ ref('int_boardgame__boardgames_filtered') }}
),

final as (
    select
        ranking_key,
        {{ dbt_utils.generate_surrogate_key(['rankings.boardgame_id']) }} as boardgame_key,
        boardgame_name,
        boardgame_rank,
        boardgame_total_reviews,
        boardgame_url,
        boardgame_thumbnail,
        "updated_at",
        valid_from,
        valid_to,
        is_current

    from rankings
    where boardgame_id in (select boardgame_id from boardgames_filtered)
)

select * from final