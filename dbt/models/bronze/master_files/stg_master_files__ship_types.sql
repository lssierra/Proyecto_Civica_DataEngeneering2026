with 

source as (

    select * from {{ source('master_files', 'MASTER_FILES_SHIP_TYPES') }}

),

renamed as (

    select
        IDTIPUSVAIXELLAPB AS shiptype_id,
        DESCRIPCIOTIPUSVAIXELLAPB AS shiptype_name,
        _INGESTED_AT,
        _SOURCE_URL

    from source

)

select * from renamed