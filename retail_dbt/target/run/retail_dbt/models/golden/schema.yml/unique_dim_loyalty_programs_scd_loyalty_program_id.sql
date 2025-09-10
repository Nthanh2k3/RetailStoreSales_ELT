
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    loyalty_program_id as unique_field,
    count(*) as n_records

from "postgres"."silver_to_golden"."dim_loyalty_programs_scd"
where loyalty_program_id is not null
group by loyalty_program_id
having count(*) > 1



  
  
      
    ) dbt_internal_test