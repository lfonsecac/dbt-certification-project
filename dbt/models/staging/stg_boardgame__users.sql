with

source as (
    select * from {{ source('boardgame', 'users') }}
),

transformed as (
    select
        Users as user_id,
        Url as user_url,
        case 
            when Country is null or Country = 'NA'
            then 'Uknown'
            else Country
        end as user_country
    from source
)

select * from transformed