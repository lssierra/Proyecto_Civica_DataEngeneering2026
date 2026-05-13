{% set cols_para_hash = get_column_names(
    ref('stg_port_operation__port_bcn_arrivals_7days_ops_raw'),
    except=['_INGESTED_AT']
) %}


WITH filtered AS(
SELECT *
FROM {{ ref('stg_port_operation__port_bcn_arrivals_7days_ops_raw') }}
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
OPS_CONN_POSITION_ON_SHIP,
ETA::TIMESTAMP,
ETD::TIMESTAMP,
FIRST_CONNECTION::BOOL,
PREVIOUS_CONNECTIONS,
COMPATIBILY_REQUIRED,
EXPECTED_CONSUMPTION,
GANGWAY_BE_USED,
ADDITION_1,
ADDITION_2,
ADDITION_3,
_INGESTED_AT,
_SOURCE_URL,
ROW_HASH

FROM with_hash