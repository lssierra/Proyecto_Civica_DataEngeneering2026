{% test unique_docking_combination(model) %}

SELECT
    docking_id,
    docking_year,
    docking_seq,
    COUNT(*) AS n
FROM {{ model }}
GROUP BY  docking_year, docking_id, docking_seq
HAVING COUNT(*) > 1

{% endtest %}