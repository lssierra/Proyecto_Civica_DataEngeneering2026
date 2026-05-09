with 

source as (

    select * from {{ source('master_files', 'MASTER_FILES_DOCKS') }}

),

renamed as (

    select
        codalineacio,
        nomalineacio,
        _ingested_at,
        _source_url

    from source

)

select * from renamed