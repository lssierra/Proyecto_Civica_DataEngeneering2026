{% snapshot snp_ports %}

{{
    config(
        target_shema='snapshots',
        unique_key=['location_id', 'country_id', 'geoarea_id' ],
        strategy='check',
        updated_at='_ingested_at',
        check_cols=['row_hash'],   
        hard_deletes='new_record'
    )
}}

select * from {{ ref('int_ports') }}

{% endsnapshot %}