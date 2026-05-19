{% snapshot snp_departures_foreseen %}

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
docking_id,
docking_year,
docking_seq,
eta,
etd,
dockingstatus_id,
imo,
originport_id,
destinationport_id,
dock_id,
consignee,
dock_modules,
_ingested_at,
row_hash

from {{ ref('departures_foreseen') }}

{% endsnapshot %}