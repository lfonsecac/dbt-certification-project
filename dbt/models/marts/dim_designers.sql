with

designers as (
    select * from {{ ref('stg_boardgame__designers') }}
),

boardgames_filtered as (
    select * from {{ ref('int_boardgame__boardgames_filtered') }}
),

final as (
    select distinct
        {{ dbt_utils.generate_surrogate_key(['designer_name', 'designers.designer_game_id']) }} as designer_key,
        {{ dbt_utils.generate_surrogate_key(['designers.designer_game_id']) }} as boardgame_key,
        designer_name

    from designers
    where designer_game_id in (select boardgame_id from boardgames_filtered)
)

select * from final