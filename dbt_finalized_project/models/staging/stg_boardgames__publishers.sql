with

publishers as (

    select * from {{ source('boardgame', 'publishers') }}

),

final as (

    select
        game_id as boardgame_id,
        publishers as publisher_name

    from publishers

)

select * from final