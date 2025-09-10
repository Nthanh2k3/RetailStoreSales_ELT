
  
    

  create  table "postgres"."silver"."pricing_history_silver__dbt_tmp"
  
  
    as
  
  (
    

select
  s.*
from "postgres"."silver_staging"."stg_pricing_history" as s
  );
  