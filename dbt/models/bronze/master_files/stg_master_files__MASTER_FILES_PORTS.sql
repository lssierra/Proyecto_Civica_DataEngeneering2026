with 

source as (

    select * from {{ source('master_files', 'MASTER_FILES_PORTS') }}

),

renamed as (

    select
        UNLOCODE AS location_id,
        NOMLOCALITAT AS location_name,
        ISOPAIS AS country_id,
        NOMPAIS AS country_name,
        AREGEOGRAFICA AS geoarea_id,
        NOMAREAGEOGRAFICA AS geoarea_name,
        _INGESTED_AT,
        _SOURCE_URL

    from source

)

select * from renamed