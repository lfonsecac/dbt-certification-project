with

source as (
    select * from {{ source('boardgame', 'reviews') }}
),

transformed as (
    select
        Id as boardgame_id,

        case
            when User = '0' then '{{ var("unknown") }}'
            else User
        end as review_user,
        
        cast(
            case
                when Rating < 1 then {{ var('min_accepted_num') }}
                else Rating
            end as int
        ) as review_rating

    from source
)

select * from transformed