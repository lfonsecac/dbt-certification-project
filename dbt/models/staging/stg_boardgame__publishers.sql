with

source as (
    select * from {{ source('boardgame', 'publishers') }}
),

transformed as (
    select
        Publishers as publisher_name,
        Game_Id as publisher_game_id
    from source
)

select * from transformed