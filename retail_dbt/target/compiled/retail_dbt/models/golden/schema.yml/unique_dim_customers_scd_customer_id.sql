
    
    

select
    customer_id as unique_field,
    count(*) as n_records

from "postgres"."silver_to_golden"."dim_customers_scd"
where customer_id is not null
group by customer_id
having count(*) > 1


