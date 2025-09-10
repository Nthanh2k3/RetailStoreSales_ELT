
    
    



select shipment_duration_days
from "postgres"."silver_to_golden"."fct_shipments"
where shipment_duration_days is null


