{% snapshot snp_port_bcn_locations %}

{{
    config(
        target_shema='snapshots',
        unique_key='terminal_id',
        strategy='check',
        updated_at='_ingested_at',
        check_cols=['row_hash'],   
        hard_deletes='new_record'
    )
}}

select * from {{ ref('int_port_bcn_locations') }}

{% endsnapshot %}