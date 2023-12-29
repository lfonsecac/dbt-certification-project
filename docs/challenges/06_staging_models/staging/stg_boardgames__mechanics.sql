with

mechanics as (

    select * from {{ source('boardgame', 'mechanics') }}

),

final as (

    select
        game_id as boardgame_id,
        mechanics as mechanic_name

    from mechanics

)

select * from final