with

users as (

    select * from {{ source('boardgame', 'users') }}

),

final as (

    select
        users as user_username,
        url as user_url,
        country as user_country

    from users

)

select * from final