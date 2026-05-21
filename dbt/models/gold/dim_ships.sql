

with s_saf AS (
SELECT 
    imo,
    MAX(ship_name) AS ship_name,
    MAX(country_id) AS country_id,
    MAX(country_name) AS country_name,
    MAX(marinetraffic_url) AS marinetraffic_url,
    MAX(shiptype_id) AS shiptype_id,
    MAX(shiptype_name) AS shiptype_name,
    MAX(mmsi) AS mmsi,
    MAX(callsign) AS callsign,
    MAX(shippingcompany_id) AS shippingcompany_id,
    MAX(shippingcompany_name) AS shippingcompany_name,
    MAX(_ingested_at) AS _ingested_at
FROM {{ ref('snp_ships_arrivals_foreseen') }}
where dbt_valid_to is null and dbt_is_deleted = 'False'
GROUP BY imo
),

s_sdf AS (
SELECT 
    imo,
    MAX(ship_name) AS ship_name,
    MAX(country_id) AS country_id,
    MAX(country_name) AS country_name,
    MAX(marinetraffic_url) AS marinetraffic_url,
    MAX(shiptype_id) AS shiptype_id,
    MAX(shiptype_name) AS shiptype_name,
    MAX(mmsi) AS mmsi,
    MAX(callsign) AS callsign,
    MAX(_ingested_at) AS _ingested_at
FROM {{ ref('snp_ships_departures_foreseen') }}
where dbt_valid_to is null and dbt_is_deleted = 'False'
GROUP BY imo
),

s_sda AS (
SELECT 
    imo,
    MAX(ship_name) AS ship_name,
    MAX(country_name) AS country_name,
    MAX(_ingested_at) AS _ingested_at
FROM {{ ref('snp_ships_dockings_active') }}
where dbt_valid_to is null and dbt_is_deleted = 'False'
GROUP BY imo
),

all_ids as (
    select imo from {{ ref('snp_ships_arrivals_foreseen') }}
    union
    select imo from {{ ref('snp_ships_departures_foreseen') }}
    union
    select imo from {{ ref('snp_ships_dockings_active') }}
),

joined AS (
select
    a.imo,
    COALESCE(sda.ship_name, sdf.ship_name, saf.ship_name) AS ship_name,
    COALESCE(sdf.country_id, saf.country_id) AS country_id,
    COALESCE(sda.country_name, sdf.country_name, saf.country_name) AS country_name,
    COALESCE(sdf.marinetraffic_url, saf.marinetraffic_url) AS marinetraffic_url,
    COALESCE(sdf.shiptype_id, saf.shiptype_id) AS shiptype_id,
    COALESCE(sdf.shiptype_name, saf.shiptype_name) AS shiptype_name,
    COALESCE(sdf.mmsi, saf.mmsi) AS mmsi,
    COALESCE(sdf.callsign, saf.callsign) AS callsign,
    saf.shippingcompany_id,
    saf.shippingcompany_name,
            CASE
            WHEN saf.imo IS NOT NULL
              OR sdf.imo IS NOT NULL
              OR sda.imo IS NOT NULL
                THEN true
            ELSE false
        END  AS is_active,
FROM all_ids AS a
LEFT JOIN s_saf AS saf 
    ON a.imo = saf.imo
LEFT JOIN s_sdf AS sdf 
    ON a.imo = sdf.imo
LEFT JOIN s_sda AS sda 
    ON a.imo = sda.imo
)

SELECT * FROM joined