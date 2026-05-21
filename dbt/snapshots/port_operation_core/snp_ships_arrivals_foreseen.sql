{% snapshot snp_ships_arrivals_foreseen %}

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
imo,
ship_name,
country_id,
country_name,
originport_id,
ship_length,
ship_width,
ship_draft,
marinetraffic_url,
shiptype_id,
shiptype_name,
mmsi,
callsign,
shippingcompany_id,
shippingcompany_name,
_ingested_at,
row_hash

from {{ ref('arrivals_foreseen') }}

{% endsnapshot %}