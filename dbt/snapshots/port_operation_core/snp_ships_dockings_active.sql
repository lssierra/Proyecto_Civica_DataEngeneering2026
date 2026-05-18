{% snapshot snp_ships_dockings_active %}

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
shippingcompany_id,
shippingcompany_name,
row_hash

from {{ ref('ships_docked_today') }}

{% endsnapshot %}