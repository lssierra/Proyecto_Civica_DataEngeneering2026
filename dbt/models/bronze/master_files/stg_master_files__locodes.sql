with 

source as (

    select * from {{ source('master_files', 'MASTER_FILES_LOCODES') }}

),

renamed as (

    select
        UNLOCODE AS location_id,
        NOMLOCALITAT AS location_name,
        _INGESTED_AT,
        _SOURCE_URL

    from source

)

select * from renamed