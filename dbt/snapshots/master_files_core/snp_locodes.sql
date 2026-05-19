{% snapshot snp_locodes %}

{{
    config(
        target_shema='snapshots',
        unique_key='location_id',
        strategy='check',
        updated_at='_ingested_at',
        check_cols=['row_hash'],   
        hard_deletes='new_record'
    )
}}

select * from {{ ref('int_locodes') }}

{% endsnapshot %}