WITH s_ports AS (
SELECT * FROM {{ ref('snp_ports') }} WHERE dbt_valid_to IS NULL AND dbt_is_deleted = 'False'
), 
s_locodes AS (
SELECT * FROM {{ ref('snp_locodes') }} WHERE dbt_valid_to IS NULL AND dbt_is_deleted = 'False'
), 
s_countries AS (
SELECT * FROM {{ ref('snp_countries') }} WHERE dbt_valid_to IS NULL AND dbt_is_deleted = 'False'
), 
s_geo_areas AS (
SELECT * FROM {{ ref('snp_geo_areas') }} WHERE dbt_valid_to IS NULL AND dbt_is_deleted = 'False'
), 
s_foreland_areas AS (
SELECT * FROM {{ ref('snp_foreland_areas') }} WHERE dbt_valid_to IS NULL AND dbt_is_deleted = 'False'
), 
s_subforeland_areas AS (
SELECT * FROM {{ ref('snp_subforeland_areas') }} WHERE dbt_valid_to IS NULL AND dbt_is_deleted = 'False'
), 



add_ids AS (
SELECT
    p.location_id,
    p.country_id,
    p.geoarea_id,
    c.forelandarea_id,
    c.subforelandarea_id,
    c.econarea,
    l.location_name,
    c.country_name,
    g.geoarea_name

FROM s_ports AS p
LEFT JOIN s_locodes AS l 
    ON p.location_id = l.location_id
LEFT JOIN s_countries AS c 
    ON p.country_id = c.country_id
LEFT JOIN s_geo_areas AS g
    ON p.geoarea_id = g.geoarea_id
),


add_names AS (
SELECT
    i.location_id,
    i.country_id,
    i.geoarea_id,
    i.forelandarea_id,
    i.subforelandarea_id,
    i.econarea,
    i.location_name,
    i.country_name,
    i.geoarea_name,
    f.forelandarea_name,
    s.subforelandarea_name
FROM add_ids AS i
LEFT JOIN s_foreland_areas AS f
    ON i.forelandarea_id =  f.forelandarea_id
LEFT JOIN s_subforeland_areas AS s
    ON i.subforelandarea_id =  s.subforelandarea_id

)

SELECT * FROM add_names

