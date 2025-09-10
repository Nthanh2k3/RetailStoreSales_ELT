
  
    

  create  table "postgres"."silver"."sales_items_silver__dbt_tmp"
  
  
    as
  
  (
    

select
  s.*
from "postgres"."silver_staging"."stg_sales_items" as s
  );
  