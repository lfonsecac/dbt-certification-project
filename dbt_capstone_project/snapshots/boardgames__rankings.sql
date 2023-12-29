{% snapshot boardgames__rankings %}

{{
    config(
      target_schema='snapshots',
      unique_key='id',
      strategy='timestamp',
      updated_at='date'
    )
}}

select * from {{ source('boardgame', 'rankings') }}

{% endsnapshot %}