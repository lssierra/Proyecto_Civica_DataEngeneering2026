with 

source as (

    select * from {{ source('master_files', 'MASTER_FILES_FORELAND_AREAS') }}

),

renamed as (

    select
        idareaforeland,
        nomareaforeland,
        _ingested_at,
        _source_url

    from source

)

select * from renamed