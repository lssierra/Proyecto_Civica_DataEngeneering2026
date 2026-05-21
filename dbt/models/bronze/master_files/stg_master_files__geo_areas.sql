with 

source as (

    select * from {{ source('master_files', 'MASTER_FILES_GEO_AREAS') }}

),

renamed as (

    select
        IDAREAGEOGRAFICA AS geoarea_id,
        NOMAREAGEOGRAFICA AS geoarea_name,
        _INGESTED_AT,
        _SOURCE_URL

    from source

)

select * from renamed