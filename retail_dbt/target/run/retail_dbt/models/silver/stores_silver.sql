
  
    

  create  table "postgres"."silver"."stores_silver__dbt_tmp"
  
  
    as
  
  (
    

select
  s.*
from "postgres"."silver_staging"."stg_stores" as s
  );
  