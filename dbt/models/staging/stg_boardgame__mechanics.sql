with

source as (
    select * from {{ source('boardgame', 'mechanics') }}
),

transformed as (
    select
        case
            when Mechanics = '0' then '{{ var("unknown") }}'
            else Mechanics
        end as mechanic_name,

        Game_Id as mechanic_game_id
    from source
)

select * from transformed