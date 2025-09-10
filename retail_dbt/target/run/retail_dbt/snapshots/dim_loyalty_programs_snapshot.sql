
      
  
    

  create  table "postgres"."silver"."dim_loyalty_programs_snapshot"
  
  
    as
  
  (
    
    

    select *,
        md5(coalesce(cast(loyalty_program_id as varchar ), '')
         || '|' || coalesce(cast(now()::timestamp without time zone as varchar ), '')
        ) as dbt_scd_id,
        now()::timestamp without time zone as dbt_updated_at,
        now()::timestamp without time zone as dbt_valid_from,
        
  
  coalesce(nullif(now()::timestamp without time zone, now()::timestamp without time zone), null)
  as dbt_valid_to
from (
        

-- Bảng này trong danh sách của bạn là 'loyalty_programs' (không có _silver)
select * from "postgres"."silver"."loyalty_programs_silver"
    ) sbq



  );
  
  