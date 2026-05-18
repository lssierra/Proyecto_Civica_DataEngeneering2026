-- model name: int_subforeland_areeas
-- description: filters only latest day of ingestion from corresponding stage, deduplicates keeping only latest ingestion in case of multiple ingestions in a day, and returns casted columns 



{% set cols_para_hash = get_column_names(
    ref('stg_master_files__subforeland_areas'),
    except=['_INGESTED_AT']
) %}


WITH filtered AS(
SELECT *
FROM {{ ref('stg_master_files__subforeland_areas') }}
WHERE  (_INGESTED_AT::DATE)::VARCHAR = '{{var('date_of_analysis')}}'
),

deduplicated AS (
        select *,
        row_number() over (
            partition by forelandarea_id, subforelandarea_id
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
    forelandarea_id,
    subforelandarea_id,
    subforelandarea_name,
    _INGESTED_AT,
    row_hash
FROM with_hash