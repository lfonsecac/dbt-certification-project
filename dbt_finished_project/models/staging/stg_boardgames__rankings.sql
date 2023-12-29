with

rankings as (

    select * from {{ ref('rankings') }}

),

final as (

    select
        id as boardgame_id,
        "Name" as boardgame_name,
        "Year" as boardgame_year_published,
        "Rank" as boardgame_rank,
        "Average" as boardgame_avg_rating,
        "Bayes average" as boardgame_bayes_avg_rating,
        "Users rated" as boardgame_total_reviews,
        CONCAT('https://boardgamegeek.com', url) as boardgame_url,
        "Thumbnail" as boardgame_thumbnail,
        updated_at,
        dbt_valid_from as valid_from,
        coalesce(
            date(dbt_valid_to),
            cast( '{{ var("the_distant_future") }}' as timestamp)
        ) as valid_to

    from rankings

)

select * from final