with 

source as (

    select * from {{ source('master_files', 'MASTER_FILES_LOCODES') }}

),

renamed as (

    select
        unlocode,
        nomlocalitat,
        _ingested_at,
        _source_url

    from source

)

select * from renamed