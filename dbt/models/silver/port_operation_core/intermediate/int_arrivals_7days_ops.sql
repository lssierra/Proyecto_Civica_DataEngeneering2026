-- model name: int_arrivals_7days_ops 
-- description: filters only latest day of ingestion from corresponding stage, deduplicates keeping only latest ingestion in case of multiple ingestions in a day, and returns casted columns 

WITH filtered AS(
SELECT *
FROM {{ ref('stg_port_operation__port_bcn_arrivals_7days_ops_raw') }}
WHERE (_INGESTED_AT::DATE)::VARCHAR = '{{var('date_of_analysis')}}'
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

SPLIT_PART(docking_id, '-', 1)::INT AS docking_year,       
SPLIT_PART(docking_id, '-', 2)::INT AS docking_id,   
SPLIT_PART(docking_id, '-', 3)::INT AS docking_seq,   
SHIP_NAME,
COUNTRY_ID,
COUNTRY_NAME,
IMO,
SHIPPINGCOMPANY_ID,
SHIPPINGCOMPANY_NAME,
CONSIGNEE,
SHIPTYPE_ID,
SHIPTYPE_NAME,
REPLACE(SHIP_LENGTH,',','.')::float AS ship_length,
REPLACE(GT,',','.')::float AS GT,
DOCK_ID,
DOCK_NAME,
DOCK_MODULES,
ETA::TIMESTAMP AS ETA,
ETD::TIMESTAMP AS ETD,
1.0 AS ops,
_INGESTED_AT,
_SOURCE_URL

FROM deduplicated
WHERE rn = 1