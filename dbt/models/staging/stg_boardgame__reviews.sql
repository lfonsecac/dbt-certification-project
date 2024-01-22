with

source as (
    select * from {{ source('boardgame', 'reviews') }}
),

transformed as (
    select
        Id as review_id,
        User as review_user,
        
        cast(
            case
                when Rating < 1 then 1
                else Rating
            end as int
        ) as review_rating

    from source
)

select * from transformed