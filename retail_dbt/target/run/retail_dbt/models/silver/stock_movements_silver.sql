
  
    

  create  table "postgres"."silver"."stock_movements_silver__dbt_tmp"
  
  
    as
  
  (
    

select
  s.*
from "postgres"."silver_staging"."stg_stock_movements" as s
  );
  