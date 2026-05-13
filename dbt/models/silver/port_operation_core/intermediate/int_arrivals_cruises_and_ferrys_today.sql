{% set cols_para_hash = get_column_names(
    ref('stg_port_operation__port_bcn_arrivals_cruises_and_ferrys_today_raw'),
    except=['_INGESTED_AT']
) %}


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
),

with_hash as (
    select
        *,
        {{ dbt_utils.generate_surrogate_key(cols_para_hash) }} as row_hash
    from deduplicated
    where rn = 1
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
_SOURCE_URL,
ROW_HASH
FROM with_hash