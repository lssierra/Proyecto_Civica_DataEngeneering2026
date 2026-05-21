{{ config(
materialized='incremental',
incremental_strategy='append',
unique_key=['imo','eta']
) }}


WITH d AS (
SELECT
    docking_id,
    docking_year,
    docking_seq,
    eta,
    etd,
    originport_id,
    destinationport_id,
    dock_id,
    consignee,
    dock_modules,
    dbt_updated_at
FROM {{ ref('snp_arrivals_foreseen') }}
{% if is_incremental() %}
WHERE dbt_is_deleted = 'True' 
    AND dockingstatus_id = 'I' 
    AND docking_seq = 1 
    AND dbt_updated_at > (SELECT MAX(dbt_updated_at) FROM {{ this }})
{% else %}
WHERE dbt_is_deleted = 'True' 
    AND dockingstatus_id = 'I' 
    AND docking_seq = 1
{% endif %}
),

s AS (
SELECT
docking_id,
docking_year,
docking_seq,
imo,
ship_length,
ship_width,
ship_draft,
shiptype_id,
shippingcompany_id,
dbt_updated_at
FROM {{ ref('snp_ships_arrivals_foreseen') }}
{% if is_incremental() %}
WHERE dbt_is_deleted = 'True' 
    AND docking_seq = 1
    AND dbt_updated_at > (SELECT MAX(dbt_updated_at) FROM {{ this }})
{% else %}
WHERE dbt_is_deleted = 'True' 
    AND docking_seq = 1
{% endif %}
)

SELECT
d.docking_id,
d.docking_year,
d.docking_seq,
d.eta,
d.etd,
d.originport_id,
d.destinationport_id,
d.dock_id,
d.consignee,
d.dock_modules,

s.imo,
s.ship_length,
s.ship_width,
s.ship_draft,
s.shiptype_id,
s.shippingcompany_id,

d.dbt_updated_at

FROM d
INNER JOIN s
    ON d.docking_id = s.docking_id AND d.docking_year = s.docking_year AND d.docking_seq = s.docking_seq