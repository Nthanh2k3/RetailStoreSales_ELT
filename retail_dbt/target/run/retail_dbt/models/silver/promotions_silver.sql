
  
    

  create  table "postgres"."silver"."promotions_silver__dbt_tmp"
  
  
    as
  
  (
    

select
  s.*
from "postgres"."silver_staging"."stg_promotions" as s
  );
  