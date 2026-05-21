with 

source as (

    select * from {{ source('master_files', 'MASTER_FILES_FORELAND_AREAS') }}

),

renamed as (

    select
        IDAREAFORELAND AS forelandarea_id,
        NOMAREAFORELAND AS forelandarea_name,
        _INGESTED_AT,
        _SOURCE_URL

    from source

)

select * from renamed