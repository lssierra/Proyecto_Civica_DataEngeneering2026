{% snapshot snp_ships_dockings_active %}

{{
    config(
        target_shema='snapshots',
        unique_key=['docking_id', 'docking_year', 'docking_seq'],
        strategy='check',
        updated_at='_ingested_at',
        check_cols=['row_hash'],   
        hard_deletes='new_record'
    )
}}

select 
docking_year,
docking_id,
docking_seq,
imo,
ship_name,
ship_length,
ship_width,   
COUNTRY_NAME,
_ingested_at,
row_hash

from {{ ref('ships_docked_today') }}

{% endsnapshot %}