with

artists as (

    select * from {{ source('boardgame', 'artists') }}

),

final as (

    select
        game_id as boardgame_id,
        artists as artist_name

    from artists

)

select * from final