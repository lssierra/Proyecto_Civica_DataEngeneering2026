-- model name: int_countries
-- description: filters only latest day of ingestion from corresponding stage, deduplicates keeping only latest ingestion in case of multiple ingestions in a day, and returns casted columns 


{% set cols_para_hash = get_column_names(
    ref('stg_master_files__countries'),
    except=['_INGESTED_AT']
) %}


WITH filtered AS(
SELECT *
FROM {{ ref('stg_master_files__countries') }}
WHERE  (_INGESTED_AT::DATE)::VARCHAR  <= '{{var('date_of_analysis')}}' 
AND (_INGESTED_AT::DATE)::VARCHAR > dateadd('day', -7, ('{{var('date_of_analysis')}}')::DATE)::VARCHAR
),

deduplicated AS (
        select *,
        row_number() over (
            partition by country_id
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
    country_id,
    country_name,
    econarea,
    forelandarea_id,
    subforelandarea_id,
    _INGESTED_AT,
    row_hash
FROM with_hash