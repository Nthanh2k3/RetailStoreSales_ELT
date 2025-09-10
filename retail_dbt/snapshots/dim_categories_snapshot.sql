{% snapshot dim_categories_snapshot %}
{{
  config(
    unique_key='category_id',
    strategy='check',
    check_cols='all',
    invalidate_hard_deletes=True
  )
}}
select * from {{ ref('categories_silver') }}
{% endsnapshot %}
