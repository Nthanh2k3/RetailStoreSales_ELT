{% snapshot dim_brands_snapshot %}
{{
  config(
    unique_key='brand_id',
    strategy='check',
    check_cols='all',
    invalidate_hard_deletes=True
  )
}}
select * from {{ ref('brands_silver') }}
{% endsnapshot %}
