with 

source as (

    select * from {{ source('port_operation', 'PORT_BCN_ARRIVALS_7DAYS_OPS_RAW') }}

),

renamed as (

    select
            SHIP_NAME,
            DOCKING AS docking_id,
            FLAG_CODE AS country_id,
            FLAG_NAME AS country_name,
            IMO,
            SHIPPING_COMPANY_CODE AS shippingcompany_id,
            SHIPPING_COMPANY_NAME AS shippingcompany_name,
            CONSIGNEE,
            SHIP_TYPE_CODE AS shiptype_id,
            SHIP_TYPE_NAME AS shiptype_name,
            SHIP_LENGTH,
            GT,
            DOCK_POSITION_CODE AS dock_id,
            DOCK_POSITION_NAME AS dock_name,
            DOCK_POSITION_MODULES AS dock_modules,
            OPS_CONN_POSITION_ON_SHIP,
            ETA,
            ETD,
            FIRST_CONNECTION,
            PREVIOUS_CONNECTIONS,
            COMPATIBILY_REQUIRED,
            EXPECTED_CONSUMPTION,
            GANGWAY_BE_USED,
            ADDITION_1,
            ADDITION_2,
            ADDITION_3,
            _INGESTED_AT,
            _SOURCE_URL
    from source

)

select * from renamed