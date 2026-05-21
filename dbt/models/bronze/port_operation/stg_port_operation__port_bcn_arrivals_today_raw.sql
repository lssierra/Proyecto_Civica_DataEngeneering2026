with 

source as (

    select * from {{ source('port_operation', 'PORT_BCN_ARRIVALS_TODAY_RAW') }}

),

renamed as (

    select
            ANYESCALA AS docking_year,
            ESCALANUM AS docking_id,
            ESCALAESTAT AS dockingstatus_desc,
            VAIXELLNOM AS ship_name,
            VAIXELLTIPUS AS shiptype_name,
            MMSI,
            IMO,
            CALLSIGN,
            ESLORA_METRES AS ship_length,
            CALAT_METRES AS ship_draft,
            MANEGA_METRES AS ship_width,
            VAIXELLBANDERACODI AS country_id,
            VAIXELLBANDERANOM AS country_name,
            NAVIERA AS shippingcompany_name,
            CODIGO_NAVIERA AS shippingcompany_id,
            CONSIGNATARI AS consignee,
            TERMINALCODI AS terminal_id,
            TERMINALNOM AS terminal_name,
            MOLLCODI AS dock_id,
            MOLLMODULS AS dock_modules,
            ESTOPERATIUID AS dockingstatus_id,
            ETADIA,
            ETAHORA,
            ETAUTC,
            ETA,
            ETDDIA,
            ETDHORA,
            ETDUTC,
            ETD,
            PORTORIGENCODI AS originport_id,
            PORTORIGENNOM AS originport_name,
            PORTDESTICODI AS destinationport_id,
            PORTDESTINOM AS destinationport_name,
            MESINFO AS marinetraffic_url,
            _INGESTED_AT,
            _SOURCE_URL

    from source

)

select * from renamed