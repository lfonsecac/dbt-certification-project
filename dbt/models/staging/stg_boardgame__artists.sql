with

source as (
    select * from {{ source('boardgame', 'artists') }}
),

transformed as (
    select
        case
            when Artists = '0' then '{{ var("unknown") }}'
            else Artists
        end as artist_name,

        Game_Id as artist_game_id

    from source
)

select * from transformed