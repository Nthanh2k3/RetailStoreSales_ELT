
  
    

  create  table "postgres"."silver"."suppliers_silver__dbt_tmp"
  
  
    as
  
  (
    

select
  s.*
from "postgres"."silver_staging"."stg_suppliers" as s
  );
  