
  
    

  create  table "postgres"."silver"."returns_silver__dbt_tmp"
  
  
    as
  
  (
    

select
  s.*
from "postgres"."silver_staging"."stg_returns" as s
  );
  