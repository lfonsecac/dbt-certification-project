with

source as (
    select * from {{ source('boardgame', 'mechanics') }}
),

transformed as (
    select
        Mechanics as mechanich_name,
        Game_Id as mechanic_game_id
    from source
)

select * from transformed