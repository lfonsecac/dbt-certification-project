{{ 
    simple_cte(
        [
            ('reviews', 'stg_boardgame__reviews'),
            ('users', 'stg_boardgame__users')
        ]
    )

}} 
select 
    *
from reviews
join users
    on reviews.review_used = users.user_id