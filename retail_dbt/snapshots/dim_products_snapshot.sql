{% snapshot dim_products_snapshot %}
{{
  config(
    unique_key='product_id',
    strategy='check',
    check_cols='all',
    invalidate_hard_deletes=True
  )
}}
select * from {{ ref('products_silver') }}
{% endsnapshot %}
