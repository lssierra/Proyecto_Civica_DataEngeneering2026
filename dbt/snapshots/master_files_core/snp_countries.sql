{% snapshot snp_countries %}

{{
    config(
        target_shema='snapshots',
        unique_key='country_id',
        strategy='check',
        check_cols=['row_hash'],   
        hard_deletes='new_record'
    )
}}

select * from {{ ref('int_countries') }}

{% endsnapshot %}