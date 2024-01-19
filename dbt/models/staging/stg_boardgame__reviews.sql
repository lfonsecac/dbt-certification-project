with

source as (
    select * from {{ source('boardgame', 'reviews') }}
),

transformed as (
    select
        Id as review_id,
        User as review_user,
        cast(Rating as int) as review_rating
    from source
)

select * from transformed