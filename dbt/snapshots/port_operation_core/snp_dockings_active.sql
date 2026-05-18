{% snapshot snp_dockings_active %}

{{
    config(
        target_shema='snapshots',
        unique_key='docking_id',
        strategy='check',
        check_cols=['row_hash'],   
        hard_deletes='new_record'
    )
}}

select 
docking_id,
docking_year,
eta,
etd,
dockingstatus_id,
imo,
originport_id,
destinationport_id,
dock_id,
consignee,
dock_modules,
row_hash

from {{ ref('ships_docked_today') }}

{% endsnapshot %}