select 
*
FROM {{ ref('snp_ship_operators') }}
WHERE dbt_is_deleted = 'False' AND dbt_valid_to IS NULL