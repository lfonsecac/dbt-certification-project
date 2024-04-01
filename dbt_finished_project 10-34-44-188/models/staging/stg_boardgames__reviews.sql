with

reviews as (

    select * from {{ source('boardgame', 'reviews') }}

),

final as (

    select
        user as review_username,
        id as boardgame_id,
        round(
            cast(
                case
                    when cast(rating as float) < 1 then '{{ var("min_accepted_num") }}'
                    else rating
                end as int
            ), 0
        ) as review_rating

    from reviews

)

select * from final