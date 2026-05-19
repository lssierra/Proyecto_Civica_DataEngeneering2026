{% snapshot snp_arrivals_foreseen %}

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

from {{ ref('arrivals_foreseen') }}

{% endsnapshot %}