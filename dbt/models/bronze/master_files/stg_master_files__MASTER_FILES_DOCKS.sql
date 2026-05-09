with 

source as (

    select * from {{ source('master_files', 'MASTER_FILES_DOCKS') }}

),

renamed as (

    select
        NOMALINEACIO AS dock_name,
        CODALINEACIO AS dock_id,
        _INGESTED_AT,
        _SOURCE_URL

    from source

)

select * from renamed