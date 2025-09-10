
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    shipment_id as unique_field,
    count(*) as n_records

from "postgres"."silver_to_golden"."fct_shipments"
where shipment_id is not null
group by shipment_id
having count(*) > 1



  
  
      
    ) dbt_internal_test