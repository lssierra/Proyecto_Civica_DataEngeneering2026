with 

source as (

    select * from {{ source('master_files', 'MASTER_FILES_SUBFORELAND_AREAS') }}

),

renamed as (

    select
        IDAREAFORELAND AS forelandarea_id,
        IDSUBAREAFORELAND AS subforelandarea_id,
        NOMSUBAREAFORELAND AS subforelandarea_name,
        _INGESTED_AT,
        _SOURCE_URL

    from source

)

select * from renamed