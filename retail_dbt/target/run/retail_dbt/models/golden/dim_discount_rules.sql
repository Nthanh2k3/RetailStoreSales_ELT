
  
    

  create  table "postgres"."silver_to_golden"."dim_discount_rules__dbt_tmp"
  
  
    as
  
  (
    
select * from "postgres"."silver"."discount_rules_silver"
  );
  