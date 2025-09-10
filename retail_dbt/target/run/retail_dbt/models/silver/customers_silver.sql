
  
    

  create  table "postgres"."silver"."customers_silver__dbt_tmp"
  
  
    as
  
  (
    

select
  s.*
from "postgres"."silver_staging"."stg_customers" as s
  );
  