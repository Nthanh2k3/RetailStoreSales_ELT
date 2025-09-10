
  
    

  create  table "postgres"."silver"."payments_silver__dbt_tmp"
  
  
    as
  
  (
    

select
  s.*
from "postgres"."silver_staging"."stg_payments" as s
  );
  