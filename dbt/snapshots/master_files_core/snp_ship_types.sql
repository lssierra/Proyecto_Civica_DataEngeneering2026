{% snapshot snp_ship_types %}

{{
    config(
        target_shema='snapshots',
        unique_key='shiptype_id',
        strategy='check',
        updated_at='_ingested_at',
        check_cols=['row_hash'],   
        hard_deletes='new_record'
    )
}}

select * from {{ ref('int_ship_types') }}

{% endsnapshot %}