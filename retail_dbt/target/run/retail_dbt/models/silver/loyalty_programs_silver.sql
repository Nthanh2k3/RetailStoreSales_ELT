
  
    

  create  table "postgres"."silver"."loyalty_programs_silver__dbt_tmp"
  
  
    as
  
  (
    

select
  s.*
from "postgres"."silver_staging"."stg_loyalty_programs" as s
  );
  