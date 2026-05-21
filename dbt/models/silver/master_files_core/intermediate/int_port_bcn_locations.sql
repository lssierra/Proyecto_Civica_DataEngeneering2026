-- model name: int_port_bcn_locations
-- description: filters only latest day of ingestion from corresponding stage, deduplicates keeping only latest ingestion in case of multiple ingestions in a day, and returns casted columns 


{% set cols_para_hash = get_column_names(
    ref('stg_master_files__port_bcn_locations'),
    except=['_INGESTED_AT']
) %}


WITH filtered AS(
SELECT *
FROM {{ ref('stg_master_files__port_bcn_locations') }}
WHERE  (_INGESTED_AT::DATE)::VARCHAR  <= '{{var('date_of_analysis')}}' 
AND (_INGESTED_AT::DATE)::VARCHAR > dateadd('day', -7, ('{{var('date_of_analysis')}}')::DATE)::VARCHAR
),

deduplicated AS (
        select *,
        row_number() over (
            partition by terminal_id
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
        terminal_id,
        terminal_name,
        _INGESTED_AT,
        row_hash
FROM with_hash