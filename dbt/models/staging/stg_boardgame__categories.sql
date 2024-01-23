with

source as (
    select * from {{ source('boardgame', 'categories') }}
),

transformed as (
    select
        case
            when Categories = '0' then '{{ var("unknown") }}'
            else Categories
        end as category_name,

        Game_Id as category_game_id
    from source
)

select * from transformed