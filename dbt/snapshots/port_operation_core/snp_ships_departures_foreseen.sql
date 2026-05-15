{% snapshot snp_ships_departures_foreseen %}

{{
    config(
        targuet_shema='snapshots',
        unique_key='imo',
        strategy='check',
        check_cols=['row_hash'],   -- solo detecta cambios reales de negocio
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
shippingcompany_id,
shippingcompany_name,
row_hash

from {{ ref('int_ships_departures_foreseen') }}

{% endsnapshot %}