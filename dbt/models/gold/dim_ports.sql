WITH add_ids AS (
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

FROM {{ ref('snp_ports') }} AS p
LEFT JOIN {{ ref('snp_locodes') }} AS l 
    ON p.location_id = l.location_id
LEFT JOIN {{ ref('snp_countries') }} AS c 
    ON p.country_id = c.country_id
LEFT JOIN {{ ref('snp_geo_areas') }} AS g
    ON p.geoarea_id = c.geoarea_id
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
    f.subforelandarea_name,
    s.subforelandarea_name
FROM add_ids AS i
LEFT JOIN {{ ref('snp_foreland_areas') }} AS f
    ON i.forelandarea_id =  f.forelandarea_id
LEFT JOIN {{ ref('snp_subforeland_areas') }} AS s
    ON i.subforelandarea_id =  s.subforelandarea_id

)

