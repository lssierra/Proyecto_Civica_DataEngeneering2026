with 

source as (

    select * from {{ source('master_files', 'MASTER_FILES_PORT_BCN_LOCATIONS') }}

),

renamed as (

    select
        CODUBIEDI AS terminal_id,
        NOMUBICACIO AS terminal_name,
        _INGESTED_AT,
        _SOURCE_URL

    from source

)

select * from renamed