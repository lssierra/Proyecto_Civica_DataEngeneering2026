{% set cols_para_hash = get_column_names(
    ref('stg_port_operation__port_bcn_ships_docked_today_raw'),
    except=['_INGESTED_AT']
) %}


WITH filtered AS(
SELECT *
FROM {{ ref('stg_port_operation__port_bcn_ships_docked_today_raw') }}
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


select
    ship_name,
    docking_id,
    docking_seq,
    eta,
    etd,
    imo,
    CONSIGNEE,
    dock_id,
    initial_module,
    final_module,
    ship_length,
    ship_width,
    COUNTRY_NAME,
    _ingested_at,
    _source_url,
    row_hash

from source