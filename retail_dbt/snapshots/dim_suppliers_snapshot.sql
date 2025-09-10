{% snapshot dim_suppliers_snapshot %}
{{
  config(
    unique_key='supplier_id',
    strategy='check',
    check_cols='all',
    invalidate_hard_deletes=True
  )
}}
select * from {{ ref('suppliers_silver') }}
{% endsnapshot %}
