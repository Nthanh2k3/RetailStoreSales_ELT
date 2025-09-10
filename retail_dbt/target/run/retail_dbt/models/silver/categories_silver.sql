
  
    

  create  table "postgres"."silver"."categories_silver__dbt_tmp"
  
  
    as
  
  (
    

select
  s.*
from "postgres"."silver_staging"."stg_categories" as s
  );
  