
  
    

  create  table "postgres"."silver"."sales_transactions_silver__dbt_tmp"
  
  
    as
  
  (
    

select
  s.*
from "postgres"."silver_staging"."stg_sales_transactions" as s
  );
  