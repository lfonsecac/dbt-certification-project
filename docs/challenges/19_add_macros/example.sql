{{
    config(
        materialized = "view"
    )
}}

{{ 
    simple_cte(
        [
            ('reviews', 'stg_boardgames__reviews'),
            ('users', 'stg_boardgames__users')
        ]
    )

}} 
select 
    *
from reviews
join users
    on reviews.review_username = users.user_username