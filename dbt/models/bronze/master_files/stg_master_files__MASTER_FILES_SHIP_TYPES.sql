with 

source as (

    select * from {{ source('master_files', 'MASTER_FILES_SHIP_TYPES') }}

),

renamed as (

    select
        idtipusvaixellapb,
        descripciotipusvaixellapb,
        _ingested_at,
        _source_url

    from source

)

select * from renamed