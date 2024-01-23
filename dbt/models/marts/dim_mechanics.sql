with

mechanics as (
    select * from {{ ref('stg_boardgame__mechanics') }}
),

boardgames_filtered as (
    select * from {{ ref('int_boardgame__boardgames_filtered') }}
),

final as (
    select distinct
        {{ dbt_utils.generate_surrogate_key(['mechanic_name', 'mechanics.mechanic_game_id']) }} as mechanic_key,
        {{ dbt_utils.generate_surrogate_key(['mechanics.mechanic_game_id']) }} as boardgame_key,
        mechanic_name

    from mechanics
    where mechanic_game_id in (select boardgame_id from boardgames_filtered)
)

select * from final