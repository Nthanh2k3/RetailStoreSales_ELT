






    with grouped_expression as (
    select
        
        
    
  
( 1=1 and tax_rate >= 0 and tax_rate <= 100
)
 as expression


    from "postgres"."silver"."tax_rules_silver"
    

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







