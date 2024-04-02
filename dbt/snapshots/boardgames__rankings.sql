{% snapshot rankings %}

{{
    config(
      target_database='BOARDGAME',
      target_schema='dbt_lfonseca',
      unique_key='id',
      strategy='timestamp',
      updated_at='updated_at',
    )
}}

select 
    id,
    "Name",
    "Year",
    "Rank",
    "Average",
    "Bayes average",
    "Users rated",
    url,
    "Thumbnail",
    "updated_at" as updated_at
 
from {{ source('boardgame', 'rankings') }}

{% endsnapshot %}