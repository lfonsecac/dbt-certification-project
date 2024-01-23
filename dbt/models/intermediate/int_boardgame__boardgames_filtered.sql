with

boardgames as (
    select * from {{ ref('stg_boardgame__boardgames') }}
),

boardgames_with_reviews as (
    select distinct boardgame_id
    from {{ ref('stg_boardgame__reviews') }}
),

/*
boardgames_filtered as (
    select b.*
    from boardgames b inner join boardgames_with_reviews r
    on b.boardgame_id = r.boardgame_id
    where 1=1
    and b.boardgame_type != 'not boardgame'
    and b.boardgame_avg_rating != -1
    and b.boardgame_avg_weight != -1
)
*/

boardgames_filtered as (
    select *
    from boardgames
    where boardgame_id in (select boardgame_id from boardgames_with_reviews)
    and boardgame_type = '{{ var("boardgame_type") }}'
    and boardgame_avg_rating != '{{ var("number_unknown") }}'
    and boardgame_avg_weight != '{{ var("number_unknown") }}'
)

select * from boardgames_filtered