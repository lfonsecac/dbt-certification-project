with

source as (
    select * from {{ source('boardgame', 'designers') }}
),

transformed as (
    select
        Designers as designer_name,
        Game_Id as designer_game_id
    from source
)

select * from transformed