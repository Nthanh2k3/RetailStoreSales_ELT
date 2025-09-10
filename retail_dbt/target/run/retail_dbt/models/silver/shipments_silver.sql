
  
    

  create  table "postgres"."silver"."shipments_silver__dbt_tmp"
  
  
    as
  
  (
    

select
  s.*
from "postgres"."silver_staging"."stg_shipments" as s
  );
  