
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    rule_id as unique_field,
    count(*) as n_records

from "postgres"."silver_to_golden"."dim_discount_rules"
where rule_id is not null
group by rule_id
having count(*) > 1



  
  
      
    ) dbt_internal_test