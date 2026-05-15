{% snapshot snp_port_bcn_locations %}

{{
    config(
        targuet_shema='snapshots',
        unique_key='dock_id',
        strategy='check',
        check_cols=['row_hash'],   -- solo detecta cambios reales de negocio
        hard_deletes='new_record'
    )
}}

select * from {{ ref('int_port_bcn_locations') }}

{% endsnapshot %}