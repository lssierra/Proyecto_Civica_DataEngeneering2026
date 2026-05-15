-- model name: int_arrivals_cruises_and_ferrys_today 
-- description: filters only latest day of ingestion from corresponding stage, deduplicates keeping only latest ingestion in case of multiple ingestions in a day, and returns casted columns 


WITH filtered AS(
SELECT *
FROM {{ ref('stg_port_operation__port_bcn_arrivals_cruises_and_ferrys_today_raw') }}
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
DOCKING_ID,
SHIP_NAME,
DOCK_ID,
TO_TIMESTAMP(
        CONCAT(YEAR(CURRENT_DATE())::VARCHAR, '-', ETA, ':00'),
        'YYYY-DD-MM HH24:MI:SS'
    ) AS ETA,
ORIGINPORT_NAME,
TO_TIMESTAMP(
        CONCAT(YEAR(CURRENT_DATE())::VARCHAR, '-', ETD, ':00'),
        'YYYY-DD-MM HH24:MI:SS'
    ) AS ETD,
DESTINATIONPORT_NAME,
_INGESTED_AT,
_SOURCE_URL
FROM deduplicated
WHERE rn =1