{% snapshot dim_promotions_snapshot %}
{{
  config(
    unique_key='promotion_id',
    strategy='check',
    check_cols='all',
    invalidate_hard_deletes=True
  )
}}
select * from {{ ref('promotions_silver') }}
{% endsnapshot %}
