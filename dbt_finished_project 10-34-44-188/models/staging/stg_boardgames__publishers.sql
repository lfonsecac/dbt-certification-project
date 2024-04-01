with

publishers as (

    select * from {{ source('boardgame', 'publishers') }}

),

final as (

    select
        game_id as boardgame_id,
        case
            when publishers = '0' then '{{ var("unknown") }}'
            else publishers
        end as publisher_name

    from publishers

)

select * from final