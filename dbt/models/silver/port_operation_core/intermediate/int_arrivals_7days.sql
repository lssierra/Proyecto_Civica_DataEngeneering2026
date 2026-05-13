{% set cols_para_hash = get_column_names(
    ref('stg_port_operation__port_bcn_arrivals_7days_raw'),
    except=['_INGESTED_AT']
) %}


WITH filtered AS(
SELECT *
FROM {{ ref('stg_port_operation__port_bcn_arrivals_7days_raw') }}
WHERE _INGESTED_AT >= dateadd('day', -2, current_date)
),

deduplicated AS (
        select *,
        row_number() over (
            partition by docking_id
            order by _INGESTED_AT desc
        ) as rn
    from filtered
),

with_hash as (
    select
        *,
        {{ dbt_utils.generate_surrogate_key(cols_para_hash) }} as row_hash
    from deduplicated
    where rn = 1
)

SELECT 
DOCKING_YEAR::INT,
DOCKING_ID,
DOCKINGSTATUS_DESC,
SHIP_NAME,
SHIPTYPE_NAME,
MMSI::INT,
IMO,
CALLSIGN,
REPLACE(SHIP_LENGTH,',','.')::float AS ship_length,
REPLACE(SHIP_DRAFT,',','.')::float AS ship_draft,
REPLACE(SHIP_WIDTH,',','.')::float AS ship_width,
COUNTRY_ID,
COUNTRY_NAME,
SHIPPINGCOMPANY_NAME,
SHIPPINGCOMPANY_ID,
CONSIGNEE,
TERMINAL_ID,
TERMINAL_NAME,
DOCK_ID,
DOCK_MODULES,
DOCKINGSTATUS_ID,
ETADIA::DATE,
ETAHORA::TIME,
ETAUTC::TIMESTAMP,
ETA::TIMESTAMP,
ETDDIA::DATE,
ETDHORA::TIME,
ETDUTC::TIMESTAMP,
ETD::TIMESTAMP,
ORIGINPORT_ID,
ORIGINPORT_NAME,
DESTINATIONPORT_ID,
DESTINATIONPORT_NAME,
MARINETRAFFIC_URL,
_INGESTED_AT,
_SOURCE_URL,
ROW_HASH


FROM with_hash