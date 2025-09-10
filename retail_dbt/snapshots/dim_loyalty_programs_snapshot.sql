{% snapshot dim_loyalty_programs_snapshot %}
{{
  config(
    unique_key='loyalty_program_id',
    strategy='check',
    check_cols='all',
    invalidate_hard_deletes=True
  )
}}
-- Bảng này trong danh sách của bạn là 'loyalty_programs' (không có _silver)
select * from {{ ref('loyalty_programs_silver') }}
{% endsnapshot %}
