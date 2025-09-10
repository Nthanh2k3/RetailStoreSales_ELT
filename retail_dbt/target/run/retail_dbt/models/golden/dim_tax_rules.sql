
  
    

  create  table "postgres"."silver_to_golden"."dim_tax_rules__dbt_tmp"
  
  
    as
  
  (
    
select * from "postgres"."silver"."tax_rules_silver"
  );
  