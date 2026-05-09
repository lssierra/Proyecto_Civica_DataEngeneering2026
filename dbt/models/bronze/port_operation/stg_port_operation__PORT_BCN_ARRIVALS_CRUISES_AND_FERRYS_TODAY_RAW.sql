with 

source as (

    select * from {{ source('port_operation', 'PORT_BCN_ARRIVALS_CRUISES_AND_FERRYS_TODAY_RAW') }}

),

renamed as (

    select
        numescala,
        nomvaixell,
        moll,
        arribada,
        origen,
        sortida,
        desti,
        _ingested_at,
        _source_url

    from source

)

select * from renamed