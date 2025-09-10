
  
    

  create  table "postgres"."silver"."customer_feedback_silver__dbt_tmp"
  
  
    as
  
  (
    

select
  s.*
from "postgres"."silver_staging"."stg_customer_feedback" as s
  );
  