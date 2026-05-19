{% snapshot snp_ship_operators %}

{{
    config(
        target_shema='snapshots',
        unique_key='shippingcompany_id',
        strategy='check',
        updated_at='_ingested_at',
        check_cols=['row_hash'],   
        hard_deletes='new_record'
    )
}}

select * from {{ ref('int_ship_operators') }}

{% endsnapshot %}