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

s_sda AS (SELECT * FROM {{ ref('snp_ships_dockings_active') }} 
{% if is_incremental() %}
WHERE dbt_valid_to IS NULL AND dbt_is_deleted = 'False' AND _ingested_at > (SELECT MAX(_ingested_at) FROM {{this}})
{% endif %}
 ),

all_ids AS (
SELECT imo FROM s_saf 

INTERSECT

SELECT imo FROM s_sda 
),


a.imo,
COALESCE(saf.ship_length,sda.ship_length),
COALESCE(saf.ship_width,sda.ship_width),
saf.ship_draft,
MAX(saf._ingested_at, sdf._ingested_at, sda._ingested_at)
