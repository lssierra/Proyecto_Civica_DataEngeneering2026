with 

source as (

    select * from {{ source('master_files', 'MASTER_FILES_SHIP_OPERATORS') }}

),

renamed as (

    select
        naviliera,
        nomcurt,
        idlloyds,
        _ingested_at,
        _source_url

    from source

)

select * from renamed