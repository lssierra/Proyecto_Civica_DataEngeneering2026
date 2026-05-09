with 

source as (

    select * from {{ source('master_files', 'MASTER_FILES_SUBFORELAND_AREAS') }}

),

renamed as (

    select
        idareaforeland,
        idsubareaforeland,
        nomsubareaforeland,
        _ingested_at,
        _source_url

    from source

)

select * from renamed