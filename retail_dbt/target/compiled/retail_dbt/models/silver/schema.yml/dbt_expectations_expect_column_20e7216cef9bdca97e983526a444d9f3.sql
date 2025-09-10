






    with grouped_expression as (
    select
        
        
    
  
( 1=1 and tax >= 0 and tax <= 100
)
 as expression


    from "postgres"."silver"."sales_items_silver"
    

),
validation_errors as (

    select
        *
    from
        grouped_expression
    where
        not(expression = true)

)

select *
from validation_errors







