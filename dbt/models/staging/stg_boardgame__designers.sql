with

source as (
    select * from {{ source('boardgame', 'designers') }}
),

transformed as (
    select
        case
            when Designers = '0' then '{{ var("unknown") }}'
            else Designers
        end as designer_name,

        Game_Id as designer_game_id
        
    from source
)

select * from transformed