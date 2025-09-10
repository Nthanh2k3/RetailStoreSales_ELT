
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    visit_id as unique_field,
    count(*) as n_records

from "postgres"."silver_to_golden"."fct_store_visits"
where visit_id is not null
group by visit_id
having count(*) > 1



  
  
      
    ) dbt_internal_test