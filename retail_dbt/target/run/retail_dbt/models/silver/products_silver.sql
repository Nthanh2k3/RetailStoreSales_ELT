
  
    

  create  table "postgres"."silver"."products_silver__dbt_tmp"
  
  
    as
  
  (
    

select
  s.*
from "postgres"."silver_staging"."stg_products" as s
  );
  