
  create view "postgres"."silver_staging"."stg_sales_transactions__dbt_tmp"
    
    
  as (
    

with source_data as (
    select * from "postgres"."raw"."sales_transactions"
),

final as (
    select
        cast(transaction_id as int) as transaction_id,
        cast(customer_id as int) as customer_id,
        cast(store_id as int) as store_id,
        cast(employee_id as int) as employee_id,
        cast(transaction_date as timestamp) as transaction_date,
        case
            when trim(upper(total_amount)) = 'N/A' then null
            else cast(total_amount as decimal(15,2))
        end as total_amount,
        cast(payment_id as int) as payment_id
    from source_data
    where transaction_id is not null
        and customer_id is not null
        and store_id is not null
        and employee_id is not null
        and transaction_date is not null
        and case
            when trim(upper(total_amount)) = 'N/A' then null
            else cast(total_amount as decimal(15,2))
        end is not null
        and payment_id is not null
        and case
            when trim(upper(total_amount)) = 'N/A' then null
            else cast(total_amount as decimal(15,2))
        end != 0
        and transaction_id != 'N/A'
        and customer_id != 'N/A'
        and store_id != 'N/A'
        and employee_id != 'N/A'
        and payment_id != 'N/A'
)

select * from final
  );