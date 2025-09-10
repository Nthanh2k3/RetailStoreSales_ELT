

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
        cast(payment_id as int) as payment_id,
        case
            when transaction_id is null or transaction_id = 'N/A' then 'invalid_transaction_id'
            when customer_id is null or customer_id = 'N/A' then 'invalid_customer_id'
            when store_id is null or store_id = 'N/A' then 'invalid_store_id'
            when employee_id is null or employee_id = 'N/A' then 'invalid_employee_id'
            when transaction_date is null then 'invalid_transaction_date'
            when case
                when trim(upper(total_amount)) = 'N/A' then null
                else cast(total_amount as decimal(15,2))
            end is null or case
                when trim(upper(total_amount)) = 'N/A' then null
                else cast(total_amount as decimal(15,2))
            end = 0 then 'invalid_total_amount'
            when payment_id is null or payment_id = 'N/A' then 'invalid_payment_id'
            else 'valid'
        end as invalid_reason
    from source_data
    where not (
        transaction_id is not null
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
)

select * from final