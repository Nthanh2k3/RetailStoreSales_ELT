
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    promotion_id as unique_field,
    count(*) as n_records

from "postgres"."silver_to_golden"."dim_promotions_scd"
where promotion_id is not null
group by promotion_id
having count(*) > 1



  
  
      
    ) dbt_internal_test