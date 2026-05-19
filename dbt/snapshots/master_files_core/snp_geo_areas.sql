{% snapshot snp_geo_areas %}

{{
    config(
        target_shema='snapshots',
        unique_key='geoarea_id',
        strategy='check',
        check_cols=['row_hash'],   
        hard_deletes='new_record'
    )
}}

select * from {{ ref('int_geo_areas') }}

{% endsnapshot %}