with 

source as (

    select * from {{ source('port_operation', 'PORT_BCN_ARRIVALS_7DAYS_RAW') }}

),

renamed as (

    select
        anyescala,
        escalanum,
        escalaestat,
        vaixellnom,
        vaixelltipus,
        mmsi,
        imo,
        callsign,
        eslora_metres,
        calat_metres,
        manega_metres,
        vaixellbanderacodi,
        vaixellbanderanom,
        naviera,
        codigo_naviera,
        consignatari,
        terminalcodi,
        terminalnom,
        mollcodi,
        mollmoduls,
        estoperatiuid,
        etadia,
        etahora,
        etautc,
        eta,
        etddia,
        etdhora,
        etdutc,
        etd,
        portorigencodi,
        portorigennom,
        portdesticodi,
        portdestinom,
        mesinfo,
        _ingested_at,
        _source_url

    from source

)

select * from renamed