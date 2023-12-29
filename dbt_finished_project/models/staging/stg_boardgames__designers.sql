with

designers as (

    select * from {{ source('boardgame', 'designers') }}

),

final as (

    select
        game_id as boardgame_id,
        designers as designer_name

    from designers

)

select * from final