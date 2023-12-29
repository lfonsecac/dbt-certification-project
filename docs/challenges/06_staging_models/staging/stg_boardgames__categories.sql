with

categories as (

    select * from {{ source('boardgame', 'categories') }}

),

final as (

    select
        game_id as boardgame_id,
        categories as category_name

    from categories

)

select * from final