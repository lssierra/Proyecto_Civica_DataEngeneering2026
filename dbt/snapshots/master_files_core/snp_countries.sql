{% snapshot snp_countries %}

{{
    config(
        targuet_shema='snapshots',
        unique_key='country_id',
        strategy='check',
        check_cols=['row_hash'],   -- solo detecta cambios reales de negocio
        hard_deletes='new_record'
    )
}}

select * from {{ ref('int_countries') }}

{% endsnapshot %}