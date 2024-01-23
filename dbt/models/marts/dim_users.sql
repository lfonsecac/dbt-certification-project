with

users_countries_joined as (
    select * from {{ ref('int_users_countries_joined') }}
),

final as (
    select distinct
        {{ dbt_utils.generate_surrogate_key(['users_countries_joined.user_id']) }} as user_key,
        user_id as user_username,
        user_url,
        user_country as country_name

    from users_countries_joined
)

select * from final