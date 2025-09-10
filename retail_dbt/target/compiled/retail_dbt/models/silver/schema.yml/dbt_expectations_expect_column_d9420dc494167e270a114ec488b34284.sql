






    with grouped_expression as (
    select
        
        
    
  
( 1=1 and rating >= 0 and rating <= 5
)
 as expression


    from "postgres"."silver"."customer_feedback_silver"
    

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







