with 

source as (

    select * from {{ source('port_operation', 'PORT_BCN_SHIPS_DOCKED_TODAY_RAW') }}

),

renamed as (

    select
        nomvaixell AS ship_name,
        numescala AS docking_id,
        seqatracada AS docking_seq,
        eta,
        etd,
        vaicodimo AS imo,
        usunomraosocial as CONSIGNEE,
        codalineacio as dock_id,
        modinicial AS initial_module,
        modfinal AS final_module,
        eslora AS ship_length,
        manega AS ship_width,
        nompais AS COUNTRY_NAME,
        _ingested_at,
        _source_url

    from source

)

select * from renamed