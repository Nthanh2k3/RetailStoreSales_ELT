
  
    

  create  table "postgres"."silver"."discount_rules_silver__dbt_tmp"
  
  
    as
  
  (
    

select
  s.*
from "postgres"."silver_staging"."stg_discount_rules" as s
  );
  