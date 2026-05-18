{% snapshot snp_ship_types %}

{{
    config(
        target_shema='snapshots',
        unique_key='dock_id',
        strategy='check',
        check_cols=['row_hash'],   
        hard_deletes='new_record'
    )
}}

select * from {{ ref('int_ship_types') }}

{% endsnapshot %}