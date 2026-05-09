with 

source as (

    select * from {{ source('master_files', 'MASTER_FILES_PORT_BCN_LOCATIONS') }}

),

renamed as (

    select
        codubiedi,
        nomubicacio,
        _ingested_at,
        _source_url

    from source

)

select * from renamed