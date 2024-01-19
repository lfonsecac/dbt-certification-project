with

source as (
    select * from {{ source('boardgame', 'artists') }}
),

transformed as (
    select
        Artists as artist_name,
        Game_Id as artist_game_id
    from source
)

select * from transformed