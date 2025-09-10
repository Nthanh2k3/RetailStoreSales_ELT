

with customer_feedback_gold as (
    select
        cf.feedback_id,
        cf.customer_id,
        cf.store_id,
        cf.product_id,
        cf.rating,
        cf.comments,
        cf.feedback_date,
        c.name as customer_name,
        sto.name as store_name,
        p.name as product_name,
        date_part('year', cf.feedback_date) as feedback_year,
        date_part('month', cf.feedback_date) as feedback_month,
        date_part('day', cf.feedback_date) as feedback_day
    from "postgres"."silver"."customer_feedback_silver" cf
    left join "postgres"."silver"."customers_silver" c on cf.customer_id = c.customer_id
    left join "postgres"."silver"."stores_silver" sto on cf.store_id = sto.store_id
    left join "postgres"."silver"."products_silver" p on cf.product_id = p.product_id
    where cf.feedback_id is not null
        and cf.customer_id is not null
        and cf.store_id is not null
        and cf.product_id is not null
        and cf.rating is not null
        and cf.comments is not null and cf.comments != 'N/A'
        and cf.feedback_date is not null
        and c.name is not null and c.name != 'N/A'
        and sto.name is not null and sto.name != 'N/A'
        and p.name is not null and p.name != 'N/A'
)

select * from customer_feedback_gold