{% test snapshot_no_false_versions(model) %}

SELECT *
FROM (
    select
        docking_id, 
        docking_seq,
        row_hash,
        lag(row_hash) OVER (
            PARTITION BY docking_id, docking_seq
            ORDER BY dbt_valid_from
        ) AS hash_anterior,
        dbt_is_deleted
    FROM {{ model }}
)
where row_hash = hash_anterior
  AND dbt_is_deleted = 'False'

{% endtest %}