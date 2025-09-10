
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    return_id as unique_field,
    count(*) as n_records

from "postgres"."silver"."returns_silver"
where return_id is not null
group by return_id
having count(*) > 1



  
  
      
    ) dbt_internal_test