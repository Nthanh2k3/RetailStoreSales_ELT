
  
    

  create  table "postgres"."silver"."store_visits_silver__dbt_tmp"
  
  
    as
  
  (
    

select
  s.*
from "postgres"."silver_staging"."stg_store_visits" as s
  );
  