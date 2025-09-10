
  
    

  create  table "postgres"."silver"."purchase_orders_silver__dbt_tmp"
  
  
    as
  
  (
    

select
  s.*
from "postgres"."silver_staging"."stg_purchase_orders" as s
  );
  