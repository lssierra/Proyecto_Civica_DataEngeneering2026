{% snapshot snp_ships_departures_foreseen %}

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
ship_length,
ship_width,
ship_draft,
marinetraffic_url,
shiptype_id,
shiptype_name,
mmsi,
callsign,
_ingested_at,
row_hash

from {{ ref('departures_foreseen') }}

{% endsnapshot %}