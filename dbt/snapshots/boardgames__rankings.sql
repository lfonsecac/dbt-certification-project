{% snapshot rankings %}

{{
    config(
      target_schema='[your-schema]', --dbt_[first-initial-last-name] (ex: dbt_fbalseiro)
      unique_key='id',
      strategy='timestamp',
      updated_at='updated_at'
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