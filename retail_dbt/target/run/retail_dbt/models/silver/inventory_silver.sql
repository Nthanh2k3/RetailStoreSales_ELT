
  
    

  create  table "postgres"."silver"."inventory_silver__dbt_tmp"
  
  
    as
  
  (
    

select
  s.*
from "postgres"."silver_staging"."stg_inventory" as s
  );
  