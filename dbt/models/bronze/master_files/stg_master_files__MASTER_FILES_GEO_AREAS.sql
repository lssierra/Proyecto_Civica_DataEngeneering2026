with 

source as (

    select * from {{ source('master_files', 'MASTER_FILES_GEO_AREAS') }}

),

renamed as (

    select
        idareageografica,
        nomareageografica,
        _ingested_at,
        _source_url

    from source

)

select * from renamed