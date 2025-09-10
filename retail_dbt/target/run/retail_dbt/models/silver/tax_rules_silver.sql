
  
    

  create  table "postgres"."silver"."tax_rules_silver__dbt_tmp"
  
  
    as
  
  (
    

select
  s.*
from "postgres"."silver_staging"."stg_tax_rules" as s
  );
  