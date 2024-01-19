{% snapshot rankings_snapshot %}

{{
    config(
      target_database='boardgame',
      target_schema='dbt_ecidres',
      unique_key='id',

      strategy='timestamp',
      updated_at='"updated_at"',
    )
}}

select * from {{ source('boardgame', 'rankings') }}

{% endsnapshot %}