{% snapshot dim_stores_snapshot %}
{{
  config(
    unique_key='store_id',
    strategy='check',
    check_cols='all',
    invalidate_hard_deletes=True
  )
}}
select * from {{ ref('stores_silver') }}
{% endsnapshot %}
