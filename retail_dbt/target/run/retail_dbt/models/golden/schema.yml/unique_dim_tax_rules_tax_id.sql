
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    tax_id as unique_field,
    count(*) as n_records

from "postgres"."silver_to_golden"."dim_tax_rules"
where tax_id is not null
group by tax_id
having count(*) > 1



  
  
      
    ) dbt_internal_test