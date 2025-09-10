
    
    

select
    campaign_id as unique_field,
    count(*) as n_records

from "postgres"."silver"."campaigns_silver"
where campaign_id is not null
group by campaign_id
having count(*) > 1


