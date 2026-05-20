{{ config(
materialized='incremental',
unique_key='imo',
incremental_strategy='merge'
) }}

WITH s_saf AS (SELECT * FROM {{ ref('snp_ships_arrivals_foreseen') }} 
{% if is_incremental() %}
WHERE dbt_valid_to IS NULL AND dbt_is_deleted = 'False' AND _ingested_at > (SELECT MAX(_ingested_at) FROM {{this}})
{% endif %}
 ),

s_sdf AS (SELECT * FROM {{ ref('snp_ships_departures_foreseen') }} 
{% if is_incremental() %}
WHERE dbt_valid_to IS NULL AND dbt_is_deleted = 'False' AND _ingested_at > (SELECT MAX(_ingested_at) FROM {{this}})
{% endif %}
 ),

s_sda AS (SELECT * FROM {{ ref('snp_ships_dockings_active') }} 
{% if is_incremental() %}
WHERE dbt_valid_to IS NULL AND dbt_is_deleted = 'False' AND _ingested_at > (SELECT MAX(_ingested_at) FROM {{this}})
{% endif %}
 ),

all_ids AS (
SELECT imo FROM s_saf 

UNION 

SELECT imo FROM s_sdf 

UNION 

SELECT imo FROM s_sda 
),

joined AS (
SELECT
a.imo,
COALESCE(sda.ship_name, sdf.ship_name, saf.ship_name),
COALESCE(sdf.country_id, saf.country_id),
COALESCE(sda.country_name, sdf.country_name, saf.country_name),
COALESCE(sdf.ship_length, saf.ship_length),
COALESCE(sdf.ship_width, saf.ship_width),
COALESCE(sdf.ship_draft, saf.ship_draft),
COALESCE(sdf.marinetraffic_url, saf.marinetraffic_url),
COALESCE(sdf.shiptype_id, saf.shiptype_id),
COALESCE(sdf.shiptype_name, saf.shiptype_name),
COALESCE(sdf.mmsi, saf.mmsi),
COALESCE(sdf.callsign, saf.callsign),
saf.shippingcompany_id,
saf.shippingcompany_name,
MAX(saf._ingested_at, sdf._ingested_at, sda._ingested_at)

FROM all_ids AS a
LEFT JOIN s_saf AS saf
    ON a.imo = saf.imo
LEFT JOIN s_sdf AS sdf
    ON a.imo = sdf.imo
LEFT JOIN s_sda AS sda
    ON a.imo = sda.imo
)

SELECT * FROM joined