with 

source as (

    select * from {{ source('master_files', 'MASTER_FILES_SHIP_OPERATORS') }}

),

renamed as (

    select
        NAVILIERA AS shippingcompany_id,
        NOMCURT AS shippingcompany_name,
        IDLLOYDS AS shippingcompany_lloyds,
        _INGESTED_AT,
        _SOURCE_URL

    from source

)

select * from renamed