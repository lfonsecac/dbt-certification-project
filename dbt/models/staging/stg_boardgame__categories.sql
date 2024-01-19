with

source as (
    select * from {{ source('boardgame', 'categories') }}
),

transformed as (
    select
        Categories as category_name,
        Game_Id as category_game_id
    from source
)

select * from transformed