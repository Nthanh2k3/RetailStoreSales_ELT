{% snapshot dim_employees_snapshot %}
{{
  config(
    unique_key='employee_id',
    strategy='check',
    check_cols='all',
    invalidate_hard_deletes=True
  )
}}
select * from {{ ref('employees_silver') }}
{% endsnapshot %}
