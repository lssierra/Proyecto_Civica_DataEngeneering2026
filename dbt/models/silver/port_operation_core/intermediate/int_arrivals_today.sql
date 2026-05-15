-- model name: int_arrivals_today 
-- description: filters only latest day of ingestion from corresponding stage, deduplicates keeping only latest ingestion in case of multiple ingestions in a day, and returns casted columns 

WITH filtered AS(
SELECT *
FROM {{ ref('stg_port_operation__port_bcn_arrivals_today_raw') }}
WHERE _INGESTED_AT >= dateadd('day', -2, current_date)
),

deduplicated AS (
        select *,
        row_number() over (
            partition by docking_id
            order by _INGESTED_AT desc
        ) as rn
    from filtered
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
_SOURCE_URL
FROM deduplicated
WHERE rn =1