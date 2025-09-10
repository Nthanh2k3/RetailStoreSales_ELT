
  
    

  create  table "postgres"."silver_to_golden"."dim_campaigns__dbt_tmp"
  
  
    as
  
  (
    
select * from "postgres"."silver"."campaigns_silver"
  );
  