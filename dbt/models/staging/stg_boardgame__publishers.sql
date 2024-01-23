with

source as (
    select * from {{ source('boardgame', 'publishers') }}
),

transformed as (
    select
        case
            when Publishers = '0' then '{{ var("unknown") }}'
            else Publishers
        end as publisher_name,

        Game_Id as publisher_game_id
    from source
)

select * from transformed