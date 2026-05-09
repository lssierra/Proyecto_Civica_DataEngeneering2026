with 

source as (

    select * from {{ source('port_operation', 'PORT_BCN_ARRIVALS_7DAYS_OPS_RAW') }}

),

renamed as (

    select
        ship_name,
        docking,
        flag_code,
        flag_name,
        imo,
        shipping_company_code,
        shipping_company_name,
        consignee,
        ship_type_code,
        ship_type_name,
        ship_length,
        gt,
        dock_position_code,
        dock_position_name,
        dock_position_modules,
        ops_conn_position_on_ship,
        eta,
        etd,
        first_connection,
        previous_connections,
        compatibily_required,
        expected_consumption,
        gangway_be_used,
        addition_1,
        addition_2,
        addition_3,
        _ingested_at,
        _source_url

    from source

)

select * from renamed