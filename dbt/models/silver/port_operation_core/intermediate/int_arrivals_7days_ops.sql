-- model name: int_arrivals_7days_ops 
-- description: filters only latest day of ingestion from corresponding stage, deduplicates keeping only latest ingestion in case of multiple ingestions in a day, and returns casted columns 

WITH filtered AS(
SELECT *
FROM {{ ref('stg_port_operation__port_bcn_arrivals_7days_ops_raw') }}
WHERE _INGESTED_AT >= dateadd('day', -1, current_date)
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
SHIP_NAME,
REGEXP_REPLACE(
    DOCKING_ID,
    '^' || YEAR(CURRENT_DATE())::VARCHAR || '-',
    ''
) AS DOCKING_ID,
COUNTRY_ID,
COUNTRY_NAME,
IMO,
SHIPPINGCOMPANY_ID,
SHIPPINGCOMPANY_NAME,
CONSIGNEE,
SHIPTYPE_ID,
SHIPTYPE_NAME,
SHIP_LENGTH::FLOAT,
GT::FLOAT,
DOCK_ID,
DOCK_NAME,
DOCK_MODULES,
ETA::TIMESTAMP,
ETD::TIMESTAMP,
_INGESTED_AT,
_SOURCE_URL

FROM deduplicated
WHERE rn =1