{% snapshot snp_dockings_active %}

{{
    config(
        target_shema='snapshots',
        unique_key=['docking_id', 'docking_year', 'docking_seq'],
        strategy='check',
        check_cols=['row_hash'],   
        hard_deletes='new_record'
    )
}}

select 
docking_year,
docking_id,
docking_seq,
eta,
etd,
CONSIGNEE,
dock_id,
initial_module,
final_module,
_ingested_at,
row_hash

from {{ ref('ships_docked_today') }}

{% endsnapshot %}