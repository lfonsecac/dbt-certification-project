with

reviews as (

    select * from {{ source('boardgame', 'reviews') }}

),

final as (

    select
        user as review_username,
        id as boardgame_id,
        rating as review_rating

    from reviews

)

select * from final