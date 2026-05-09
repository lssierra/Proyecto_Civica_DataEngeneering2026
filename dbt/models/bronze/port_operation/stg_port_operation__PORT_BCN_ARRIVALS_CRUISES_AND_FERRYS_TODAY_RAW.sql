with 

source as (

    select * from {{ source('port_operation', 'PORT_BCN_ARRIVALS_CRUISES_AND_FERRYS_TODAY_RAW') }}

),

renamed as (

    select
            NUMESCALA AS docking_id,
            NOMVAIXELL AS ship_name,
            MOLL AS dock_id,
            ARRIBADA AS ETA,
            ORIGEN AS originport_name,
            SORTIDA AS ETD,
            DESTI AS destinationport_name,
            _INGESTED_AT,
            _SOURCE_URL

    from source

)

select * from renamed