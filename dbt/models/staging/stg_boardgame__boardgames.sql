with

source as (
    select * from {{ source('boardgame', 'boardgames') }}
),

transformed as (
    select
        Game_Id as boardgame_id,
        Name as boardgame_name,
        
        case
            when type = 'boardgame' then '{{ var("boardgame_type") }}'
            else 'not boardgame'
        end as boardgame_type,
        
        cast(
            case
                when Rating = 'nan' then 1
                when Rating < 1 then 1
                else Rating
            end as float
        ) as boardgame_avg_rating,

        cast(
            case
                when Weight = 'nan' then 1
                when Weight < 1 then 1
                else Weight
            end as float
        ) as boardgame_avg_weight,

        Year_published as boardgame_year_published,

        case
            when Min_Players = 0 then 1
            else Min_Players
        end as boardgame_min_players,

        case
            when Max_Players = 0 then 1
            else Max_Players
        end as boardgame_max_players,

        case
            when Min_Play_Time = 0 then 1
            else Min_Play_Time
        end as boardgame_min_play_time,

        case
            when Max_Play_Time = 0 then 1
            else Max_Play_Time
        end as boardgame_max_play_time,

        case
            when Min_Age = 0 then 1
            else Min_Age
        end as boardgame_min_age,

        case
            when Owned_by = 'nan' then 0
            else Owned_by
        end as boardgame_owned_by    

    from source
)

select * from transformed