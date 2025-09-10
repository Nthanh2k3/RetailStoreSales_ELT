
  create view "postgres"."silver_invalid"."sales_items_invalid__dbt_tmp"
    
    
  as (
    

with source_data as (
    select * from "postgres"."raw"."sales_items"
),

final as (
    select
        -- Primary key casting
        cast(item_id as int) as item_id,
        cast(transaction_id as int) as transaction_id,
        cast(product_id as int) as product_id,
        
        -- Quantity casting
        cast(quantity as int) as quantity,
        
        -- Price and monetary fields casting
        cast(unit_price as decimal(10,2)) as unit_price,
        cast(discount as decimal(10,2)) as discount,
        cast(tax as decimal(10,2)) as tax,
        
        -- Calculated fields
        cast(unit_price as decimal(10,2)) * cast(quantity as int) as gross_amount,
        (cast(unit_price as decimal(10,2)) * cast(quantity as int)) - 
         cast(discount as decimal(10,2)) + 
         cast(tax as decimal(10,2)) as net_amount,
        
        -- Business logic validation flags
        case 
            when cast(quantity as int) > 0 and cast(unit_price as decimal(10,2)) < 0 then 'invalid_positive_qty_negative_price'
            when cast(discount as decimal(10,2)) > cast(unit_price as decimal(10,2)) * cast(quantity as int) then 'discount_exceeds_gross'
            when cast(discount as decimal(10,2)) < 0 then 'negative_discount'
            when cast(tax as decimal(10,2)) < 0 then 'negative_tax'
            when cast(quantity as int) < 0 then 'negative_quantity'
            else 'valid'
        end as business_validation_flag
        
    from source_data
    
    -- Keep only invalid records
    where not (
        item_id is not null
        and transaction_id is not null  
        and product_id is not null
        and quantity is not null
        and unit_price is not null
        and discount is not null
        and tax is not null
        -- Business rules
        and cast(quantity as int) >= 0
        and cast(discount as decimal(10,2)) >= 0
        and cast(tax as decimal(10,2)) >= 0
        and cast(discount as decimal(10,2)) <= cast(unit_price as decimal(10,2)) * cast(quantity as int)
        and not (cast(quantity as int) > 0 and cast(unit_price as decimal(10,2)) < 0)
    )
)

select * from final
  );