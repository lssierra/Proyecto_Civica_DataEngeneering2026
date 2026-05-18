{% snapshot snp_ships_departures_foreseen %}

{{
    config(
        target_shema='snapshots',
        unique_key='imo',
        strategy='check',
        check_cols=['row_hash'],   
        hard_deletes='new_record'
    )
}}

select 
imo,
ship_name,
ship_length,
ship_width,
ship_draft,
marinetraffic_url,
shiptype_id,
shiptype_name,
mmsi,
callsign,
row_hash

from {{ ref('departures_foreseen') }}

{% endsnapshot %}