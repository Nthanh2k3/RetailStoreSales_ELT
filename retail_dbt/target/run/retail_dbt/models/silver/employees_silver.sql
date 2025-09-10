
  
    

  create  table "postgres"."silver"."employees_silver__dbt_tmp"
  
  
    as
  
  (
    

select
  s.*
from "postgres"."silver_staging"."stg_employees" as s
  );
  