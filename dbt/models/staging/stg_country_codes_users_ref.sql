with

source as (
    select * from {{ ref('country_codes_users_ref') }}
),

transformed as (
    select
        country_name,
        country_code 
    from source
)

select * from transformed