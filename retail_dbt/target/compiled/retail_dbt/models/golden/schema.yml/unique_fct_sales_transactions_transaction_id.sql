
    
    

select
    transaction_id as unique_field,
    count(*) as n_records

from "postgres"."silver_to_golden"."fct_sales_transactions"
where transaction_id is not null
group by transaction_id
having count(*) > 1


