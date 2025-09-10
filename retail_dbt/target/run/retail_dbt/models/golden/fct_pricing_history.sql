
  
    

  create  table "postgres"."silver_to_golden"."fct_pricing_history__dbt_tmp"
  
  
    as
  
  (
    

with pricing_history_gold as (
    select
        ph.history_id,
        ph.product_id,
        ph.price,
        ph.effective_date,
        p.name as product_name,
        c.name as category_name,
        b.name as brand_name,
        s.name as supplier_name,
        date_part('year', ph.effective_date) as effective_year,
        date_part('month', ph.effective_date) as effective_month
    from "postgres"."silver"."pricing_history_silver" ph
    left join "postgres"."silver"."products_silver" p on ph.product_id = p.product_id
    left join "postgres"."silver"."categories_silver" c on p.category_id = c.category_id
    left join "postgres"."silver"."brands_silver" b on p.brand_id = b.brand_id
    left join "postgres"."silver"."suppliers_silver" s on p.supplier_id = s.supplier_id
    where ph.history_id is not null
        and ph.product_id is not null
        and ph.price is not null
        and ph.effective_date is not null
        and p.name is not null and p.name != 'N/A'
        and c.name is not null and c.name != 'N/A'
        and b.name is not null and b.name != 'N/A'
        and s.name is not null and s.name != 'N/A'
)

select * from pricing_history_gold
  );
  