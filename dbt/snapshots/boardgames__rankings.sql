{% snapshot rankings %}

{{
    config(
<<<<<<< HEAD
      target_database='BOARDGAME',
      target_schema='dbt_lfonseca',
      unique_key='id',
      strategy='timestamp',
      updated_at='updated_at',
=======
      target_schema='[your-schema]', --dbt_[first-initial-last-name] (ex: dbt_fbalseiro)
      unique_key='id',
      strategy='timestamp',
      updated_at='updated_at'
>>>>>>> 536de3c6c9ab9ae43636fd35508e63007f0ae7c8
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