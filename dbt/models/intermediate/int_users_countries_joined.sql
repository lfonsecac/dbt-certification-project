with

users as (
    select * from {{ ref('stg_boardgame__users') }}
),

countries as (
    select * from {{ ref('stg_country_codes') }}
),

countries_users_ref as (
    select * from {{ ref('stg_country_codes_users_ref') }}
),

users_countries_joined as (
    select 
        u.user_id,
        u.user_url,
        u.user_country,
        coalesce(c.country_code, r.country_code) as user_country_code
    from users u 
    left join countries c
    on u.user_country = c.country_name 
    left join countries_users_ref r
    on u.user_country = r.country_name
)

select * from users_countries_joined