{% snapshot dim_customers_snapshot %}
{{
  config(
    unique_key='customer_id',
    strategy='check',
    check_cols='all',
    invalidate_hard_deletes=True
  )
}}
select * from {{ ref('customers_silver') }}
{% endsnapshot %}
