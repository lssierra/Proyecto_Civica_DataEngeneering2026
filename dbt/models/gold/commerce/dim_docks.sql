select 
*
FROM {{ ref('snp_docks') }}
WHERE dbt_is_deleted = 'False' AND dbt_valid_to IS NULL