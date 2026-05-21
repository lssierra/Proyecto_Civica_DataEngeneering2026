{% snapshot snp_foreland_areas %}

{{
    config(
        target_shema='snapshots',
        unique_key='forelandarea_id',
        strategy='check',
        updated_at='_ingested_at',
        check_cols=['row_hash'],   
        hard_deletes='new_record'
    )
}}

select * from {{ ref('int_foreland_areas') }}

{% endsnapshot %}