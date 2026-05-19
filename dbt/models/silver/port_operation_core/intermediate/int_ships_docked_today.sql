-- model name: int_ships_docked_today




WITH filtered AS(
SELECT *
FROM {{ ref('stg_port_operation__port_bcn_ships_docked_today_raw') }}
WHERE  (_INGESTED_AT::DATE)::VARCHAR  = '{{var('date_of_analysis')}}'
),

deduplicated AS (
        select *,
        row_number() over (
            partition by docking_id
            order by _INGESTED_AT desc
        ) as rn
    from filtered
),


 clean AS (
select
    ship_name,
    YEAR(('{{var('date_of_analysis')}}')::DATE)::INT AS docking_year,
    docking_id,
    docking_seq,
    eta,
    etd,
    imo,
    CONSIGNEE,
    dock_id,
    initial_module,
    final_module,
    REPLACE(SHIP_LENGTH,',','.')::float AS ship_length,
    REPLACE(SHIP_WIDTH,',','.')::float AS ship_width,   
    COUNTRY_NAME,
    _ingested_at,
    _source_url

from deduplicated
)

select * from clean