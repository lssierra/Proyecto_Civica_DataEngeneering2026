{% set cols_para_hash = get_column_names(
    ref('int_ships_docked_today'),
    except=['_INGESTED_AT']
) %}

WITH with_hash as (
    select
        *,
        {{ dbt_utils.generate_surrogate_key(cols_para_hash) }} as row_hash
    from {{ ref('int_ships_docked_today') }}
)

SELECT * FROM with_hash